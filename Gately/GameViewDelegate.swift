protocol GameViewDelegate: class {
    func gateDidLeaveScreen(gameView: GameView, gate: Gate)
    func gameViewDidUpdate(gameView: GameView)
    func didSendSignal(gameView: GameView, signal: Signal)
}
