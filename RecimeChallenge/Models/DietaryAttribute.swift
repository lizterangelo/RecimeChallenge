import Foundation

enum DietaryAttribute: String, Codable, CaseIterable, Identifiable {
    case vegetarian
    case vegan
    case glutenFree = "gluten-free"
    case dairyFree = "dairy-free"
    case nutFree = "nut-free"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .vegetarian: return "Vegetarian"
        case .vegan: return "Vegan"
        case .glutenFree: return "Gluten-Free"
        case .dairyFree: return "Dairy-Free"
        case .nutFree: return "Nut-Free"
        }
    }
}
