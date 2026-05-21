import Foundation

enum Validators {
    static func clampedScore(_ value: Int) -> Int {
        min(max(value, 0), 5)
    }

    static func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
