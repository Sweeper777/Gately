typealias Signal = Bool

enum GateType {
    case and(_ operand: Signal)
    case or(_ operand: Signal)
    case not
    
    func evaluate(operand: Signal) -> Signal {
        switch self {
        case .and(operand: let other): return operand && other
        case .or(operand: let other): return operand || other
        case .not: return !operand
        }
    }
    
}
