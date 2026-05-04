import Vapor

extension Application {
    public struct Cloudflare {
        let application: Application

        struct ConfigurationKey: StorageKey {
            typealias Value = CloudflareConfiguration
        }

        public var configuration: CloudflareConfiguration {
            get {
                guard let config: CloudflareConfiguration = self.application.storage[ConfigurationKey.self] else {
                    fatalError("CloudflareKit not configured. Use app.cloudflare.configuration = ...")
                }
                return config
            }
            nonmutating set {
                self.application.storage[ConfigurationKey.self] = newValue
            }
        }

        public var client: CloudflareClient {
            .init(
                client: application.client,
                logger: application.logger,
                configuration: configuration
            )
        }
    }

    public var cloudflare: Cloudflare {
        .init(application: self)
    }
}
