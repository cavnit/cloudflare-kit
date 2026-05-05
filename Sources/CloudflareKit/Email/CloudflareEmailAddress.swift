import Vapor

public struct CloudflareEmailAddress: Content, Sendable {
    public let fullName: String
    public let email: String

    public init(fullName: String, email: String) {
        self.fullName = fullName
        self.email = email
    }

    public func toString() -> String {
        return "\(fullName) <\(email)>"
    }

    func toObject() -> CloudflareEmailAddressObject {
        return CloudflareEmailAddressObject(address: email, name: fullName)
    }
}

struct CloudflareEmailAddressObject: Content, Sendable {
    let address: String
    let name: String
}
