import SwiftUI

struct HealthAccessView: View {
    @StateObject private var manager = HealthKitManager()

    var body: some View {
        List {
            Section {
                Text("health.body")
                    .foregroundStyle(.secondary)

                Button {
                    Task {
                        await manager.requestReadAuthorization()
                    }
                } label: {
                    Label("health.request", systemImage: "heart.text.square")
                }
            } header: {
                Text("health.section.permission")
            }

            Section("health.section.status") {
                Text(statusText)
            }
        }
        .navigationTitle("health.title")
    }

    private var statusText: LocalizedStringResource {
        switch manager.permissionState {
        case .notRequested:
            "health.status.notRequested"
        case .unavailable:
            "health.status.unavailable"
        case .authorized:
            "health.status.authorized"
        case .denied:
            "health.status.denied"
        }
    }
}
