import SwiftUI

struct ImportedRecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let recipe: Recipe

    var body: some View {
        NavigationStack {
            RecipeDetailView(recipe: recipe)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .fontWeight(.semibold)
                        }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // TODO: Save recipe to cookbook
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                }
        }
    }
}

#Preview {
    ImportedRecipeDetailView(recipe: Recipe(
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
            "Stretch the pizza dough into a 12-inch circle."
        ],
        dietaryAttributes: [.vegetarian],
        imageURL: nil,
        preparationTime: 20,
        cookingTime: 10
    ))
}
