import Vapor

extension Application {
    public struct Cloudflare {
        let application: Application

        public var email: Email { .init(application: application) }
        public var r2: R2 { .init(application: application) }

        public struct Email {
            let application: Application

            struct ConfigurationKey: StorageKey {
                typealias Value = CloudflareEmailConfiguration
            }

            public var configuration: CloudflareEmailConfiguration {
                get {
                    guard let config: CloudflareEmailConfiguration = application.storage[ConfigurationKey.self] else {
                        fatalError("CloudflareKit email not configured. Use app.cloudflare.email.configuration = ...")
                    }
                    return config
                }
                nonmutating set {
                    application.storage[ConfigurationKey.self] = newValue
                }
            }

            public var client: CloudflareEmailClient {
                .init(
                    client: application.client,
                    logger: application.logger,
                    configuration: configuration
                )
            }
        }

        public struct R2 {
            let application: Application

            struct ConfigurationKey: StorageKey {
                typealias Value = CloudflareR2Configuration
            }

            public var configuration: CloudflareR2Configuration {
                get {
                    guard let config: CloudflareR2Configuration = application.storage[ConfigurationKey.self] else {
                        fatalError("CloudflareKit R2 not configured. Use app.cloudflare.r2.configuration = ...")
                    }
                    return config
                }
                nonmutating set {
                    application.storage[ConfigurationKey.self] = newValue
                }
            }

            public var client: CloudflareR2Client {
                .init(
                    client: application.client,
                    logger: application.logger,
                    configuration: configuration
                )
            }
        }
    }

    public var cloudflare: Cloudflare {
        .init(application: self)
    }
}

extension Request {
    public struct Cloudflare {
        let request: Request

        public var email: Email { .init(request: request) }
        public var r2: R2 { .init(request: request) }

        public struct Email {
            let request: Request

            public var client: CloudflareEmailClient {
                let config: CloudflareEmailConfiguration = request.application.cloudflare.email.configuration
                return .init(
                    client: request.client,
                    logger: request.logger,
                    configuration: config
                )
            }
        }

        public struct R2 {
            let request: Request

            public var client: CloudflareR2Client {
                let config: CloudflareR2Configuration = request.application.cloudflare.r2.configuration
                return .init(
                    client: request.client,
                    logger: request.logger,
                    configuration: config
                )
            }
        }
    }

    public var cloudflare: Cloudflare {
        .init(request: self)
    }
}
