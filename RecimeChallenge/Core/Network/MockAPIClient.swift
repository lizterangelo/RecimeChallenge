import Foundation

final class MockAPIClient: APIClientProtocol, @unchecked Sendable {
    private let simulatedDelay: Duration
    private var cachedCookbooks: [Cookbook]?

    init(simulatedDelay: Duration = .milliseconds(300)) {
        self.simulatedDelay = simulatedDelay
    }

    func fetchCookbooks(page: Int, pageSize: Int) async throws -> PaginatedResponse<Cookbook> {
        try await Task.sleep(for: simulatedDelay)

        let allCookbooks = try loadCookbooks()
        let startIndex = (page - 1) * pageSize
        let endIndex = min(startIndex + pageSize, allCookbooks.count)

        guard startIndex < allCookbooks.count else {
            return PaginatedResponse(
                items: [],
                totalCount: allCookbooks.count,
                page: page,
                pageSize: pageSize
            )
        }

        let items = Array(allCookbooks[startIndex..<endIndex])

        return PaginatedResponse(
            items: items,
            totalCount: allCookbooks.count,
            page: page,
            pageSize: pageSize
        )
    }

    func fetchRecipes() async throws -> [Recipe] {
        try await Task.sleep(for: simulatedDelay)
        let cookbooks = try loadCookbooks()
        return cookbooks.flatMap { $0.recipes }
    }

    func fetchRecipe(id: UUID) async throws -> Recipe {
        try await Task.sleep(for: simulatedDelay)
        let cookbooks = try loadCookbooks()
        let allRecipes = cookbooks.flatMap { $0.recipes }

        guard let recipe = allRecipes.first(where: { $0.id == id }) else {
            throw APIError.notFound
        }

        return recipe
    }

    private func loadCookbooks() throws -> [Cookbook] {
        if let cached = cachedCookbooks {
            return cached
        }

        let cookbooks = try JSONLoader.load("recipes", as: [Cookbook].self)
        cachedCookbooks = cookbooks
        return cookbooks
    }
}
