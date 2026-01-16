import Foundation

struct GroceryItem: Codable, Identifiable {
    let id: UUID
    let name: String
    let quantity: String
    var isChecked: Bool
    let category: GroceryCategory

    var displayText: String {
        quantity.isEmpty ? name : "\(quantity) \(name)"
    }
}

enum GroceryCategory: String, Codable, CaseIterable, Identifiable {
    case produce
    case dairy
    case meat
    case pantry
    case frozen
    case other

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }

    var iconName: String {
        switch self {
        case .produce: return "leaf"
        case .dairy: return "cup.and.saucer"
        case .meat: return "fork.knife"
        case .pantry: return "cabinet"
        case .frozen: return "snowflake"
        case .other: return "basket"
        }
    }
}
