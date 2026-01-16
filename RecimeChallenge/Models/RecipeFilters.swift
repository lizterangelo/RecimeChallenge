import Foundation

struct RecipeFilters: Sendable, Equatable {
    var isVegetarian: Bool?
    var servings: Int?
    var includedIngredients: [String] = []
    var excludedIngredients: [String] = []
    var searchInInstructions: String?

    var isActive: Bool {
        isVegetarian != nil ||
        servings != nil ||
        !includedIngredients.isEmpty ||
        !excludedIngredients.isEmpty ||
        searchInInstructions != nil
    }

    static var empty: RecipeFilters {
        RecipeFilters()
    }
}
