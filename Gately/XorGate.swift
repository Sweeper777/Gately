import UIKit

class XorGate: Gate {
    
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
        return .xor(otherInput)
    }
    var otherInput: Signal
    var evaluated = false
    
    let size: CGSize = CGSize(width: 0.25, height: 0.25)
}
