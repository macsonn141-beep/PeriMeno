import SwiftUI

struct HomeAction: Identifiable {
    let id: String
    let title: LocalizedStringResource
    let systemImage: String
    let route: AppRoute?
    let tab: AppTab?
}
