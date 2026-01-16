import Foundation
import SwiftData

@Model
final class MealItemModel {
    var id: UUID
    var date: Date
    var slot: String
    var recipeId: UUID
    var recipeTitle: String
    var recipeImageURL: String?

    init(date: Date, slot: String, recipe: Recipe) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.slot = slot
        self.recipeId = recipe.id
        self.recipeTitle = recipe.title
        self.recipeImageURL = recipe.imageURL
    }
}
