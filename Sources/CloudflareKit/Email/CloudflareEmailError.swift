import Vapor

public enum CloudflareEmailError: Error, AbortError {
    case sendingFailed
    case noToAddresses
    case noContent

    public var status: HTTPResponseStatus {
        switch self {
        case .sendingFailed:
            return .internalServerError
        case .noToAddresses, .noContent:
            return .badRequest
        }
    }

    public var reason: String {
        switch self {
        case .sendingFailed:
            return "Failed to send email via Cloudflare"
        case .noToAddresses:
            return "No recipient addresses provided"
        case .noContent:
            return "Email must include html or text content"
        }
    }
}
