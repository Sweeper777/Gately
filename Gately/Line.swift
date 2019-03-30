import UIKit

class Line : GameObject {
    
    init(position: CGPoint, velocity: (CGFloat, CGFloat), zIndex: Int, length: CGFloat, horizontal: Bool, color: UIColor) {
        self.zIndex = zIndex
        self.velocity = velocity
        self.position = position
        self.length = length
        self.horizontal = horizontal
        self.color = color
    }
    
    var zIndex: Int
    var velocity: (CGFloat, CGFloat)
    var position: CGPoint
    var length: CGFloat
    var horizontal: Bool
    var color: UIColor
    
    func draw(in rect: CGRect) {
        if horizontal {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: position.x * rect.width, y: position.y * rect.height))
            path.addLine(to: CGPoint(x: (position.x + length) * rect.width, y: position.y * rect.height))
            path.lineWidth = 5
            color.setStroke()
            path.stroke()
        } else {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: position.x * rect.width, y: position.y * rect.height))
            path.addLine(to: CGPoint(x: position.x * rect.width * rect.width, y: (position.y + length) * rect.height))
            path.lineWidth = 5
            color.setStroke()
            path.stroke()
        }
    }
    
    func isOutOf(rect: CGRect) -> Bool {
        if horizontal {
            return position.x + length < 0
        } else {
            return position.y - length > 1
        }
    }
    
}
