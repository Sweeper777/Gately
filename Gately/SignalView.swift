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
}
