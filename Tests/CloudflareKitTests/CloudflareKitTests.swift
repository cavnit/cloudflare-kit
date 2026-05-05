import XCTest
@testable import CloudflareKit

final class CloudflareEmailAddressTests: XCTestCase {
    func testToString() {
        let address: CloudflareEmailAddress = CloudflareEmailAddress(fullName: "John Doe", email: "john@example.com")
        XCTAssertEqual(address.toString(), "John Doe <john@example.com>")
    }

    func testToObject() {
        let address: CloudflareEmailAddress = CloudflareEmailAddress(fullName: "John Doe", email: "john@example.com")
        let object: CloudflareEmailAddressObject = address.toObject()
        XCTAssertEqual(object.address, "john@example.com")
        XCTAssertEqual(object.name, "John Doe")
    }
}

final class CloudflareEmailConfigurationTests: XCTestCase {
    func testSendURL() {
        let config: CloudflareEmailConfiguration = CloudflareEmailConfiguration(
            apiToken: "token",
            accountID: "abc123",
            defaultFrom: CloudflareEmailAddress(fullName: "App", email: "noreply@example.com")
        )
        XCTAssertEqual(config.sendURL, "https://api.cloudflare.com/client/v4/accounts/abc123/email/sending/send")
    }
}

final class CloudflareR2ConfigurationTests: XCTestCase {
    func testDefaultEndpoint() {
        let config: CloudflareR2Configuration = CloudflareR2Configuration(
            accountID: "abc123",
            accessKey: "key",
            secretKey: "secret",
            bucket: "my-bucket"
        )
        XCTAssertEqual(config.endpoint, "https://abc123.r2.cloudflarestorage.com")
        XCTAssertEqual(config.region, "auto")
    }

    func testObjectURL() {
        let config: CloudflareR2Configuration = CloudflareR2Configuration(
            accountID: "abc123",
            accessKey: "key",
            secretKey: "secret",
            bucket: "my-bucket"
        )
        XCTAssertEqual(
            config.objectURL(for: "documents/file.pdf"),
            "https://abc123.r2.cloudflarestorage.com/my-bucket/documents/file.pdf"
        )
    }

    func testCustomEndpoint() {
        let config: CloudflareR2Configuration = CloudflareR2Configuration(
            accountID: "abc123",
            accessKey: "key",
            secretKey: "secret",
            bucket: "my-bucket",
            endpoint: "https://files.example.com/"
        )
        XCTAssertEqual(
            config.objectURL(for: "key"),
            "https://files.example.com/my-bucket/key"
        )
    }
}
