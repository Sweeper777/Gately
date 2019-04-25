import UIKit

class Game {
    weak var delegate: GameDelegate?
    
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
    
}
