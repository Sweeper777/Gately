import UIKit

import UIKit

class GameView: UIView {
    var gameObjects: [GameObject] = [] {
        didSet {
            let sorted = gameObjects.map { $0.zIndex }.sorted()
            if gameObjects.map({ $0.zIndex }) != sorted {
                gameObjects.sort { $0.zIndex < $1.zIndex }
            }
        }
    }
    var displayLink: CADisplayLink!
    weak var delegate: GameViewDelegate?
    
    override func draw(_ rect: CGRect) {
        for gameObject in gameObjects {
            gameObject.draw(in: self.bounds)
        }
    }
    
    func commonInit() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
    }
    
    @objc func update() {
        for (index, gameObject) in gameObjects.enumerated() {
            gameObject.position = gameObject.position.applying(
                CGAffineTransform(
                    translationX: gameObject.velocity.0 * self.bounds.width,
                    y: gameObject.velocity.1 * self.bounds.height))
            if gameObject.shouldBeDeleted(from: self.bounds) {
                gameObjects.remove(at: index)
                if let gate = gameObject as? Gate {
                    delegate?.gateDidLeaveScreen(gameView: self, gate: gate)
                }
            }
        }
        delegate?.gameViewDidUpdate(gameView: self)
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
}
