import Foundation

final class MockAPIClient: APIClientProtocol, @unchecked Sendable {
    private let simulatedDelay: Duration
    private var cachedCookbooks: [Cookbook]?
    private var cachedAllRecipes: [Recipe]?

    init(simulatedDelay: Duration = .milliseconds(300)) {
        self.simulatedDelay = simulatedDelay
    }

    func fetchCookbooks(page: Int, pageSize: Int) async throws -> PaginatedResponse<Cookbook> {
        try await Task.sleep(for: simulatedDelay)

        let allCookbooks = try loadCookbooks()
        return paginate(allCookbooks, page: page, pageSize: pageSize)
    }

    func searchCookbooks(query: String, page: Int, pageSize: Int) async throws -> PaginatedResponse<Cookbook> {
        try await Task.sleep(for: simulatedDelay)

        var cookbooks = try loadCookbooks()

        if !query.isEmpty {
            let lowercased = query.lowercased()
            cookbooks = cookbooks.filter { cookbook in
                cookbook.name.lowercased().contains(lowercased) ||
                cookbook.description.lowercased().contains(lowercased)
            }
        }

        return paginate(cookbooks, page: page, pageSize: pageSize)
    }

    func fetchRecipes(_ request: RecipeSearchRequest) async throws -> PaginatedResponse<Recipe> {
        try await Task.sleep(for: simulatedDelay)

        var recipes = try loadAllRecipes()

        // Text search (title and description)
        if let query = request.searchQuery?.lowercased(), !query.isEmpty {
            recipes = recipes.filter { recipe in
                recipe.title.lowercased().contains(query) ||
                recipe.description.lowercased().contains(query)
            }
        }

        // Apply advanced filters
        if let filters = request.filters {
            // Vegetarian filter
            if let isVegetarian = filters.isVegetarian, isVegetarian {
                recipes = recipes.filter { recipe in
                    recipe.dietaryAttributes.contains { $0.rawValue.lowercased() == "vegetarian" }
                }
            }

            // Servings filter
            if let servings = filters.servings {
                recipes = recipes.filter { $0.servings == servings }
            }

            // Include ingredients filter
            if !filters.includedIngredients.isEmpty {
                recipes = recipes.filter { recipe in
                    filters.includedIngredients.allSatisfy { ingredient in
                        recipe.ingredients.contains {
                            $0.name.lowercased().contains(ingredient.lowercased())
                        }
                    }
                }
            }

            // Exclude ingredients filter
            if !filters.excludedIngredients.isEmpty {
                recipes = recipes.filter { recipe in
                    !filters.excludedIngredients.contains { ingredient in
                        recipe.ingredients.contains {
                            $0.name.lowercased().contains(ingredient.lowercased())
                        }
                    }
                }
            }

            // Search in instructions
            if let instructionQuery = filters.searchInInstructions?.lowercased(), !instructionQuery.isEmpty {
                recipes = recipes.filter { recipe in
                    recipe.instructions.contains { instruction in
                        instruction.lowercased().contains(instructionQuery)
                    }
                }
            }
        }

        return paginate(recipes, page: request.page, pageSize: request.pageSize)
    }

    func fetchRecipes() async throws -> [Recipe] {
        try await Task.sleep(for: simulatedDelay)
        return try loadAllRecipes()
    }

    func fetchRecipe(id: UUID) async throws -> Recipe {
        try await Task.sleep(for: simulatedDelay)
        let allRecipes = try loadAllRecipes()

        guard let recipe = allRecipes.first(where: { $0.id == id }) else {
            throw APIError.notFound
        }

        return recipe
    }

    // MARK: - Private Helpers

    private func loadCookbooks() throws -> [Cookbook] {
        if let cached = cachedCookbooks {
            return cached
        }

        let cookbooks = try JSONLoader.load("recipes", as: [Cookbook].self)
        cachedCookbooks = cookbooks
        return cookbooks
    }

    private func loadAllRecipes() throws -> [Recipe] {
        if let cached = cachedAllRecipes {
            return cached
        }

        let cookbooks = try loadCookbooks()
        let recipes = cookbooks.flatMap { $0.recipes }
        cachedAllRecipes = recipes
        return recipes
    }

    private func paginate<T>(_ items: [T], page: Int, pageSize: Int) -> PaginatedResponse<T> {
        let startIndex = (page - 1) * pageSize
        let endIndex = min(startIndex + pageSize, items.count)

        guard startIndex < items.count else {
            return PaginatedResponse(
                items: [],
                totalCount: items.count,
                page: page,
                pageSize: pageSize
            )
        }

        return PaginatedResponse(
            items: Array(items[startIndex..<endIndex]),
            totalCount: items.count,
            page: page,
            pageSize: pageSize
        )
    }
}
