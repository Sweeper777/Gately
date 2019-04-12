import UIKit

class OtherInputFromBottom: OtherInputBase {
    override func draw(in rect: CGRect) {
        let frameInRect = frame(whenDrawnIn: rect)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameInRect.x, y: frameInRect.y + frameInRect.height))
        path.addLine(to: frameInRect.origin)
        path.addLine(to: CGPoint(x: frameInRect.x + frameInRect.width, y: frameInRect.y))
        color.setStroke()
        path.lineWidth = 5
        path.stroke()
    }
}
