import UIKit

class Game {
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
}
