import Foundation
import OSLog

enum Logger {
    private static let logger = os.Logger(subsystem: "com.perimeno.app", category: "local")

    static func debug(_ message: String) {
        #if DEBUG
        logger.debug("\(message, privacy: .public)")
        #endif
    }
}
