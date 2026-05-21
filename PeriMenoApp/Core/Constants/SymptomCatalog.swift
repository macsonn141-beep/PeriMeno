import Foundation
import SwiftUI

struct SymptomDefinition: Identifiable, Hashable {
    let id: String
    let localizationKey: LocalizedStringResource
    let category: String
    let iconName: String

    static func == (lhs: SymptomDefinition, rhs: SymptomDefinition) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum SymptomCatalog {
    static let defaults: [SymptomDefinition] = [
        SymptomDefinition(id: "hot_flashes", localizationKey: "symptom.hot_flashes", category: "vasomotor", iconName: "thermometer.sun"),
        SymptomDefinition(id: "night_sweats", localizationKey: "symptom.night_sweats", category: "vasomotor", iconName: "moon.zzz"),
        SymptomDefinition(id: "poor_sleep", localizationKey: "symptom.poor_sleep", category: "sleep", iconName: "bed.double"),
        SymptomDefinition(id: "insomnia", localizationKey: "symptom.insomnia", category: "sleep", iconName: "eyes"),
        SymptomDefinition(id: "fatigue", localizationKey: "symptom.fatigue", category: "energy", iconName: "battery.25"),
        SymptomDefinition(id: "low_energy", localizationKey: "symptom.low_energy", category: "energy", iconName: "bolt.slash"),
        SymptomDefinition(id: "anxiety", localizationKey: "symptom.anxiety", category: "mood", iconName: "cloud"),
        SymptomDefinition(id: "irritability", localizationKey: "symptom.irritability", category: "mood", iconName: "exclamationmark.bubble"),
        SymptomDefinition(id: "low_mood", localizationKey: "symptom.low_mood", category: "mood", iconName: "face.dashed"),
        SymptomDefinition(id: "mood_swings", localizationKey: "symptom.mood_swings", category: "mood", iconName: "arrow.up.arrow.down"),
        SymptomDefinition(id: "brain_fog", localizationKey: "symptom.brain_fog", category: "cognitive", iconName: "brain.head.profile"),
        SymptomDefinition(id: "forgetfulness", localizationKey: "symptom.forgetfulness", category: "cognitive", iconName: "questionmark.circle"),
        SymptomDefinition(id: "headache", localizationKey: "symptom.headache", category: "body", iconName: "bandage"),
        SymptomDefinition(id: "joint_pain", localizationKey: "symptom.joint_pain", category: "body", iconName: "figure.walk"),
        SymptomDefinition(id: "muscle_aches", localizationKey: "symptom.muscle_aches", category: "body", iconName: "figure.strengthtraining.traditional"),
        SymptomDefinition(id: "breast_tenderness", localizationKey: "symptom.breast_tenderness", category: "body", iconName: "heart"),
        SymptomDefinition(id: "bloating", localizationKey: "symptom.bloating", category: "body", iconName: "circle.dashed"),
        SymptomDefinition(id: "weight_gain_feeling", localizationKey: "symptom.weight_gain_feeling", category: "body", iconName: "scalemass"),
        SymptomDefinition(id: "vaginal_dryness", localizationKey: "symptom.vaginal_dryness", category: "body", iconName: "drop"),
        SymptomDefinition(id: "low_libido", localizationKey: "symptom.low_libido", category: "body", iconName: "heart.slash"),
        SymptomDefinition(id: "palpitations", localizationKey: "symptom.palpitations", category: "body", iconName: "waveform.path.ecg"),
        SymptomDefinition(id: "skin_changes", localizationKey: "symptom.skin_changes", category: "body", iconName: "sparkles"),
        SymptomDefinition(id: "cycle_irregularity", localizationKey: "symptom.cycle_irregularity", category: "cycle", iconName: "calendar")
    ]

    static let brainFogPinned = Array(defaults.prefix(6))
}
