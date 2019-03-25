typealias Signal = Bool

enum GateType {
    case and(_ operand: Signal)
    case or(_ operand: Signal)
    case not
    
}
