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

struct DayButton: View {
    let date: Date
    let isSelected: Bool
    let hasMeals: Bool
    let action: () -> Void

    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayFormatter.string(from: date))
                    .font(AppFont.caption)
                    .foregroundStyle(isSelected ? .white : .secondary)

                Text(dateFormatter.string(from: date))
                    .font(AppFont.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(isSelected ? .white : .primary)

                Circle()
                    .fill(hasMeals ? Color.green : Color.clear)
                    .frame(width: 6, height: 6)
            }
            .frame(width: 50, height: 70)
            .background(isSelected ? Color.accentColor : Color.clear)
            .glassCard(cornerRadius: 12)
        }
        .buttonStyle(.plain)
    }
}

struct MealSlotCard: View {
    let mealType: String
    let icon: String
    let recipe: Recipe?

    var body: some View {
        GlassCard {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(AppFont.title2)
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(mealType)
                        .font(AppFont.headline)

                    if let recipe {
                        Text(recipe.title)
                            .font(AppFont.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Tap to add a meal")
                            .font(AppFont.subheadline)
                            .foregroundStyle(.tertiary)
                    }
                }

                Spacer()

                Image(systemName: "plus.circle")
                    .font(AppFont.title2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
    }
}

#Preview {
    MealPlanView()
}
