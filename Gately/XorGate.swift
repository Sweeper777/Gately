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
    
    func draw(in rect: CGRect) {
        let actualHeight = rect.height * size.height
        let radius = actualHeight * 1.25
        let orPath = UIBezierPath()
        let actualCenterX = rect.width * position.x
        let actualCenterY = rect.height * position.y
        let actualTopLeftX = actualCenterX - actualHeight / 2
        let actualTopLeftY = actualCenterY - actualHeight / 2
        orPath.addArc(
            withCenter: CGPoint(x: actualTopLeftX, y: actualTopLeftY + radius),
            radius: radius,
            startAngle: 3 * .pi / 2,
            endAngle: 2 * .pi - atan(0.75),
            clockwise: true)
        orPath.addArc(
            withCenter: CGPoint(x: actualTopLeftX, y: actualTopLeftY + actualHeight - radius),
            radius: radius,
            startAngle: atan(0.75),
            endAngle: .pi / 2,
            clockwise: true)
        orPath.addArc(
            withCenter: CGPoint(x: actualTopLeftX - actualHeight / 2, y: actualTopLeftY + actualHeight / 2),
            radius: hypot(actualHeight / 2, actualHeight / 2),
            startAngle: .pi / 4,
            endAngle: 7 * .pi / 4,
            clockwise: false)
        UIColor.black.setStroke()
        UIColor.white.setFill()
        orPath.lineWidth = 5
        orPath.close()
        orPath.fill()
        orPath.stroke()
        
        let xorPath = UIBezierPath(
            arcCenter: CGPoint(x: actualTopLeftX - actualHeight / 2 - actualHeight / 7, y: actualTopLeftY + actualHeight / 2),
            radius: hypot(actualHeight / 2, actualHeight / 2),
            startAngle: .pi / 4,
            endAngle: 7 * .pi / 4,
            clockwise: false)
        xorPath.lineWidth = 5
        xorPath.stroke()
    }
}
