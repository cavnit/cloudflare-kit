import Vapor

public enum CloudflareR2Error: Error, AbortError {
    case invalidURL
    case uploadFailed
    case downloadFailed
    case deleteFailed
    case presignFailed

    public var status: HTTPResponseStatus {
        switch self {
        case .invalidURL:
            return .badRequest
        case .uploadFailed, .downloadFailed, .deleteFailed, .presignFailed:
            return .internalServerError
        }
    }

    public var reason: String {
        switch self {
        case .invalidURL:
            return "Invalid R2 URL"
        case .uploadFailed:
            return "Failed to upload file to R2"
        case .downloadFailed:
            return "Failed to download file from R2"
        case .deleteFailed:
            return "Failed to delete file from R2"
        case .presignFailed:
            return "Failed to generate presigned R2 URL"
        }
    }
}
