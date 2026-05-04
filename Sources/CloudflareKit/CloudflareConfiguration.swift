import Vapor

public struct CloudflareConfiguration: Sendable {
    public let apiURL: String
    public let apiToken: String
    public let accountID: String
    public let defaultFrom: CloudflareAddress

    public init(
        apiURL: String = "https://api.cloudflare.com/client/v4",
        apiToken: String,
        accountID: String,
        defaultFrom: CloudflareAddress
    ) {
        self.apiURL = apiURL
        self.apiToken = apiToken
        self.accountID = accountID
        self.defaultFrom = defaultFrom
    }

    var sendURL: String {
        "\(apiURL)/accounts/\(accountID)/email/sending/send"
    }
}
