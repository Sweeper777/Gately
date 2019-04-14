import UIKit

class NotGate: Gate {
    
    init(position: CGPoint, velocity: (CGFloat, CGFloat), zIndex: Int) {
        self.position = position
        self.velocity = velocity
        self.zIndex = zIndex
    }
    
    var velocity: (CGFloat, CGFloat)
    var zIndex: Int
    var position: CGPoint
    var gateType: GateType {
        return .not
    }
    
    let size: CGSize = CGSize(width: 0.25 * 8.0 / 7.0, height: 0.25)
    
}
