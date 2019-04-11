import UIKit
import SwiftyUtils

class GameViewController: UIViewController {
    @IBOutlet var gameView: GameView!
    
    let speed: CGFloat = -0.00001
    
    var signalLine: Line!
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
        lastLineObject = Line(position: CGPoint(x: 0, y: 0.5), velocity: (speed, 0), zIndex: 0, length: 1, horizontal: true, color: .black)
        gameView.gameObjects.append(lastLineObject)
        addNewGameObjects()
        addNewGameObjects()
    }
    
    func addNewGameObjects() {
        let firstPartLength = CGFloat.random(in: 0.35...0.65)
        let otherInputLength = CGFloat.random(in: 0.35...1) * firstPartLength
        let secondPartLength = 1 - firstPartLength
        let newLastY: CGFloat
        let otherInputY: CGFloat
        let otherInputX = lastX + firstPartLength - otherInputLength
        if CGFloat.random(in: 0...1) < lastY {
            // gate goes up
            newLastY = lastY - 0.05
            otherInputY = lastY - 0.1
            let otherInputVerticalBit = Line(position: CGPoint(x: otherInputX, y: otherInputY), velocity: (speed, 0), zIndex: 0, length: otherInputY, horizontal: false, color: .red)
            gameView.gameObjects.append(otherInputVerticalBit)
        } else {
            // gate goes down
            newLastY = lastY + 0.05
            otherInputY = lastY + 0.1
            let otherInputVerticalBit = Line(position: CGPoint(x: otherInputX, y: 1), velocity: (speed, 0), zIndex: 0, length: 1 - otherInputY, horizontal: false, color: .red)
            gameView.gameObjects.append(otherInputVerticalBit)
        }
        let firstPart = Line(position: CGPoint(x: lastX, y: lastY), velocity: (speed, 0), zIndex: 0, length: firstPartLength, horizontal: true, color: .black)
        
        let otherInputHorizontalBit = Line(position: CGPoint(x: otherInputX, y: otherInputY), velocity: (speed, 0), zIndex: 0, length: otherInputLength, horizontal: true, color: .red)
        let secondPart = Line(position: CGPoint(x: lastX + firstPartLength, y: newLastY), velocity: (speed, 0), zIndex: 0, length: secondPartLength, horizontal: true, color: .black)
        gameView.gameObjects.append(firstPart)
        gameView.gameObjects.append(secondPart)
        gameView.gameObjects.append(otherInputHorizontalBit)
        let gate = AndGate(position: CGPoint(x: lastX + firstPartLength, y: newLastY), velocity: (speed, 0), zIndex: 3, gateType: .and(true))
        gameView.gameObjects.append(gate)
        lastLineObject = secondPart
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
        addNewGameObjects()
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
}
