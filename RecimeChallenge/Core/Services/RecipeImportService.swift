import Foundation

final class RecipeImportService: Sendable {
    static let shared = RecipeImportService()

    private let baseURL = "https://recimechallengebackend.onrender.com"

    private init() {}

    func importRecipe(from url: String) async throws -> Recipe {
        guard let requestURL = URL(string: "\(baseURL)/api/scrape") else {
            throw RecipeImportError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60

        let body = ScrapeRequest(url: url)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw RecipeImportError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw RecipeImportError.serverError(errorResponse.error)
            }
            throw RecipeImportError.httpError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        let importedRecipe = try decoder.decode(ImportedRecipeResponse.self, from: data)

        return Recipe(
            id: UUID(),
            title: importedRecipe.title,
            description: importedRecipe.description,
            servings: importedRecipe.servings,
            ingredients: importedRecipe.ingredients.map { ingredient in
                Ingredient(
                    id: UUID(),
                    name: ingredient.name,
                    quantity: ingredient.quantity,
                    unit: ingredient.unit
                )
            },
            instructions: importedRecipe.instructions,
            dietaryAttributes: importedRecipe.dietaryAttributes.compactMap { DietaryAttribute(rawValue: $0) },
            imageURL: importedRecipe.imageURL,
            preparationTime: importedRecipe.preparationTime,
            cookingTime: importedRecipe.cookingTime
        )
    }
}

// MARK: - Request/Response Models

private struct ScrapeRequest: Encodable {
    let url: String
}

private struct ErrorResponse: Decodable {
    let error: String
}

private struct ImportedRecipeResponse: Decodable {
    let title: String
    let description: String
    let servings: Int
    let ingredients: [ImportedIngredient]
    let instructions: [String]
    let dietaryAttributes: [String]
    let imageURL: String?
    let preparationTime: Int?
    let cookingTime: Int?
}

private struct ImportedIngredient: Decodable {
    let name: String
    let quantity: String
    let unit: String?
}

// MARK: - Errors

enum RecipeImportError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case serverError(String)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "Server error (HTTP \(code))"
        case .serverError(let message):
            return message
        case .decodingError:
            return "Failed to parse recipe data"
        }
    }
}
