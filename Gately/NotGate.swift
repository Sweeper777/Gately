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
    var hasBeenCorrectlyEvaluated: Bool?
    
    let size: CGSize = CGSize(width: 0.25 * 8.0 / 7.0, height: 0.25)
    
    func draw(in rect: CGRect) {
        let path = UIBezierPath()
        let actualHeight = rect.height * size.height
        let actualWidth = rect.height * size.width
        let actualCenterX = rect.width * position.x
        let actualCenterY = rect.height * position.y
        let actualTopLeftX = actualCenterX - actualWidth / 2
        let actualTopLeftY = actualCenterY - actualHeight / 2
        
        let pointyBitCoordinates = CGPoint(x: actualTopLeftX + actualHeight, y: actualCenterY)
        path.move(to: pointyBitCoordinates)
        path.addLine(to: CGPoint(x: actualTopLeftX, y: actualTopLeftY + actualHeight))
        path.addLine(to: CGPoint(x: actualTopLeftX, y: actualTopLeftY))
        path.addLine(to: pointyBitCoordinates)
        let radius = (actualWidth - actualHeight) / 2
        path.addArc(
            withCenter: CGPoint(x: pointyBitCoordinates.x + radius, y: actualCenterY),
            radius: radius,
            startAngle: .pi,
            endAngle: -.pi,
            clockwise: false)
        path.close()
        
        UIColor.black.setStroke()
        if hasBeenCorrectlyEvaluated == nil {
            UIColor.white.setFill()
        } else if hasBeenCorrectlyEvaluated! {
            UIColor.green.setFill()
        } else {
            UIColor.red.setFill()
        }
        path.lineWidth = 5
        path.close()
        path.fill()
        path.stroke()
    }
}
