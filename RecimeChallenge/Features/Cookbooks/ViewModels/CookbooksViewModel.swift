import Foundation

@Observable
final class CookbooksViewModel {
    private let apiClient: APIClientProtocol
    private let pageSize = 20

    private(set) var cookbooks: [Cookbook] = []
    private(set) var isLoading = false
    private(set) var isLoadingMore = false
    private(set) var error: APIError?
    private(set) var hasMorePages = true
    private(set) var totalCount = 0

    private var currentPage = 0

    init(apiClient: APIClientProtocol = MockAPIClient()) {
        self.apiClient = apiClient
    }

    func loadInitialCookbooks() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil
        currentPage = 1

        do {
            let response = try await apiClient.fetchCookbooks(page: 1, pageSize: pageSize)
            cookbooks = response.items
            hasMorePages = response.hasNextPage
            totalCount = response.totalCount
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .networkError(error)
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentItem: Cookbook) async {
        guard !isLoadingMore,
              hasMorePages,
              let index = cookbooks.firstIndex(where: { $0.id == currentItem.id }),
              index >= cookbooks.count - 5 else { return }

        await loadMore()
    }

    func loadMore() async {
        guard !isLoadingMore, hasMorePages else { return }

        isLoadingMore = true
        let nextPage = currentPage + 1

        do {
            let response = try await apiClient.fetchCookbooks(page: nextPage, pageSize: pageSize)
            cookbooks.append(contentsOf: response.items)
            currentPage = nextPage
            hasMorePages = response.hasNextPage
        } catch {
            // Silently fail for pagination errors
        }

        isLoadingMore = false
    }

    func refresh() async {
        cookbooks = []
        currentPage = 0
        hasMorePages = true
        isLoadingMore = false
        error = nil
        await loadInitialCookbooks()
    }
}
