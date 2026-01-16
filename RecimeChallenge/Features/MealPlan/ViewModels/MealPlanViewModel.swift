import Foundation
import SwiftData

@Observable
final class MealPlanViewModel {
    private var modelContext: ModelContext?
    private(set) var selectedDate: Date = Date()

    func setContext(_ context: ModelContext) {
        self.modelContext = context
    }

    func selectDate(_ date: Date) {
        selectedDate = date
    }

    // Generate dates: 1 week before, today, and 1 week after (15 days total)
    func weekDates() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return (-7...7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: today)
        }
    }

    // MARK: - Meal Slot

    enum MealSlot: String, CaseIterable {
        case breakfast = "breakfast"
        case lunch = "lunch"
        case dinner = "dinner"
        case snacks = "snacks"

        var icon: String {
            switch self {
            case .breakfast: return "sunrise"
            case .lunch: return "sun.max"
            case .dinner: return "moon.stars"
            case .snacks: return "carrot"
            }
        }

        var displayName: String {
            rawValue.capitalized
        }
    }

    // MARK: - Meal Item Operations

    func getMealItems(for date: Date, slot: MealSlot, from mealItems: [MealItemModel]) -> [MealItemModel] {
        let calendar = Calendar.current
        return mealItems.filter {
            calendar.isDate($0.date, inSameDayAs: date) && $0.slot == slot.rawValue
        }
    }

    func addMeal(_ recipe: Recipe, for slot: MealSlot, on date: Date) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        let item = MealItemModel(date: normalizedDate, slot: slot.rawValue, recipe: recipe)
        modelContext?.insert(item)
    }

    func deleteMealItem(_ item: MealItemModel) {
        modelContext?.delete(item)
    }

    // Check if a date has any meals (for week selector indicator)
    func hasAnyMeal(on date: Date, mealItems: [MealItemModel]) -> Bool {
        let calendar = Calendar.current
        return mealItems.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
}
