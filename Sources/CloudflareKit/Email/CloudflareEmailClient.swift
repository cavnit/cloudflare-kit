import Foundation
import Vapor

public struct CloudflareEmailClient: Sendable {
    let client: any Client
    let logger: Logger
    let configuration: CloudflareEmailConfiguration

    public func send(
        subject: String,
        htmlContent: String,
        textContent: String,
        to: CloudflareEmailAddress
    ) async throws {
        let message: CloudflareEmailMessage = CloudflareEmailMessage(
            from: configuration.defaultFrom.toObject(),
            to: [to.toString()],
            cc: nil,
            bcc: nil,
            replyTo: nil,
            subject: subject,
            text: textContent,
            html: htmlContent,
            attachments: nil
        )

        try await postMessage(message)
    }

    public func send(
        subject: String,
        htmlContent: String?,
        textContent: String?,
        to: [CloudflareEmailAddress],
        cc: [CloudflareEmailAddress] = [],
        bcc: [CloudflareEmailAddress] = [],
        from: CloudflareEmailAddress? = nil,
        replyTo: CloudflareEmailAddress? = nil,
        withAttachments attachments: [CloudflareEmailAttachment] = []
    ) async throws {
        guard to.count > 0 else {
            throw CloudflareEmailError.noToAddresses
        }
        guard htmlContent != nil || textContent != nil else {
            throw CloudflareEmailError.noContent
        }

        let fromAddress: CloudflareEmailAddressObject = (from ?? configuration.defaultFrom).toObject()

        let attachmentPayloads: [CloudflareEmailAttachmentPayload]? = attachments.isEmpty ? nil : attachments.map {
            CloudflareEmailAttachmentPayload(
                content: Data(buffer: $0.byteBuffer, byteTransferStrategy: .automatic).base64EncodedString(),
                filename: $0.name,
                type: $0.type,
                disposition: $0.disposition.rawValue
            )
        }

        let message: CloudflareEmailMessage = CloudflareEmailMessage(
            from: fromAddress,
            to: to.map { $0.toString() },
            cc: cc.isEmpty ? nil : cc.map { $0.toString() },
            bcc: bcc.isEmpty ? nil : bcc.map { $0.toString() },
            replyTo: replyTo?.toObject(),
            subject: subject,
            text: textContent,
            html: htmlContent,
            attachments: attachmentPayloads
        )

        try await postMessage(message)
    }

    private func postMessage(_ message: CloudflareEmailMessage) async throws {
        let response: ClientResponse = try await client.post(
            URI(string: configuration.sendURL),
            headers: [:]
        ) { req in
            req.headers.bearerAuthorization = BearerAuthorization(token: configuration.apiToken)
            try req.content.encode(message, as: .json)
        }

        if response.status != .created, response.status != .ok, response.status != .accepted {
            throw CloudflareEmailError.sendingFailed
        }
    }
}
