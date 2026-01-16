import Foundation
import AdvancedList

@Observable
final class CookbooksViewModel {
    private let apiClient: APIClientProtocol
    private let pageSize = 20
    private let searchDebounceDelay: Duration = .milliseconds(300)

    // MARK: - Mode State

    var contentMode: ContentMode = .allRecipes {
        didSet {
            if oldValue != contentMode {
                Task { await handleModeChange() }
            }
        }
    }

    // MARK: - Search State

    var searchText: String = "" {
        didSet {
            if oldValue != searchText {
                handleSearchTextChange()
            }
        }
    }
    private var searchTask: Task<Void, Never>?

    var recipeFilters: RecipeFilters = .empty {
        didSet {
            if oldValue != recipeFilters {
                Task { await handleFilterChange() }
            }
        }
    }

    // MARK: - List State (AdvancedList)

    private(set) var listState: ListState = .items

    // MARK: - Pagination State (AdvancedList)

    private(set) var paginationState: AdvancedListPaginationState = .idle

    // MARK: - Cookbooks State

    private(set) var cookbooks: [Cookbook] = []
    private(set) var cookbooksTotalCount = 0
    private var cookbooksCurrentPage = 0
    private var cookbooksHasMorePages = true

    // MARK: - Recipes State

    private(set) var recipes: [Recipe] = []
    private(set) var recipesTotalCount = 0
    private var recipesCurrentPage = 0
    private var recipesHasMorePages = true

    // MARK: - Computed Properties

    var isEmpty: Bool {
        switch contentMode {
        case .cookbooks: return cookbooks.isEmpty
        case .allRecipes: return recipes.isEmpty
        }
    }

    var currentTotalCount: Int {
        switch contentMode {
        case .cookbooks: return cookbooksTotalCount
        case .allRecipes: return recipesTotalCount
        }
    }

    var currentDisplayedCount: Int {
        switch contentMode {
        case .cookbooks: return cookbooks.count
        case .allRecipes: return recipes.count
        }
    }

    var hasMorePages: Bool {
        switch contentMode {
        case .cookbooks: return cookbooksHasMorePages
        case .allRecipes: return recipesHasMorePages
        }
    }

    // MARK: - Init

    init(apiClient: APIClientProtocol = MockAPIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - Search Debouncing

    private func handleSearchTextChange() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(for: searchDebounceDelay)
            guard !Task.isCancelled else { return }
            await performSearch()
        }
    }

    private func performSearch() async {
        // Track search if there's a query
        if !searchText.isEmpty {
            AnalyticsService.shared.track(.searchPerformed, properties: [
                "query": searchText,
                "content_mode": contentMode.rawValue
            ])
        }

        switch contentMode {
        case .cookbooks:
            cookbooksCurrentPage = 0
            cookbooksHasMorePages = true
            await loadInitialCookbooks()
        case .allRecipes:
            recipesCurrentPage = 0
            recipesHasMorePages = true
            await loadInitialRecipes()
        }
    }

    // MARK: - Mode Handling

    private func handleModeChange() async {
        switch contentMode {
        case .cookbooks:
            if cookbooks.isEmpty {
                await loadInitialCookbooks()
            }
        case .allRecipes:
            if recipes.isEmpty {
                await loadInitialRecipes()
            }
        }
    }

    private func handleFilterChange() async {
        guard contentMode == .allRecipes else { return }

        // Track filter usage if filters are active
        if recipeFilters.isActive {
            AnalyticsService.shared.track(.filtersApplied, properties: [
                "is_vegetarian": recipeFilters.isVegetarian ?? false,
                "servings": recipeFilters.servings ?? 0,
                "included_ingredients_count": recipeFilters.includedIngredients.count,
                "excluded_ingredients_count": recipeFilters.excludedIngredients.count,
                "has_instruction_search": recipeFilters.searchInInstructions != nil
            ])
        }

        recipesCurrentPage = 0
        recipesHasMorePages = true
        await loadInitialRecipes()
    }

    // MARK: - Cookbook Loading

    func loadInitialCookbooks() async {
        guard listState != .loading else { return }

        listState = .loading
        paginationState = .idle
        cookbooksCurrentPage = 1

        do {
            let response: PaginatedResponse<Cookbook>
            if searchText.isEmpty {
                response = try await apiClient.fetchCookbooks(page: 1, pageSize: pageSize)
            } else {
                response = try await apiClient.searchCookbooks(query: searchText, page: 1, pageSize: pageSize)
            }
            cookbooks = response.items
            cookbooksHasMorePages = response.hasNextPage
            cookbooksTotalCount = response.totalCount
            listState = .items
        } catch is CancellationError {
            listState = .items
        } catch {
            listState = .error(error as NSError)
        }
    }

    // MARK: - Load Next Page (called by AdvancedList pagination)

    func loadNextPage() async {
        guard paginationState == .idle, hasMorePages else { return }

        switch contentMode {
        case .cookbooks:
            await loadMoreCookbooks()
        case .allRecipes:
            await loadMoreRecipes()
        }
    }

    private func loadMoreCookbooks() async {
        guard paginationState == .idle, cookbooksHasMorePages else { return }

        paginationState = .loading
        let nextPage = cookbooksCurrentPage + 1

        do {
            let response: PaginatedResponse<Cookbook>
            if searchText.isEmpty {
                response = try await apiClient.fetchCookbooks(page: nextPage, pageSize: pageSize)
            } else {
                response = try await apiClient.searchCookbooks(query: searchText, page: nextPage, pageSize: pageSize)
            }
            cookbooks.append(contentsOf: response.items)
            cookbooksCurrentPage = nextPage
            cookbooksHasMorePages = response.hasNextPage
            paginationState = .idle
        } catch {
            paginationState = .error(error as NSError)
        }
    }

    // MARK: - Recipe Loading

    func loadInitialRecipes() async {
        guard listState != .loading else { return }

        listState = .loading
        paginationState = .idle
        recipesCurrentPage = 1

        do {
            let request = RecipeSearchRequest(
                page: 1,
                pageSize: pageSize,
                searchQuery: searchText.isEmpty ? nil : searchText,
                filters: recipeFilters.isActive ? recipeFilters : nil
            )
            let response = try await apiClient.fetchRecipes(request)
            recipes = response.items
            recipesHasMorePages = response.hasNextPage
            recipesTotalCount = response.totalCount
            listState = .items
        } catch is CancellationError {
            listState = .items
        } catch {
            listState = .error(error as NSError)
        }
    }

    private func loadMoreRecipes() async {
        guard paginationState == .idle, recipesHasMorePages else { return }

        paginationState = .loading
        let nextPage = recipesCurrentPage + 1

        do {
            let request = RecipeSearchRequest(
                page: nextPage,
                pageSize: pageSize,
                searchQuery: searchText.isEmpty ? nil : searchText,
                filters: recipeFilters.isActive ? recipeFilters : nil
            )
            let response = try await apiClient.fetchRecipes(request)
            recipes.append(contentsOf: response.items)
            recipesCurrentPage = nextPage
            recipesHasMorePages = response.hasNextPage
            paginationState = .idle
        } catch {
            paginationState = .error(error as NSError)
        }
    }

    // MARK: - Refresh

    func refresh() async {
        searchTask?.cancel()
        paginationState = .idle

        switch contentMode {
        case .cookbooks:
            cookbooksCurrentPage = 0
            cookbooksHasMorePages = true
        case .allRecipes:
            recipesCurrentPage = 0
            recipesHasMorePages = true
        }

        await performSearch()
    }
}
