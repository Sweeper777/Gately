import UIKit

class Dot : GameObject {
    init(position: CGPoint, zIndex: Int) {
        self.zIndex = zIndex
        self.position = position
    }
    
    var velocity: (CGFloat, CGFloat) = (0, 0)
    var zIndex: Int
    var position: CGPoint
    
    func draw(in rect: CGRect) {
        let path = UIBezierPath(ovalIn: CGRect(x: position.x * rect.width, y: position.y * rect.height, width: 0, height: 0).insetBy(dx: -10, dy: -10))
        UIColor.red.setFill()
        path.fill()
    }
    
    func isOutOf(rect: CGRect) -> Bool {
        return !rect.intersects(CGRect(x: position.x * rect.width, y: position.y * rect.height, width: 0, height: 0).insetBy(dx: -10, dy: -10))
    }
}
