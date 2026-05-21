import Foundation
import SwiftUI

struct TriggerDefinition: Identifiable, Hashable {
    let id: String
    let localizationKey: LocalizedStringResource

    static func == (lhs: TriggerDefinition, rhs: TriggerDefinition) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum TriggerCatalog {
    static let defaults: [TriggerDefinition] = [
        TriggerDefinition(id: "alcohol", localizationKey: "trigger.alcohol"),
        TriggerDefinition(id: "caffeine", localizationKey: "trigger.caffeine"),
        TriggerDefinition(id: "spicy_food", localizationKey: "trigger.spicy_food"),
        TriggerDefinition(id: "sugar", localizationKey: "trigger.sugar"),
        TriggerDefinition(id: "stress", localizationKey: "trigger.stress"),
        TriggerDefinition(id: "poor_sleep", localizationKey: "trigger.poor_sleep"),
        TriggerDefinition(id: "exercise", localizationKey: "trigger.exercise"),
        TriggerDefinition(id: "heat", localizationKey: "trigger.heat"),
        TriggerDefinition(id: "travel", localizationKey: "trigger.travel"),
        TriggerDefinition(id: "illness", localizationKey: "trigger.illness")
    ]
}
