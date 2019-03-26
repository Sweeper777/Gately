import UIKit

@IBDesignable
class SignalView: UIView {
    @IBInspectable
    var lineWidth: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var startY: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var endY: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var signalX: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var signal: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var breakpoint: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let part1 = UIBezierPath()
        part1.move(to: CGPoint(x: 0, y: startY))
        part1.addLine(to: CGPoint(x: signalX, y: startY))
        if signal {
            UIColor.green.setStroke()
        } else {
            UIColor.black.setStroke()
        }
        part1.lineWidth = lineWidth
        part1.stroke()
        
        let part2 = UIBezierPath()
        part2.move(to: CGPoint(x: signalX, y: startY))
        part2.addLine(to: CGPoint(x: breakpoint, y: startY))
        part2.move(to: CGPoint(x: breakpoint, y: endY))
        part2.addLine(to: CGPoint(x: bounds.width, y: endY))
        UIColor.black.setStroke()
        part2.lineWidth = lineWidth
        part2.stroke()
        
        let circle = UIBezierPath(ovalIn: CGRect(x: signalX, y: startY, width: 0, height: 0).insetBy(dx: -10, dy: -10))
        UIColor.red.setFill()
        circle.fill()
    }
}
