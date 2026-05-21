import SwiftUI

struct AppointmentQuestion: Identifiable {
    let id: String
    let text: LocalizedStringResource
    let localizationValue: String.LocalizationValue
}
