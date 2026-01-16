import Foundation
import WebKit

@Observable
final class ImportRecipeViewModel {
    var webView: WKWebView?
    var currentURL: String?
    var importedRecipe: Recipe?
    var isLoading = false
    var errorMessage: String?

    @MainActor
    func importRecipe() async {
        guard let url = currentURL else {
            errorMessage = "No URL to import"
            return
        }

        isLoading = true
        errorMessage = nil

        // Track import started
        AnalyticsService.shared.track(.importRecipeTapped, properties: ["url": url])

        do {
            print("[ImportRecipe] Importing from URL: \(url)")
            let recipe = try await RecipeImportService.shared.importRecipe(from: url)
            print("[ImportRecipe] Success: \(recipe.title)")
            importedRecipe = recipe

            // Track import success
            AnalyticsService.shared.track(.importRecipeSuccess, properties: [
                "recipe_title": recipe.title,
                "source_url": url
            ])
        } catch {
            print("[ImportRecipe] Error: \(error)")
            errorMessage = error.localizedDescription

            // Track import failure
            AnalyticsService.shared.track(.importRecipeFailed, properties: [
                "error_message": error.localizedDescription,
                "url": url
            ])
        }

        isLoading = false
    }
}
