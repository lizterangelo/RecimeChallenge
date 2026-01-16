import Foundation

enum ContentMode: String, CaseIterable, Identifiable {
    case cookbooks = "Cookbooks"
    case allRecipes = "All Recipes"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .cookbooks: return "book.closed.fill"
        case .allRecipes: return "fork.knife"
        }
    }
}
