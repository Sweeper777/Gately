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
    
}
