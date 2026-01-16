import Foundation

final class MockAPIClient: APIClientProtocol, @unchecked Sendable {
    private let simulatedDelay: Duration
    private var cachedCookbooks: [Cookbook]?

    init(simulatedDelay: Duration = .milliseconds(500)) {
        self.simulatedDelay = simulatedDelay
    }

    func fetchCookbooks() async throws -> [Cookbook] {
        try await Task.sleep(for: simulatedDelay)
        return try loadCookbooks()
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
