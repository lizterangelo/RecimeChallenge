import SwiftUI

struct MealPlanView: View {
    @State private var viewModel = MealPlanViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    weekSelector
                    mealCards
                }
                .padding()
            }
            .navigationTitle("Meal Plan")
        }
    }

    private var weekSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.weekPlan) { day in
                    DayButton(
                        date: day.date,
                        isSelected: Calendar.current.isDate(day.date, inSameDayAs: viewModel.selectedDate),
                        hasMeals: day.hasAnyMeal
                    ) {
                        viewModel.selectDate(day.date)
                    }
                }
            }
        }
    }

    private var mealCards: some View {
        VStack(spacing: 16) {
            MealSlotCard(mealType: "Breakfast", icon: "sunrise", recipe: viewModel.selectedDayPlan?.breakfast)
            MealSlotCard(mealType: "Lunch", icon: "sun.max", recipe: viewModel.selectedDayPlan?.lunch)
            MealSlotCard(mealType: "Dinner", icon: "moon.stars", recipe: viewModel.selectedDayPlan?.dinner)
        }
    }
}

#Preview {
    MealPlanView()
}
