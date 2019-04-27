import UIKit
import SwiftyUtils

class GameViewController: UIViewController {
    @IBOutlet var gameView: GameView!
    @IBOutlet var scoreLabel: UILabel!
    
    }
    
    var game: Game!
    
    override func viewDidLoad() {
        game = Game(whRatio: gameView.width / gameView.height)
        game.delegate = self
        gameView.delegate = self
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.displayLink.add(to: .current, forMode: .common)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameView.displayLink.remove(from: .current, forMode: .common)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}

extension GameViewController : GameViewDelegate {
    func gateDidLeaveScreen(gameView: GameView, gate: Gate) {
        DispatchQueue.main.async {
            [weak self] in
            self?.addNewGameObjects()
        }
    }
    
    func gameViewDidUpdate(gameView: GameView) {
        let dotAndSignalLineFrame = dot.frame(whenDrawnIn: gameView.bounds).union(signalLine.frame(whenDrawnIn: gameView.bounds))
        let gates = gameView.gameObjects.compactMap { $0 as? Gate }
        if let gate = gates.first (where: {
            let frame = $0.frame(whenDrawnIn: gameView.bounds)
            return frame.contains(dotAndSignalLineFrame) || frame.x < dotAndSignalLineFrame.x
        }) {
            signalLine.position.y = gate.position.y
            dot.position.y = gate.position.y
        }
    }
    
    func didSendSignal(gameView: GameView, signal: Signal) {
        }
    }
}
