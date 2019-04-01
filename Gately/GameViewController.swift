import UIKit
import SwiftyUtils

class GameViewController: UIViewController {
    @IBOutlet var gameView: GameView!
    
    override func viewDidLoad() {
        gameView.gameObjects.append(Line(position: CGPoint(x: 0, y: 0.5), velocity: (0, 0), zIndex: 1, length: 0.1, horizontal: true, color: UIColor.green))
        gameView.gameObjects.append(Line(position: CGPoint(x: 0.1, y: 0.5), velocity: (-0.00001, 0), zIndex: 0, length: 0.4, horizontal: true, color: UIColor.black))
        gameView.gameObjects.append(Line(position: CGPoint(x: 0.5, y: 0.55), velocity: (-0.00001, 0), zIndex: 0, length: 0.5, horizontal: true, color: UIColor.black))
        gameView.gameObjects.append(Dot(position: CGPoint(x: 0.1, y: 0.5), zIndex: 2))
        gameView.gameObjects.append(AndGate(position: CGPoint(x: 0.5, y: 0.55), velocity: (-0.00001, 0), zIndex: 3))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.displayLink.add(to: .current, forMode: .common)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameView.displayLink.remove(from: .current, forMode: .common)
    }
}
