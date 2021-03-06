import Foundation
import ChameleonKit

extension SlackBot.EarlyWarning {
    public struct Config {
        /// Channel to report new users whose email domain that match one of the provided domains
        /// Provide `nil` to not report on this
        public var alertChannel: Identifier<Channel>?

        /// Channel to report new users whose email domain _doesn't_ match one of the provided domains
        /// Provide `nil` to not report on this
        public var emailChannel: Identifier<Channel>?

        /// Domains to check new users emails against
        public var domains: Set<String>

        public init(alertChannel: String?, emailChannel: String?, domains: Set<String>) {
            self.alertChannel = alertChannel.map(Identifier.init(rawValue:))
            self.emailChannel = emailChannel.map(Identifier.init(rawValue:))
            self.domains = domains
        }

        public static func `default`() throws -> Config {
            let blocklistUrl = URL(string: "https://raw.githubusercontent.com/martenson/disposable-email-domains/master/disposable_email_blocklist.conf")!
            let blocklist = try Array(import: blocklistUrl, delimiters: .newlines)
            
            let blocklistUrl2 = URL(string: "https://raw.githubusercontent.com/andreis/disposable-email-domains/master/domains.txt")!
            let blocklist2 = try Array(import: blocklistUrl2, delimiters: .newlines)
            

            let domains = [
                "apkmd.com",
                "autism.exposed",
                "car101.pro",
                "deaglenation.tv",
                "gamergate.us",
                "housat.com",
                "muslims.exposed",
                "nutpa.net",
                "p33.org",
                "vps30.com",
                "awdrt.com",
                "awdrt.net",
                "ttirv.com",
                "ttirv.net",
                "kewrg.com",
                "royandk.com",
                "opwebw.com",
                "yevme.com",
                "ktumail.com",
                "tastrg.com",
                "andsee.org",
                "gomail5.com",
                "mailerv.net",
                "eoopy.com",
                "mail2paste.com",
                "vmani.com",
                "miucce.online",
                "avxrja.com"
            ]

            return .init(alertChannel: "admins", emailChannel: "new-users", domains: Set(blocklist + blocklist2 + domains))
        }
    }
}

private extension Array where Element == String {
    init(import: URL, delimiters: CharacterSet) throws {
        let data = try Data(contentsOf: `import`)
        if  let string = String(data: data, encoding: .utf8) {
            self = string.components(separatedBy: delimiters)

        } else {
            self = []
        }
    }
}
