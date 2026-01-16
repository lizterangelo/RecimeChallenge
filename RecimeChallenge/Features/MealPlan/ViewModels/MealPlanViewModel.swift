import Foundation

@Observable
final class MealPlanViewModel {
    private(set) var weekPlan: [MealPlan] = []
    private(set) var selectedDate: Date = Date()

    init() {
        generateWeekPlan()
    }

    func generateWeekPlan() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        weekPlan = (0..<7).compactMap { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: today) else {
                return nil
            }
            return MealPlan(id: UUID(), date: date, breakfast: nil, lunch: nil, dinner: nil)
        }
    }

    func selectDate(_ date: Date) {
        selectedDate = date
    }

    var selectedDayPlan: MealPlan? {
        weekPlan.first { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
}
