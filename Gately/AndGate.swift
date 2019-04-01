import UIKit

class AndGate: GameObject {
    init(position: CGPoint, velocity: (CGFloat, CGFloat), zIndex: Int) {
        self.position = position
        self.velocity = velocity
        self.zIndex = zIndex
    }
    
    var velocity: (CGFloat, CGFloat)
    var zIndex: Int
    var position: CGPoint
    
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
    
    func isOutOf(rect: CGRect) -> Bool {
        return !rect.intersects(CGRect(x: position.x * rect.width, y: position.y * rect.height, width: 0, height: 0).insetBy(dx: rect.height / -8, dy: rect.height / -8))
    }
    
    
}
