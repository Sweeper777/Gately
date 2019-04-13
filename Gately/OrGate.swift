import UIKit

class OrGate: Gate {
    
    init(position: CGPoint, velocity: (CGFloat, CGFloat), zIndex: Int, otherInput: Signal) {
        self.position = position
        self.velocity = velocity
        self.zIndex = zIndex
        self.otherInput = otherInput
    }
    
    var velocity: (CGFloat, CGFloat)
    var zIndex: Int
    var position: CGPoint
    var gateType: GateType {
        return .and(otherInput)
    }
    var otherInput: Signal
    
    let size: CGSize = CGSize(width: 0.25, height: 0.25)
    
}
