import SwiftUI

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
    VStack {
        MealSlotCard(mealType: "Breakfast", icon: "sunrise", recipe: nil)
        MealSlotCard(mealType: "Lunch", icon: "sun.max", recipe: nil)
    }
    .padding()
}
