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

    func fetchRecipes(page: Int, pageSize: Int, searchQuery: String?) async throws -> PaginatedResponse<Recipe> {
        try await Task.sleep(for: simulatedDelay)

        var recipes = try loadAllRecipes()

        if let query = searchQuery?.lowercased(), !query.isEmpty {
            recipes = recipes.filter { recipe in
                recipe.title.lowercased().contains(query) ||
                recipe.description.lowercased().contains(query)
            }
        }

        return paginate(recipes, page: page, pageSize: pageSize)
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
