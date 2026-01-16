import Foundation

enum APIError: Error, LocalizedError {
    case networkError(Error)
    case decodingError(Error)
    case notFound
    case invalidResponse
    case fileNotFound(String)

    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .notFound:
            return "The requested resource was not found"
        case .invalidResponse:
            return "Invalid response from server"
        case .fileNotFound(let filename):
            return "Could not find file: \(filename)"
        }
    }
}
