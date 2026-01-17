import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let imageString = recipe.imageURL {
                    recipeImage(imageString)
                }

                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    infoSection
                    ingredientsSection
                    instructionsSection
                }
                .padding()
            }
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.title)
                .font(AppFont.title)
                .fontWeight(.bold)

            Text(recipe.description)
                .font(AppFont.body)
                .foregroundStyle(.secondary)

            if !recipe.dietaryAttributes.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(recipe.dietaryAttributes) { attribute in
                            DietaryBadge(attribute: attribute)
                        }
                    }
                }
            }
        }
    }

    private var infoSection: some View {
        GlassCard {
            HStack(spacing: 24) {
                infoItem(icon: "person.2", title: "Servings", value: "\(recipe.servings)")

                if let prepTime = recipe.preparationTime {
                    infoItem(icon: "clock", title: "Prep", value: "\(prepTime)m")
                }

                if let cookTime = recipe.cookingTime {
                    infoItem(icon: "flame", title: "Cook", value: "\(cookTime)m")
                }

                if let totalTime = recipe.totalTimeFormatted {
                    infoItem(icon: "timer", title: "Total", value: totalTime)
                }
            }
            .padding()
        }
    }

    private func infoItem(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(AppFont.title2)
                .foregroundStyle(Color.accentColor)

            Text(value)
                .font(AppFont.headline)

            Text(title)
                .font(AppFont.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Ingredients", systemImage: "basket")
                .font(AppFont.title2)
                .fontWeight(.semibold)

            GlassCard {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(recipe.ingredients) { ingredient in
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(AppFont.bulletPoint)
                                .foregroundStyle(.secondary)

                            Text(ingredient.displayText)
                                .font(AppFont.body)

                            Spacer()
                        }
                    }
                }
                .padding()
            }
        }
    }

    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Instructions", systemImage: "list.number")
                .font(AppFont.title2)
                .fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(AppFont.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.primary)
                            .frame(width: 28, height: 28)
                            .background(AppColors.primary.opacity(0.15))
                            .clipShape(Circle())

                        HighlightedInstructionText(
                            text: instruction,
                            keywords: ingredientKeywords
                        )
                    }
                }
            }
        }
    }

    private var ingredientKeywords: [String] {
        recipe.ingredients.map { $0.name.lowercased() }
    }

    @ViewBuilder
    private func recipeImage(_ imageString: String) -> some View {
        if imageString.hasPrefix("http://") || imageString.hasPrefix("https://"),
           let url = URL(string: imageString) {
            // Remote URL
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay { ProgressView() }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .clipped()
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        }
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            // Local asset
            Image(imageString)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe(
            id: UUID(),
            title: "Classic Margherita Pizza",
            description: "A traditional Italian pizza with fresh tomatoes, mozzarella, and basil.",
            servings: 4,
            ingredients: [
                Ingredient(id: UUID(), name: "pizza dough", quantity: "1", unit: "lb"),
                Ingredient(id: UUID(), name: "San Marzano tomatoes", quantity: "1", unit: "can"),
                Ingredient(id: UUID(), name: "fresh mozzarella", quantity: "8", unit: "oz")
            ],
            instructions: [
                "Preheat your oven to 500°F with a pizza stone inside.",
                "Crush the San Marzano tomatoes by hand.",
                "Stretch the pizza dough into a 12-inch circle.",
                "Spread the crushed tomatoes evenly over the dough.",
                "Bake for 8-10 minutes until crust is golden."
            ],
            dietaryAttributes: [.vegetarian],
            imageURL: "recipe-photo-1",
            preparationTime: 20,
            cookingTime: 10
        ))
    }
}
