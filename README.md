# CloudflareKit

A Vapor client for Cloudflare services. One package, two clients:

- **Email Sending** via the [Cloudflare Email Sending API](https://developers.cloudflare.com/api/resources/email_sending/methods/send) — plain/HTML email with attachments.
- **R2 Storage** — S3-compatible object storage with presigned URLs (AWS Signature V4).

## Requirements

- Swift 6.1+
- macOS 15.0+

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

## Email

### Configuration

```swift
import CloudflareKit

func configure(_ app: Application) throws {
    app.cloudflare.email.configuration = CloudflareEmailConfiguration(
        apiToken: Environment.get("CLOUDFLARE_API_TOKEN")!,
        accountID: Environment.get("CLOUDFLARE_ACCOUNT_ID")!,
        defaultFrom: CloudflareEmailAddress(
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

The default API URL is `https://api.cloudflare.com/client/v4`. Override it via the `apiURL:` parameter on `CloudflareEmailConfiguration` if needed.

### Send a simple email

```swift
try await app.cloudflare.email.client.send(
    subject: "Welcome",
    htmlContent: "<h1>Hello!</h1>",
    textContent: "Hello!",
    to: CloudflareEmailAddress(fullName: "Jane Doe", email: "jane@example.com")
)
```

### Send to multiple recipients with CC/BCC

```swift
try await app.cloudflare.email.client.send(
    subject: "Team Update",
    htmlContent: "<p>Here's the latest.</p>",
    textContent: "Here's the latest.",
    to: [
        CloudflareEmailAddress(fullName: "Alice", email: "alice@example.com"),
        CloudflareEmailAddress(fullName: "Bob", email: "bob@example.com"),
    ],
    cc: [CloudflareEmailAddress(fullName: "Manager", email: "manager@example.com")],
    from: CloudflareEmailAddress(fullName: "Notifications", email: "notify@example.com")
)
```

### Send with attachments

```swift
let attachment = CloudflareEmailAttachment(
    name: "report.pdf",
    type: "application/pdf",
    byteBuffer: pdfByteBuffer
)

try await app.cloudflare.email.client.send(
    subject: "Monthly Report",
    htmlContent: "<p>Attached.</p>",
    textContent: "Attached.",
    to: [CloudflareEmailAddress(fullName: "Jane", email: "jane@example.com")],
    withAttachments: [attachment]
)
```

Attachment bytes are base64-encoded as required by the Cloudflare API. Use `disposition: .inline` to embed images.

### Using from a Queues job

```swift
func dequeue(_ context: QueueContext, _ payload: Payload) async throws {
    try await context.application.cloudflare.email.client.send(
        subject: payload.subject,
        htmlContent: payload.html,
        textContent: payload.text,
        to: CloudflareEmailAddress(fullName: payload.name, email: payload.email)
    )
}
```

## R2 Storage

### Configuration

```swift
app.cloudflare.r2.configuration = CloudflareR2Configuration(
    accountID: Environment.get("CLOUDFLARE_ACCOUNT_ID")!,
    accessKey: Environment.get("R2_ACCESS_KEY")!,
    secretKey: Environment.get("R2_SECRET_KEY")!,
    bucket: "my-bucket"
)
```

The endpoint defaults to `https://{accountID}.r2.cloudflarestorage.com`. Override it via the `endpoint:` parameter if needed (e.g. for a custom domain or jurisdiction-specific endpoint).

### Upload

```swift
try await req.cloudflare.r2.client.upload(
    key: "documents/file.pdf",
    data: fileBuffer,
    contentType: "application/pdf"
)
```

### Download

```swift
let data = try await req.cloudflare.r2.client.download(key: "documents/file.pdf")
```

### Delete

```swift
try await req.cloudflare.r2.client.delete(key: "documents/file.pdf")
```

### Presigned URLs

Generate a presigned upload URL for direct browser uploads:

```swift
let url = try req.cloudflare.r2.client.presignedUploadURL(
    key: "documents/new-file.pdf",
    contentType: "application/pdf",
    expires: 900 // 15 minutes
)
```

Generate a presigned download URL with `Content-Disposition: attachment`:

```swift
let url = try req.cloudflare.r2.client.presignedDownloadURL(
    key: "documents/file.pdf",
    filename: "my-file.pdf",
    expires: 900
)
```

## License

Apache License 2.0. See [LICENSE](LICENSE).

The AWS Signature V4 implementation under `Sources/CloudflareKit/AWS/` is derived from [soto-project](https://github.com/soto-project) and is also Apache 2.0.
