import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(AppFont.headline)
                    .lineLimit(1)

                Text(recipe.description)
                    .font(AppFont.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Label("\(recipe.servings)", systemImage: "person.2")
                        .font(AppFont.caption)
                        .foregroundStyle(.tertiary)

                    if let time = recipe.totalTimeFormatted {
                        Label(time, systemImage: "clock")
                            .font(AppFont.caption)
                            .foregroundStyle(.tertiary)
                    }

                    ForEach(recipe.dietaryAttributes.prefix(2)) { attribute in
                        DietaryBadge(attribute: attribute)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(AppFont.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        RecipeRowView(recipe: Recipe(
            id: UUID(),
            title: "Margherita Pizza",
            description: "Classic Italian pizza with tomatoes and mozzarella",
            servings: 4,
            ingredients: [],
            instructions: [],
            dietaryAttributes: [.vegetarian],
            imageURL: nil,
            preparationTime: 20,
            cookingTime: 10
        ))
    }
}
