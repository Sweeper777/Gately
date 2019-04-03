import CoreGraphics

protocol GameObject : class {
    var velocity: (CGFloat, CGFloat) { get set }
    var zIndex: Int { get set }
    var position: CGPoint { get set }
    
    func draw(in rect: CGRect)
    
    func frame(whenDrawnIn rect: CGRect) -> CGRect
}

extension GameObject {
    func shouldBeDeleted(from rect: CGRect) -> Bool {
        let myFrame = frame(whenDrawnIn: rect)
        return myFrame.x + myFrame.width < 0 || myFrame.y > rect.height
    }
}
