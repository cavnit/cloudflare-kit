import Vapor

public struct CloudflareEmailAttachment: Sendable {
    public let name: String
    public let type: String
    public let byteBuffer: ByteBuffer
    public let disposition: Disposition

    public enum Disposition: String, Sendable {
        case attachment
        case inline
    }

    public init(
        name: String,
        type: String,
        byteBuffer: ByteBuffer,
        disposition: Disposition = .attachment
    ) {
        self.name = name
        self.type = type
        self.byteBuffer = byteBuffer
        self.disposition = disposition
    }
}
