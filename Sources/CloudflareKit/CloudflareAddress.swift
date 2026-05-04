import Vapor

public struct CloudflareAddress: Content, Sendable {
    public let fullName: String
    public let email: String

    public init(fullName: String, email: String) {
        self.fullName = fullName
        self.email = email
    }

    public func toString() -> String {
        return "\(fullName) <\(email)>"
    }

    func toObject() -> CloudflareAddressObject {
        return CloudflareAddressObject(address: email, name: fullName)
    }
}

struct CloudflareAddressObject: Content, Sendable {
    let address: String
    let name: String
}
