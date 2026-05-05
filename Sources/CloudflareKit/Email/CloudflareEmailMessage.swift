import Vapor

struct CloudflareEmailMessage: Content {
    let from: CloudflareEmailAddressObject
    let to: [String]
    let cc: [String]?
    let bcc: [String]?
    let replyTo: CloudflareEmailAddressObject?
    let subject: String
    let text: String?
    let html: String?
    let attachments: [CloudflareEmailAttachmentPayload]?

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

struct CloudflareEmailAttachmentPayload: Content {
    let content: String
    let filename: String
    let type: String
    let disposition: String
}
