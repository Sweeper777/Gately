import UIKit

class AndGate: Gate {
    
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
    var evaluated = false
    
    let size: CGSize = CGSize(width: 0.25, height: 0.25)
    
    func draw(in rect: CGRect) {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: position.x * rect.width, y: position.y * rect.height), radius: rect.height / 8, startAngle: 3 * .pi / 2, endAngle: .pi / 2, clockwise: true)
        path.addLine(to: CGPoint(x: position.x * rect.width - rect.height / 8, y: (position.y + 0.125) * rect.height))
        path.addLine(to: CGPoint(x: position.x * rect.width - rect.height / 8, y: (position.y - 0.125) * rect.height))
        path.close()
        path.lineWidth = 10
        UIColor.white.setFill()
        UIColor.black.setStroke()
        path.stroke()
        path.fill()
    }
}
