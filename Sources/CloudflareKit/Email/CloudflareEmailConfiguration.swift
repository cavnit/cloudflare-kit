import Vapor

public struct CloudflareEmailConfiguration: Sendable {
    public let apiURL: String
    public let apiToken: String
    public let accountID: String
    public let defaultFrom: CloudflareEmailAddress

    public init(
        apiURL: String = "https://api.cloudflare.com/client/v4",
        apiToken: String,
        accountID: String,
        defaultFrom: CloudflareEmailAddress
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
