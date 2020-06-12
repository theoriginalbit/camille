import Foundation
import CamilleServices
import ChameleonKit
import VaporProviders
import LegibleError

let env = Environment()

let keyValueStore: KeyValueStorage
let storage: Storage

#if !os(Linux)
keyValueStore = MemoryKeyValueStorage()
storage = PListStorage(name: "camille")
#else
let storageUrl = URL(string: try env.get(forKey: "STORAGE_URL"))!
keyValueStore = RedisKeyValueStorage(url: storageUrl)
storage = RedisStorage(url: storageUrl)
#endif

let bot = try SlackBot
    .vaporBased(
        verificationToken: try env.get(forKey: "VERIFICATION_TOKEN"),
        accessToken: try env.get(forKey: "ACCESS_TOKEN")
    )
    .enableHello()
    .enableKarma(config: .default(), storage: storage)
    .enableEarlyWarning(config: .default())

bot.listen(for: .error) { bot, error in
    let channel = Identifier<Channel>(rawValue: "#camille_errors")
    try bot.perform(.speak(in: channel, "\("Error: ", .bold) \(error.legibleLocalizedDescription)"))
}

try bot.start()
