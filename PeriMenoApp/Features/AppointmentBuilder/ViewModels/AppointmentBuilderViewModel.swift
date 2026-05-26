import Foundation

@MainActor
final class AppointmentBuilderViewModel: ObservableObject {
    @Published private(set) var questions: [AppointmentQuestion] = [
        AppointmentQuestion(id: "symptoms", text: "appointment.question.symptoms", localizationValue: "appointment.question.symptoms"),
        AppointmentQuestion(id: "sleep", text: "appointment.question.sleep", localizationValue: "appointment.question.sleep"),
        AppointmentQuestion(id: "options", text: "appointment.question.options", localizationValue: "appointment.question.options")
    ]

    func makePrep(entries: [DailyEntry]) -> AppointmentPrep {
        AppointmentPrep(
            dateRange: String.pmLocalized( "appointment.range.placeholder"),
            topSymptomsSummary: String.pmLocalized( "appointment.topSymptoms") + " \(entries.flatMap(\.symptoms).count)",
            medicationSummary: String.pmLocalized( "appointment.medications.placeholder"),
            suggestedQuestions: questions.map { String.pmLocalized("appointment.question.\($0.id)") }
        )
    }
}
