import UIKit

protocol Gate: GameObject {
    var gateType: GateType { get }
    
    /// Size is relative to screen height only
    var size: CGSize { get }
}

extension Gate {
    func frame(whenDrawnIn rect: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: position.x * rect.width, y: position.y * rect.height), size: .zero).insetBy(dx: -size.width * rect.height / 2, dy: -size.height * rect.height / 2)
    }
}
