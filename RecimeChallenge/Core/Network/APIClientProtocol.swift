import Foundation

protocol APIClientProtocol: Sendable {
    func fetchCookbooks() async throws -> [Cookbook]
    func fetchRecipes() async throws -> [Recipe]
    func fetchRecipe(id: UUID) async throws -> Recipe
}
