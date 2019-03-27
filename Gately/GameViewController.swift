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
        }
    }
    }
}
