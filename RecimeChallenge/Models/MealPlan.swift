import Foundation

struct MealPlan: Codable, Identifiable {
    let id: UUID
    let date: Date
    var breakfast: Recipe?
    var lunch: Recipe?
    var dinner: Recipe?

    var hasAnyMeal: Bool {
        breakfast != nil || lunch != nil || dinner != nil
    }

    var mealCount: Int {
        [breakfast, lunch, dinner].compactMap { $0 }.count
    }
}
