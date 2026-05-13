import Foundation
import Vapor

public struct CloudflareR2Client: Sendable {
    let client: any Client
    let logger: Logger
    let configuration: CloudflareR2Configuration

    /// Upload data to R2 with a PUT request.
    public func upload(key: String, data: ByteBuffer, contentType: String) async throws {
        guard let url = URL(string: configuration.objectURL(for: key)) else {
            throw CloudflareR2Error.invalidURL
        }

        let signer: AWSSigner = makeSigner()
        let signedURL: URL = signer.signURL(
            url: url,
            method: .PUT,
            expires: 300
        )

        let response: ClientResponse = try await client.put(URI(string: signedURL.absoluteString)) { req in
            req.headers.replaceOrAdd(name: .contentType, value: contentType)
            req.body = data
        }

        guard response.status == .ok || response.status == .created else {
            throw CloudflareR2Error.uploadFailed
        }
    }

    /// Download a file from R2, returning the raw bytes.
    public func download(key: String) async throws -> ByteBuffer {
        guard let url = URL(string: configuration.objectURL(for: key)) else {
            throw CloudflareR2Error.invalidURL
        }

        let signer: AWSSigner = makeSigner()
        let signedURL: URL = signer.signURL(
            url: url,
            method: .GET,
            expires: 300
        )

        let response: ClientResponse = try await client.get(URI(string: signedURL.absoluteString))

        guard let body: ByteBuffer = response.body else {
            throw CloudflareR2Error.downloadFailed
        }

        return body
    }

    /// Delete a file from R2.
    public func delete(key: String) async throws {
        guard let url = URL(string: configuration.objectURL(for: key)) else {
            throw CloudflareR2Error.invalidURL
        }

        let signer: AWSSigner = makeSigner()
        let signedURL: URL = signer.signURL(
            url: url,
            method: .DELETE,
            expires: 300
        )

        do {
            _ = try await client.delete(URI(string: signedURL.absoluteString))
        } catch {
            throw CloudflareR2Error.deleteFailed
        }
    }

    /// Generate a presigned PUT URL for frontend direct upload.
    public func presignedUploadURL(key: String, contentType: String, expires: Int = 900) throws -> String {
        guard let url = URL(string: configuration.objectURL(for: key)) else {
            throw CloudflareR2Error.invalidURL
        }

        let signer: AWSSigner = makeSigner()
        let signedURL: URL = signer.signURL(
            url: url,
            method: .PUT,
            expires: expires
        )

        return signedURL.absoluteString
    }

    /// Generate a presigned GET URL with content-disposition for download.
    public func presignedDownloadURL(key: String, filename: String, expires: Int = 900) throws -> String {
        guard let baseURL = URL(string: configuration.objectURL(for: key)) else {
            throw CloudflareR2Error.invalidURL
        }

        let signer: AWSSigner = makeSigner()
        let signedURL: URL = signer.signURL(
            url: baseURL,
            method: .GET,
            expires: expires,
            additionalQueryParams: [
                "response-content-disposition": "attachment;filename=\(filename)"
            ]
        )

        return signedURL.absoluteString
    }

    // MARK: - Private

    private func makeSigner() -> AWSSigner {
        let credentials: StaticCredential = StaticCredential(
            accessKeyId: configuration.accessKey,
            secretAccessKey: configuration.secretKey
        )
        return AWSSigner(credentials: credentials, name: "s3", region: configuration.region)
    }
}
