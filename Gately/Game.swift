import Foundation

class Game {
    var currentlyShownGate: GateType
    var timeUntilReaching: Double
    var speed: Double
    var nextGate: GateType
    var mainSignal: Signal
    
    init() {
        currentlyShownGate = GateType.random()
        nextGate = GateType.random()
        timeUntilReaching = Double.random(in: 90...150)
        speed = 1
        mainSignal = true
    }
    
    func update() {
        timeUntilReaching -= speed
        if timeUntilReaching <= 0 {
            updateNextGate()
        }
    }
    
}
