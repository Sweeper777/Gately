import UIKit
import SwiftyUtils

class GameViewController: UIViewController {
    @IBOutlet var gameView: GameView!
    
    let speed: CGFloat = -0.33333333
    
    var signalLine: Line!
    var signalLineSignal: Signal = true {
        didSet {
            signalLine.color = signalLineSignal ? .green : .black
        }
    }
    var dot: Dot!
    var lastLineObject: Line!
    var lastX: CGFloat {
        return lastLineObject.position.x + lastLineObject.length
    }
    
    var lastY: CGFloat {
        return lastLineObject.position.y
    }
    
    override func viewDidLoad() {
        gameView.delegate = self
        signalLine = Line(position: CGPoint(x: 0, y: 0.5), velocity: (0, 0), zIndex: 1, length: 0.1, horizontal: true, color: .green)
        gameView.gameObjects.append(signalLine)
        dot = Dot(position: CGPoint(x: 0.1, y: 0.5), zIndex: 2)
        gameView.gameObjects.append(dot)
        lastLineObject = Line(position: CGPoint(x: 0, y: 0.5), velocity: (speed, 0), zIndex: 0, length: 1, horizontal: true, color: .gray)
        gameView.gameObjects.append(lastLineObject)
        addNewGameObjects()
        addNewGameObjects()
    }
    
    private func addGateWithOtherInput(gateSupplier: (CGPoint, (CGFloat, CGFloat), Int, Signal) -> Gate) {
        let firstPartLength = CGFloat.random(in: 0.35...0.65)
        let otherInputLength = CGFloat.random(in: 0.35...1) * firstPartLength
        let secondPartLength = 1 - firstPartLength
        let newLastY: CGFloat
        let otherInputY: CGFloat
        let otherInputX = lastX + firstPartLength - otherInputLength
        let otherInputSignal = Signal.random()
        if CGFloat.random(in: 0...1) < lastY {
            // gate goes up
            newLastY = lastY - 0.05
            otherInputY = lastY - 0.1
            let otherInput = OtherInputFromTop(
                frame: CGRect(x: otherInputX, y: 0, width: otherInputLength, height: otherInputY),
                velocity: (speed, 0), zIndex: 0, color: otherInputSignal ? .green : .black)
            gameView.gameObjects.append(otherInput)
        } else {
            // gate goes down
            newLastY = lastY + 0.05
            otherInputY = lastY + 0.1
            let otherInput = OtherInputFromBottom(
                frame: CGRect(x: otherInputX, y: otherInputY, width: otherInputLength, height: 1 - otherInputY),
                velocity: (speed, 0), zIndex: 0, color: otherInputSignal ? .green : .black)
            gameView.gameObjects.append(otherInput)
        }
        let firstPart = Line(position: CGPoint(x: lastX, y: lastY), velocity: (speed, 0), zIndex: 0, length: firstPartLength, horizontal: true, color: .gray)
        
        let secondPart = Line(position: CGPoint(x: lastX + firstPartLength, y: newLastY), velocity: (speed, 0), zIndex: 0, length: secondPartLength, horizontal: true, color: .gray)
        gameView.gameObjects.append(firstPart)
        gameView.gameObjects.append(secondPart)
        let gate = gateSupplier(CGPoint(x: lastX + firstPartLength, y: newLastY), (speed, 0), 3, otherInputSignal)
        gameView.gameObjects.append(gate)
        lastLineObject = secondPart
    }
    
    private func addAndGate() {
        addGateWithOtherInput(gateSupplier: AndGate.init)
    }
    
    private func addOrGate() {
        addGateWithOtherInput(gateSupplier: OrGate.init)
    }
    
    private func addXorGate() {
        addGateWithOtherInput(gateSupplier: XorGate.init)
    }
    
    private func addNotGate() {
        let firstPartLength = CGFloat.random(in: 0.35...0.65)
        let secondPartLength = 1 - firstPartLength
        
        let firstPart = Line(position: CGPoint(x: lastX, y: lastY), velocity: (speed, 0), zIndex: 0, length: firstPartLength, horizontal: true, color: .gray)
        
        let secondPart = Line(position: CGPoint(x: lastX + firstPartLength, y: lastY), velocity: (speed, 0), zIndex: 0, length: secondPartLength, horizontal: true, color: .gray)
        gameView.gameObjects.append(firstPart)
        gameView.gameObjects.append(secondPart)
        let gate = NotGate(position: CGPoint(x: lastX + firstPartLength, y: lastY), velocity: (speed, 0), zIndex: 3)
        gameView.gameObjects.append(gate)
        lastLineObject = secondPart
    }
    
    func addNewGameObjects() {
        let addGateFunctions = [addAndGate, addOrGate, addNotGate, addXorGate]
        addGateFunctions.randomElement()!()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.displayLink.add(to: .current, forMode: .common)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameView.displayLink.remove(from: .current, forMode: .common)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}

extension GameViewController : GameViewDelegate {
    func gateDidLeaveScreen(gameView: GameView, gate: Gate) {
        DispatchQueue.main.async {
            [weak self] in
            self?.addNewGameObjects()
        }
    }
    
    func gameViewDidUpdate(gameView: GameView) {
        let dotAndSignalLineFrame = dot.frame(whenDrawnIn: gameView.bounds).union(signalLine.frame(whenDrawnIn: gameView.bounds))
        let gates = gameView.gameObjects.compactMap { $0 as? Gate }
        if let gate = gates.first (where: {
            let frame = $0.frame(whenDrawnIn: gameView.bounds)
            return frame.contains(dotAndSignalLineFrame) || frame.x < dotAndSignalLineFrame.x
        }) {
            signalLine.position.y = gate.position.y
            dot.position.y = gate.position.y
        }
    }
    
    func didSendSignal(gameView: GameView, signal: Signal) {
        let acceptableRange: (Gate) -> ClosedRange<CGFloat> = {
            ($0.position.x * gameView.width - $0.size.width * gameView.height)
            ...
                ($0.position.x * gameView.width + $0.size.width * gameView.height * 1.5)
        }
        let gateCandidates = gameView.gameObjects.lazy
            .compactMap { $0 as? Gate }
            .filter { acceptableRange($0).contains(self.dot.position.x) }
        if let gate = gateCandidates
            .sorted(by: { $0.position.x < $1.position.x })
            .first(where: { $0.hasBeenCorrectlyEvaluated == nil }) {
            let correct = gate.gateType.evaluate(operand: signalLineSignal) == signal
            gate.hasBeenCorrectlyEvaluated = correct
            signalLineSignal = signal
        } else {
            print("No gate to evaluate")
        }
        
    }
}
