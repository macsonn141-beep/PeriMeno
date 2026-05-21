import Foundation
import LocalAuthentication

@MainActor
final class BiometricLockManager: ObservableObject {
    @Published private(set) var isUnlocked = true

    func canUseBiometrics() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    func unlock() async -> Bool {
        let context = LAContext()
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: String(localized: "security.faceID.reason")
            )
            isUnlocked = success
            return success
        } catch {
            isUnlocked = false
            return false
        }
    }
}
