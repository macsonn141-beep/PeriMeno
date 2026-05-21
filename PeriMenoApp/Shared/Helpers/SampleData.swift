import Foundation

enum SampleData {
    static var previewEntries: [DailyEntry] {
        makeEntries()
    }

    static func makeEntries(referenceDate: Date = .now) -> [DailyEntry] {
        [
            DailyEntry(
                date: referenceDate.addingTimeInterval(-86_400),
                overallScore: 3,
                moodScore: 3,
                energyScore: 2,
                sleepScore: 2,
                brainFogScore: 4,
                notes: "Slept poorly and felt scattered after lunch.",
                symptoms: [
                    SymptomLog(symptomType: "brain_fog", severity: 4),
                    SymptomLog(symptomType: "poor_sleep", severity: 3)
                ],
                triggers: [
                    TriggerLog(triggerType: "poor_sleep", intensity: 4)
                ]
            ),
            DailyEntry(
                date: referenceDate.addingTimeInterval(-2 * 86_400),
                overallScore: 4,
                moodScore: 4,
                energyScore: 3,
                sleepScore: 3,
                brainFogScore: 2,
                notes: "Better day overall.",
                symptoms: [
                    SymptomLog(symptomType: "hot_flashes", severity: 3)
                ]
            ),
            DailyEntry(
                date: referenceDate.addingTimeInterval(-4 * 86_400),
                overallScore: 2,
                moodScore: 2,
                energyScore: 2,
                sleepScore: 2,
                brainFogScore: 5,
                notes: "Used Brain Fog Mode for a low-energy day.",
                usedBrainFogMode: true,
                symptoms: [
                    SymptomLog(symptomType: "brain_fog", severity: 5),
                    SymptomLog(symptomType: "fatigue", severity: 4)
                ]
            )
        ]
    }
}
