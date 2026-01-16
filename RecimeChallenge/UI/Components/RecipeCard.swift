import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 0) {
                if let imageName = recipe.imageURL {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .clipped()
                        .contentShape(Rectangle())
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(recipe.title)
                            .font(AppFont.headline)
                            .lineLimit(1)

                        Spacer()

                        if let time = recipe.totalTimeFormatted {
                            Label(time, systemImage: "clock")
                                .font(AppFont.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text(recipe.description)
                        .font(AppFont.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    HStack(spacing: 12) {
                        Label("\(recipe.servings)", systemImage: "person.2")
                            .font(AppFont.caption)
                            .foregroundStyle(.secondary)

                        if !recipe.dietaryAttributes.isEmpty {
                            HStack(spacing: 4) {
                                ForEach(recipe.dietaryAttributes.prefix(2)) { attribute in
                                    DietaryBadge(attribute: attribute)
                                }
                            }
                        }

                        Spacer()
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()

        RecipeCard(recipe: Recipe(
            id: UUID(),
            title: "Classic Margherita Pizza",
            description: "A traditional Italian pizza with fresh tomatoes, mozzarella, and basil.",
            servings: 4,
            ingredients: [],
            instructions: [],
            dietaryAttributes: [.vegetarian],
            imageURL: "recipe-photo-1",
            preparationTime: 20,
            cookingTime: 10
        ))
        .padding()
    }
}
