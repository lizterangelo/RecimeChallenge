import Foundation

enum PreviewData {
    static let sampleIngredient = Ingredient(
        id: UUID(),
        name: "olive oil",
        quantity: "2",
        unit: "tbsp"
    )

    static let sampleIngredients: [Ingredient] = [
        Ingredient(id: UUID(), name: "pizza dough", quantity: "1", unit: "lb"),
        Ingredient(id: UUID(), name: "San Marzano tomatoes", quantity: "1", unit: "can"),
        Ingredient(id: UUID(), name: "fresh mozzarella", quantity: "8", unit: "oz"),
        Ingredient(id: UUID(), name: "fresh basil leaves", quantity: "10", unit: nil),
        Ingredient(id: UUID(), name: "olive oil", quantity: "2", unit: "tbsp")
    ]

    static let sampleRecipe = Recipe(
        id: UUID(),
        title: "Classic Margherita Pizza",
        description: "A traditional Italian pizza with fresh tomatoes, mozzarella, and basil on a crispy thin crust.",
        servings: 4,
        ingredients: sampleIngredients,
        instructions: [
            "Preheat your oven to 500°F (260°C) with a pizza stone inside.",
            "Crush the San Marzano tomatoes by hand and season with salt.",
            "Stretch the pizza dough into a 12-inch circle.",
            "Spread the crushed tomatoes evenly over the dough.",
            "Tear the fresh mozzarella and distribute over the pizza.",
            "Bake for 8-10 minutes until crust is golden.",
            "Top with fresh basil and drizzle with olive oil."
        ],
        dietaryAttributes: [.vegetarian],
        imageURL: nil,
        preparationTime: 20,
        cookingTime: 10
    )

    static let sampleVeganRecipe = Recipe(
        id: UUID(),
        title: "Quinoa Buddha Bowl",
        description: "A nourishing bowl with quinoa, roasted vegetables, and tahini dressing.",
        servings: 2,
        ingredients: [
            Ingredient(id: UUID(), name: "quinoa", quantity: "1", unit: "cup"),
            Ingredient(id: UUID(), name: "chickpeas", quantity: "1", unit: "can"),
            Ingredient(id: UUID(), name: "sweet potato", quantity: "1", unit: "large"),
            Ingredient(id: UUID(), name: "kale", quantity: "2", unit: "cups")
        ],
        instructions: [
            "Cook quinoa according to package directions.",
            "Roast vegetables at 400°F for 25 minutes.",
            "Assemble and drizzle with tahini dressing."
        ],
        dietaryAttributes: [.vegan, .glutenFree],
        imageURL: nil,
        preparationTime: 15,
        cookingTime: 25
    )

    static let sampleRecipes: [Recipe] = [sampleRecipe, sampleVeganRecipe]

    static let sampleCookbook = Cookbook(
        id: UUID(),
        name: "Italian Classics",
        description: "Traditional Italian recipes passed down through generations",
        recipes: sampleRecipes,
        coverImageURL: nil
    )

    static let sampleCookbooks: [Cookbook] = [
        sampleCookbook,
        Cookbook(
            id: UUID(),
            name: "Quick & Easy",
            description: "Delicious meals ready in 30 minutes or less",
            recipes: [sampleRecipe],
            coverImageURL: nil
        )
    ]

    static let sampleGroceryItem = GroceryItem(
        id: UUID(),
        name: "Milk",
        quantity: "1 gallon",
        isChecked: false,
        category: .dairy
    )

    static let sampleGroceryItems: [GroceryItem] = [
        sampleGroceryItem,
        GroceryItem(id: UUID(), name: "Eggs", quantity: "1 dozen", isChecked: true, category: .dairy),
        GroceryItem(id: UUID(), name: "Apples", quantity: "6", isChecked: false, category: .produce),
        GroceryItem(id: UUID(), name: "Chicken breast", quantity: "1 lb", isChecked: false, category: .meat)
    ]

    static let mockAPIClient: APIClientProtocol = PreviewMockAPIClient()
}

private final class PreviewMockAPIClient: APIClientProtocol, @unchecked Sendable {
    func fetchCookbooks(page: Int, pageSize: Int) async throws -> PaginatedResponse<Cookbook> {
        PaginatedResponse(
            items: PreviewData.sampleCookbooks,
            totalCount: PreviewData.sampleCookbooks.count,
            page: page,
            pageSize: pageSize
        )
    }

    func searchCookbooks(query: String, page: Int, pageSize: Int) async throws -> PaginatedResponse<Cookbook> {
        let filtered = PreviewData.sampleCookbooks.filter {
            $0.name.lowercased().contains(query.lowercased()) ||
            $0.description.lowercased().contains(query.lowercased())
        }
        return PaginatedResponse(
            items: filtered,
            totalCount: filtered.count,
            page: page,
            pageSize: pageSize
        )
    }

    func fetchRecipes(page: Int, pageSize: Int, searchQuery: String?) async throws -> PaginatedResponse<Recipe> {
        var recipes = PreviewData.sampleRecipes
        if let query = searchQuery?.lowercased(), !query.isEmpty {
            recipes = recipes.filter {
                $0.title.lowercased().contains(query) ||
                $0.description.lowercased().contains(query)
            }
        }
        return PaginatedResponse(
            items: recipes,
            totalCount: recipes.count,
            page: page,
            pageSize: pageSize
        )
    }

    func fetchRecipes() async throws -> [Recipe] {
        PreviewData.sampleRecipes
    }

    func fetchRecipe(id: UUID) async throws -> Recipe {
        PreviewData.sampleRecipe
    }
}
