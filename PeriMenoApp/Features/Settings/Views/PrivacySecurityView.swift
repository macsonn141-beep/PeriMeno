import SwiftUI

struct PrivacySecurityView: View {
    var body: some View {
        List {
            Section("privacy.section.local") {
                Label("privacy.noAccount", systemImage: "person.crop.circle.badge.xmark")
                Label("privacy.noServer", systemImage: "externaldrive.badge.xmark")
                Label("privacy.noAds", systemImage: "hand.raised")
                Label("privacy.noAnalytics", systemImage: "chart.bar.xaxis")
            }

            Section("privacy.section.security") {
                Text("privacy.security.body")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("privacy.title")
    }
}
