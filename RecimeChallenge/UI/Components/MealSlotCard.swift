import SwiftUI

struct MealSlotCard: View {
    let mealType: String
    let icon: String
    let recipeTitle: String?
    let recipeImageURL: String?
    let onTap: () -> Void

    private var hasRecipe: Bool {
        recipeTitle != nil
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                if let imageURL = recipeImageURL {
                    Image(imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image(systemName: icon)
                        .font(AppFont.title2)
                        .foregroundStyle(AppColors.primary)
                        .frame(width: 60, height: 60)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(mealType)
                        .font(AppFont.headline)
                        .foregroundStyle(.primary)

                    if let title = recipeTitle {
                        Text(title)
                            .font(AppFont.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    } else {
                        Text("Tap to add a recipe")
                            .font(AppFont.subheadline)
                            .foregroundStyle(.tertiary)
                    }
                }

                Spacer()

                if hasRecipe {
                    Image(systemName: "chevron.right")
                        .font(AppFont.caption)
                        .foregroundStyle(.tertiary)
                } else {
                    Image(systemName: "plus.circle")
                        .font(AppFont.title2)
                        .foregroundStyle(AppColors.primary)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    List {
        MealSlotCard(
            mealType: "Breakfast",
            icon: "sunrise",
            recipeTitle: nil,
            recipeImageURL: nil,
            onTap: {}
        )
        MealSlotCard(
            mealType: "Lunch",
            icon: "sun.max",
            recipeTitle: "Classic Margherita Pizza",
            recipeImageURL: "recipe-photo-1",
            onTap: {}
        )
        MealSlotCard(
            mealType: "Dinner",
            icon: "moon.stars",
            recipeTitle: "Grilled Salmon",
            recipeImageURL: nil,
            onTap: {}
        )
    }
    .listStyle(.plain)
}
