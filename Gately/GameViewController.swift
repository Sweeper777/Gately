import UIKit
import SwiftyUtils

class GameViewController: UIViewController {
    @IBOutlet var signalView: SignalView!
    
    var displayLink: CADisplayLink!
    var game: Game!
    
    override func viewDidLoad() {
        signalView.startY = signalView.bounds.height / 2
        signalView.signalX = signalView.bounds.width * 0.1
        signalView.endY = signalView.startY
        
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        
        game = Game()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayLink.add(to: .current, forMode: .common)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        displayLink.remove(from: .current, forMode: .common)
    }
    
    @objc func update() {
        game.update()
        if game.timeUntilReaching < 90 {
            let gateView = signalView.subviews.first as? UIImageView ?? UIImageView(image: UIImage(named: game.currentlyShownGate.imageName()))
            gateView.contentMode = .scaleAspectFit
            let size = CGSize(width: signalView.height / 2, height: signalView.height / 2)
            let x = signalView.signalX + (signalView.width - signalView.signalX) * (game.timeUntilReaching / 30.0).f
            let endY = signalView.startY + size.height * newYFactor(for: game.currentlyShownGate).f
            let y = endY - size.height / 2
            gateView.frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
            if !signalView.subviews.contains(gateView) {
                signalView.addSubview(gateView)
            }
            signalView.endY = endY
            signalView.breakpoint = x + (x + size.width) / 2
        }
    }
    }
}
