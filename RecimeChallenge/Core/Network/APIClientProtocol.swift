import Foundation

struct PaginatedResponse<T: Sendable>: Sendable {
    let items: [T]
    let totalCount: Int
    let page: Int
    let pageSize: Int

    var hasNextPage: Bool {
        page * pageSize < totalCount
    }
}

protocol APIClientProtocol: Sendable {
    func fetchCookbooks(page: Int, pageSize: Int) async throws -> PaginatedResponse<Cookbook>
    func searchCookbooks(query: String, page: Int, pageSize: Int) async throws -> PaginatedResponse<Cookbook>
    func fetchRecipes(page: Int, pageSize: Int, searchQuery: String?) async throws -> PaginatedResponse<Recipe>
    func fetchRecipes() async throws -> [Recipe]
    func fetchRecipe(id: UUID) async throws -> Recipe
}
