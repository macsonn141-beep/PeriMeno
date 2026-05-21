import Foundation
import HealthKit

@MainActor
final class HealthKitManager: ObservableObject {
    @Published private(set) var permissionState: HealthPermissionState = .notRequested
    private let healthStore = HKHealthStore()

    func requestReadAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            permissionState = .unavailable
            return
        }

        let readTypes = Set([
            HKObjectType.quantityType(forIdentifier: .restingHeartRate),
            HKObjectType.quantityType(forIdentifier: .bodyTemperature),
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
            HKObjectType.categoryType(forIdentifier: .mindfulSession)
        ].compactMap { $0 })

        do {
            try await healthStore.requestAuthorization(toShare: Set<HKSampleType>(), read: readTypes)
            permissionState = .authorized
        } catch {
            permissionState = .denied
        }
    }
}
