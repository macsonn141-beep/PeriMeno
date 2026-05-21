import Foundation

enum HealthPermissionState: Equatable {
    case notRequested
    case unavailable
    case authorized
    case denied
}
