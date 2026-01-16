import Foundation
import SwiftData

@Model
final class MealPlanModel {
    var id: UUID
    var date: Date

    // Breakfast recipe data (stored since recipes are from JSON, not SwiftData)
    var breakfastRecipeId: UUID?
    var breakfastTitle: String?
    var breakfastImageURL: String?

    // Lunch recipe data
    var lunchRecipeId: UUID?
    var lunchTitle: String?
    var lunchImageURL: String?

    // Dinner recipe data
    var dinnerRecipeId: UUID?
    var dinnerTitle: String?
    var dinnerImageURL: String?

    // Snacks recipe data
    var snacksRecipeId: UUID?
    var snacksTitle: String?
    var snacksImageURL: String?

    var hasAnyMeal: Bool {
        breakfastRecipeId != nil || lunchRecipeId != nil ||
        dinnerRecipeId != nil || snacksRecipeId != nil
    }

    var mealCount: Int {
        [breakfastRecipeId, lunchRecipeId, dinnerRecipeId, snacksRecipeId]
            .compactMap { $0 }.count
    }

    init(id: UUID = UUID(), date: Date) {
        self.id = id
        self.date = date
    }

    func setBreakfast(_ recipe: Recipe?) {
        breakfastRecipeId = recipe?.id
        breakfastTitle = recipe?.title
        breakfastImageURL = recipe?.imageURL
    }

    func setLunch(_ recipe: Recipe?) {
        lunchRecipeId = recipe?.id
        lunchTitle = recipe?.title
        lunchImageURL = recipe?.imageURL
    }

    func setDinner(_ recipe: Recipe?) {
        dinnerRecipeId = recipe?.id
        dinnerTitle = recipe?.title
        dinnerImageURL = recipe?.imageURL
    }

    func setSnacks(_ recipe: Recipe?) {
        snacksRecipeId = recipe?.id
        snacksTitle = recipe?.title
        snacksImageURL = recipe?.imageURL
    }
}
