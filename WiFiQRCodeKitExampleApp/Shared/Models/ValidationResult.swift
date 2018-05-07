enum ValidationResult<V, E> {
    case success(content: V)
    case failed(because: E)


    var isValid: Bool {
        switch self {
        case .success:
            return true
        case .failed:
            return false
        }
    }


    var content: V? {
        switch self {
        case .success(content: let content):
            return content
        case .failed:
            return nil
        }
    }


    var reason: E? {
        switch self {
        case .success:
            return nil
        case .failed(because: let reason):
            return reason
        }
    }
}