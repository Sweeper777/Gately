import UIKit
import SwiftyUtils

class GameViewController: UIViewController {
    @IBOutlet var gameView: GameView!
    @IBOutlet var scoreLabel: UILabel!
    
    var gameObjects: [GameObject] {
        return game.gameObjects
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
            self?.game.addNewGameObjects()
        }
    }
    
    func gameViewDidUpdate(gameView: GameView) {
        let dotAndSignalLineFrame = game.dot.frame(whenDrawnIn: gameView.bounds).union(game.signalLine.frame(whenDrawnIn: gameView.bounds))
        let gates = game.gameObjects.compactMap { $0 as? Gate }
        if let gate = gates.first (where: {
            let frame = $0.frame(whenDrawnIn: gameView.bounds)
            return frame.contains(dotAndSignalLineFrame) || frame.x < dotAndSignalLineFrame.x
        }) {
            game.signalLine.position.y = gate.position.y
            game.dot.position.y = gate.position.y
        }
    }
    
    func didSendSignal(gameView: GameView, signal: Signal) {
        game.sendSignal(signal)
    }
    
    func removeAllGameObjects(where predicate: (GameObject) -> Bool) {
        game.gameObjects.removeAll(where: predicate)
    }
}

extension GameViewController : GameDelegate {
    func speedDidChange(_ game: Game, newSpeed: CGFloat) {
        game.gameObjects.filter { $0.velocity.0 != 0 }.forEach { (gameObject) in
            gameObject.velocity.0 = newSpeed
        }
    }
    
    func scoreDidChange(_ game: Game, newScore: Int) {
        scoreLabel.text = "\(newScore)"
    }
}
