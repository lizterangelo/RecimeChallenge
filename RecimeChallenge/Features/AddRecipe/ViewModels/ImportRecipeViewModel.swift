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

        do {
            let recipe = try await RecipeImportService.shared.importRecipe(from: url)
            importedRecipe = recipe
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
