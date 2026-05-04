# CloudflareKit

A Cloudflare Email Sending client for Vapor applications. Supports sending plain and HTML emails with attachments via the [Cloudflare Email Sending API](https://developers.cloudflare.com/api/resources/email_sending/methods/send).

## Installation

Add CloudflareKit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/cavnit/cloudflare-kit.git", from: "0.1.0"),
],
targets: [
    .target(
        name: "App",
        dependencies: [
            .product(name: "CloudflareKit", package: "cloudflare-kit"),
        ]
    ),
]
```

## Configuration

Configure CloudflareKit in your `configure.swift`:

```swift
import CloudflareKit

func configure(_ app: Application) throws {
    app.cloudflare.configuration = .init(
        apiToken: Environment.get("CLOUDFLARE_API_TOKEN")!,
        accountID: Environment.get("CLOUDFLARE_ACCOUNT_ID")!,
        defaultFrom: CloudflareAddress(
            fullName: "App Name",
            email: "noreply@example.com"
        )
    )
}
```

| Environment Variable     | Description                                                              |
|--------------------------|--------------------------------------------------------------------------|
| `CLOUDFLARE_API_TOKEN`   | Cloudflare API token with Email Sending permissions                      |
| `CLOUDFLARE_ACCOUNT_ID`  | Cloudflare account identifier                                            |

The default API URL is `https://api.cloudflare.com/client/v4`. Override it via the `apiURL:` parameter on `CloudflareConfiguration` if needed.

## Usage

### Send a simple email

```swift
try await app.cloudflare.client.send(
    subject: "Welcome",
    htmlContent: "<h1>Hello!</h1>",
    textContent: "Hello!",
    to: CloudflareAddress(fullName: "Jane Doe", email: "jane@example.com")
)
```

### Send to multiple recipients with CC/BCC

```swift
try await app.cloudflare.client.send(
    subject: "Team Update",
    htmlContent: "<p>Here's the latest.</p>",
    textContent: "Here's the latest.",
    to: [
        CloudflareAddress(fullName: "Alice", email: "alice@example.com"),
        CloudflareAddress(fullName: "Bob", email: "bob@example.com"),
    ],
    cc: [CloudflareAddress(fullName: "Manager", email: "manager@example.com")],
    from: CloudflareAddress(fullName: "Notifications", email: "notify@example.com")
)
```

### Send with attachments

```swift
let attachment = CloudflareAttachment(
    name: "report.pdf",
    type: "application/pdf",
    byteBuffer: pdfByteBuffer
)

try await app.cloudflare.client.send(
    subject: "Monthly Report",
    htmlContent: "<p>Attached.</p>",
    textContent: "Attached.",
    to: [CloudflareAddress(fullName: "Jane", email: "jane@example.com")],
    withAttachments: [attachment]
)
```

Attachment bytes are base64-encoded as required by the Cloudflare API. Use `disposition: .inline` to embed images.

### Using from a Queues job

```swift
func dequeue(_ context: QueueContext, _ payload: Payload) async throws {
    try await context.application.cloudflare.client.send(
        subject: payload.subject,
        htmlContent: payload.html,
        textContent: payload.text,
        to: CloudflareAddress(fullName: payload.name, email: payload.email)
    )
}
```

## License

MIT
