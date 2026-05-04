import XCTest
@testable import CloudflareKit

final class CloudflareAddressTests: XCTestCase {
    func testToString() {
        let address: CloudflareAddress = CloudflareAddress(fullName: "John Doe", email: "john@example.com")
        XCTAssertEqual(address.toString(), "John Doe <john@example.com>")
    }

    func testToObject() {
        let address: CloudflareAddress = CloudflareAddress(fullName: "John Doe", email: "john@example.com")
        let object: CloudflareAddressObject = address.toObject()
        XCTAssertEqual(object.address, "john@example.com")
        XCTAssertEqual(object.name, "John Doe")
    }
}

final class CloudflareConfigurationTests: XCTestCase {
    func testSendURL() {
        let config: CloudflareConfiguration = CloudflareConfiguration(
            apiToken: "token",
            accountID: "abc123",
            defaultFrom: CloudflareAddress(fullName: "App", email: "noreply@example.com")
        )
        XCTAssertEqual(config.sendURL, "https://api.cloudflare.com/client/v4/accounts/abc123/email/sending/send")
    }
}
