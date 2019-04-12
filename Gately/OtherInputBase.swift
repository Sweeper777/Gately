import UIKit

class OtherInputBase: GameObject {
    var velocity: (CGFloat, CGFloat)
    var zIndex: Int
    var frame: CGRect
    var position: CGPoint {
        get { return frame.origin }
        set { frame.origin = newValue }
    }
    var color: UIColor
    
    func draw(in rect: CGRect) {
        
    }
    
    func frame(whenDrawnIn rect: CGRect) -> CGRect {
        return frame.applying(CGAffineTransform(scaleX: rect.width, y: rect.height))
    }
    
    init(frame: CGRect, velocity: (CGFloat, CGFloat), zIndex: Int, color: UIColor) {
        self.velocity = velocity
        self.zIndex = zIndex
        self.frame = frame
        self.color = color
    }
}
