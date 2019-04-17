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
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGestureRecogniser)
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        let touchPosition = sender.location(in: self)
        if touchPosition.y < self.height / 2 {
            // it's a 1
            delegate?.didSendSignal(gameView: self, signal: true)
        } else {
            // it's a 0
            delegate?.didSendSignal(gameView: self, signal: false)
        }
    }
    
    @objc func update() {
        for gameObject in gameObjects {
            gameObject.position = gameObject.position.applying(
                CGAffineTransform(
                    translationX: gameObject.velocity.0 * self.bounds.width,
                    y: gameObject.velocity.1 * self.bounds.height))
            if gameObject.shouldBeDeleted(from: self.bounds) {
                if let gate = gameObject as? Gate {
                    delegate?.gateDidLeaveScreen(gameView: self, gate: gate)
                }
            }
        }
        gameObjects.removeAll(where: { $0.shouldBeDeleted(from: self.bounds) })
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
