import UIKit

class OtherInputFromTop: OtherInputBase {

    override func draw(in rect: CGRect) {
        let frameInRect = frame(whenDrawnIn: rect)
        let path = UIBezierPath()
        path.move(to: frameInRect.origin)
        path.addLine(to: CGPoint(x: frameInRect.x, y: frameInRect.y + frameInRect.height))
        path.addLine(to: CGPoint(x: frameInRect.x + frameInRect.width, y: frameInRect.y + frameInRect.height))
        color.setStroke()
        path.lineWidth = 5
        path.stroke()
    }
}
