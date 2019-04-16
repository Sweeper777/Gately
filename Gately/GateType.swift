typealias Signal = Bool

enum GateType {
    case and(_ operand: Signal)
    case or(_ operand: Signal)
    case xor(_ operand: Signal)
    case not
    
    func evaluate(operand: Signal) -> Signal {
        switch self {
        case .and(let other): return operand && other
        case .or(let other): return operand || other
        case .xor(let other): return operand != other
        case .not: return !operand
        }
    }
}
