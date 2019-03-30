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
    
    override func draw(_ rect: CGRect) {
        for gameObject in gameObjects {
            gameObject.draw(in: self.bounds)
        }
    }
    
    func commonInit() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
    }
    
    @objc func update() {
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
