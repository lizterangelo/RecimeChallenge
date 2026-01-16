import Foundation

@Observable
final class CookbooksViewModel {
    private let apiClient: APIClientProtocol

    private(set) var cookbooks: [Cookbook] = []
    private(set) var isLoading = false
    private(set) var error: APIError?

    init(apiClient: APIClientProtocol = MockAPIClient()) {
        self.apiClient = apiClient
    }

    func loadCookbooks() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            cookbooks = try await apiClient.fetchCookbooks()
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .networkError(error)
        }

        isLoading = false
    }

    func refresh() async {
        await loadCookbooks()
    }
}
