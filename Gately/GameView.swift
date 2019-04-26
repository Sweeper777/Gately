import UIKit

import UIKit

class GameView: UIView {
    var displayLink: CADisplayLink!
    var lastTimeStamp: Double? = nil
    weak var delegate: GameViewDelegate?
    
    override func draw(_ rect: CGRect) {
        guard let gameObjects = delegate?.gameObjects else { return }
        
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
        guard let gameObjects = delegate?.gameObjects else { return }
        
        guard let lastTimeStamp = self.lastTimeStamp else {
            self.lastTimeStamp = displayLink.timestamp
            setNeedsDisplay()
            return
        }
        let elapsedTime = displayLink.timestamp - lastTimeStamp
        
        self.lastTimeStamp = displayLink.timestamp
        
        for gameObject in gameObjects {
            gameObject.position = gameObject.position.applying(
                CGAffineTransform(
                    translationX: gameObject.velocity.0 * CGFloat(elapsedTime),
                    y: gameObject.velocity.1 * CGFloat(elapsedTime)))
            if gameObject.shouldBeDeleted(from: self.bounds) {
                if let gate = gameObject as? Gate {
                    delegate?.gateDidLeaveScreen(gameView: self, gate: gate)
                }
            }
        }
        delegate?.removeAllGameObjects(where: { $0.shouldBeDeleted(from: self.bounds) })
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
