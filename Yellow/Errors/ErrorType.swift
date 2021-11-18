import Foundation

public enum ErrorType: Error {
    case failedToLogin
    case failedToGetJogs
}

extension ErrorType: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToLogin:
            return "Не удалось войти в систему"
        case .failedToGetJogs:
            return "Не удалось получить данные с сервера"
        }
        
    }
}
