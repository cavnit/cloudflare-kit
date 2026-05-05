import Vapor

public struct CloudflareR2Configuration: Sendable {
    public let accountID: String
    public let accessKey: String
    public let secretKey: String
    public let bucket: String
    public let endpoint: String

    public init(
        accountID: String,
        accessKey: String,
        secretKey: String,
        bucket: String,
        endpoint: String? = nil
    ) {
        self.accountID = accountID
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.bucket = bucket
        self.endpoint = endpoint ?? "https://\(accountID).r2.cloudflarestorage.com"
    }

    var region: String { "auto" }

    func objectURL(for key: String) -> String {
        let base: String = endpoint.hasSuffix("/") ? String(endpoint.dropLast()) : endpoint
        return "\(base)/\(bucket)/\(key)"
    }
}
