typealias Signal = Bool

enum GateType {
    case and(_ operand: Signal)
    case or(_ operand: Signal)
    case xor(_ operand: Signal)
    case not
    
    func evaluate(operand: Signal) -> Signal {
        switch self {
        case .and(operand: let other): return operand && other
        case .or(operand: let other): return operand || other
        case .not: return !operand
        }
    }
    
    func imageName() -> String {
        switch self {
        case .and: return "AND"
        case .or: return "OR"
        case .not: return "NOT"
        }
    }
    
    static let allTypes: [GateType] = [
        .and(true),
        .and(false),
        .or(true),
        .or(false),
        .not,
    ]
    
    static func random() -> GateType {
        return allTypes.randomElement()!
    }
}
