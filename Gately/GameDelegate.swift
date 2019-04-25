import CoreGraphics

protocol GameDelegate: class {
    func speedDidChange(_ game: Game, newSpeed: CGFloat)
    func scoreDidChange(_ game: Game, newScore: Int)
}
