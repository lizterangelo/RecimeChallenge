import Foundation

struct Cookbook: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let recipes: [Recipe]
    let coverImageURL: String?

    var recipeCount: Int {
        recipes.count
    }
}
