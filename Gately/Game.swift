import UIKit

class Game {
    weak var delegate: GameDelegate?
    
    var gameObjects: [GameObject] = [] {
        didSet {
            let sorted = gameObjects.map { $0.zIndex }.sorted()
            if gameObjects.map({ $0.zIndex }) != sorted {
                gameObjects.sort { $0.zIndex < $1.zIndex }
            }
        }
    }
    var speed: CGFloat = -0.33333333 {
        didSet {
           delegate?.speedDidChange(self, newSpeed: speed)
        }
    }
    
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
    
    var score = 0 {
        didSet {
            delegate?.scoreDidChange(self, newScore: score)
        }
    }
    
    var whRatio: CGFloat
    
    init(whRatio: CGFloat) {
        self.whRatio = whRatio
        signalLine = Line(position: CGPoint(x: 0, y: 0.5), velocity: (0, 0), zIndex: 1, length: 0.1, horizontal: true, color: .green)
        dot = Dot(position: CGPoint(x: 0.1, y: 0.5), zIndex: 2)
        lastLineObject = Line(position: CGPoint(x: 0, y: 0.5), velocity: (speed, 0), zIndex: 0, length: 1, horizontal: true, color: .gray)
        
        gameObjects.append(signalLine)
        gameObjects.append(dot)
        gameObjects.append(lastLineObject)
        
        addNewGameObjects()
        addNewGameObjects()
    }
    
    func sendSignal(_ signal: Signal) {
        let acceptableRange: (Gate) -> ClosedRange<CGFloat> = {
            ($0.position.x - $0.size.width / self.whRatio)
                ...
                ($0.position.x + $0.size.width / self.whRatio * 1.5)
        }
        let gateCandidates = gameObjects.lazy
            .compactMap { $0 as? Gate }
            .filter { acceptableRange($0).contains(self.dot.position.x) }
        if let gate = gateCandidates
            .sorted(by: { $0.position.x < $1.position.x })
            .first(where: { $0.hasBeenCorrectlyEvaluated == nil }) {
            let correct = gate.gateType.evaluate(operand: signalLineSignal) == signal
            gate.hasBeenCorrectlyEvaluated = correct
            if correct {
                signalLineSignal = signal
                score += 1
                let speedFunction: (Int) -> CGFloat = { (0.7 / .pi) * atan((1.0 / 16.0) * $0.f - sqrt(3)) + 1 }
                speed = -speedFunction(score)
            } else {
                signalLineSignal = !signal
            }
        } else {
            print("No gate to evaluate")
        }
    }
    
    private func addGateWithOtherInput(gateSupplier: (CGPoint, (CGFloat, CGFloat), Int, Signal) -> Gate) {
        let firstPartLength = CGFloat.random(in: 0.35...0.65)
        let otherInputLength = CGFloat.random(in: 0.35...1) * firstPartLength
        let secondPartLength = 1 - firstPartLength
        let newLastY: CGFloat
        let otherInputY: CGFloat
        let otherInputX = self.lastX + firstPartLength - otherInputLength
        let otherInputSignal = Signal.random()
        if CGFloat.random(in: 0...1) < self.lastY {
            // gate goes up
            newLastY = self.lastY - 0.05
            otherInputY = self.lastY - 0.1
            let otherInput = OtherInputFromTop(
                frame: CGRect(x: otherInputX, y: 0, width: otherInputLength, height: otherInputY),
                velocity: (self.speed, 0), zIndex: 0, color: otherInputSignal ? .green : .black)
            gameObjects.append(otherInput)
        } else {
            // gate goes down
            newLastY = self.lastY + 0.05
            otherInputY = self.lastY + 0.1
            let otherInput = OtherInputFromBottom(
                frame: CGRect(x: otherInputX, y: otherInputY, width: otherInputLength, height: 1 - otherInputY),
                velocity: (self.speed, 0), zIndex: 0, color: otherInputSignal ? .green : .black)
            gameObjects.append(otherInput)
        }
        let firstPart = Line(position: CGPoint(x: self.lastX, y: self.lastY), velocity: (self.speed, 0), zIndex: 0, length: firstPartLength, horizontal: true, color: .gray)
        
        let secondPart = Line(position: CGPoint(x: self.lastX + firstPartLength, y: newLastY), velocity: (self.speed, 0), zIndex: 0, length: secondPartLength, horizontal: true, color: .gray)
        gameObjects.append(firstPart)
        gameObjects.append(secondPart)
        let gate = gateSupplier(CGPoint(x: self.lastX + firstPartLength, y: newLastY), (self.speed, 0), 3, otherInputSignal)
        gameObjects.append(gate)
        self.lastLineObject = secondPart
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
        
        let firstPart = Line(position: CGPoint(x: self.lastX, y: self.lastY), velocity: (self.speed, 0), zIndex: 0, length: firstPartLength, horizontal: true, color: .gray)
        
        let secondPart = Line(position: CGPoint(x: self.lastX + firstPartLength, y: self.lastY), velocity: (self.speed, 0), zIndex: 0, length: secondPartLength, horizontal: true, color: .gray)
        gameObjects.append(firstPart)
        gameObjects.append(secondPart)
        let gate = NotGate(position: CGPoint(x: self.lastX + firstPartLength, y: self.lastY), velocity: (self.speed, 0), zIndex: 3)
        gameObjects.append(gate)
        self.lastLineObject = secondPart
    }
    
    func addNewGameObjects() {
        let addGateFunctions = [addAndGate, addOrGate, addNotGate, addXorGate]
        addGateFunctions.randomElement()!()
    private func xorProbability(_ time: TimeInterval) -> Double {
        if time > 36 {
            return 0.25 - 4 / (time - 20)
        }
        return 0
    }
    
    private func notProbability(_ time: TimeInterval) -> Double {
        if time > 16 {
            return 0.25 - 4 / time
        }
        return 0
    }
    
    private func andOrProbability(_ time: TimeInterval) -> Double {
        return (1 - xorProbability(time) - notProbability(time)) / 2
    }
}
