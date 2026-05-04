import Vapor

struct CloudflareMessage: Content {
    let from: CloudflareAddressObject
    let to: [String]
    let cc: [String]?
    let bcc: [String]?
    let replyTo: CloudflareAddressObject?
    let subject: String
    let text: String?
    let html: String?
    let attachments: [CloudflareAttachmentPayload]?

    enum CodingKeys: String, CodingKey {
        case from
        case to
        case cc
        case bcc
        case replyTo = "reply_to"
        case subject
        case text
        case html
        case attachments
    }
}

struct CloudflareAttachmentPayload: Content {
    let content: String
    let filename: String
    let type: String
    let disposition: String
}
