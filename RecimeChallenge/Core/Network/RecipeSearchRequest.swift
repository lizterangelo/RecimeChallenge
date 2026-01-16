import Foundation

struct RecipeSearchRequest: Sendable {
    var page: Int = 1
    var pageSize: Int = 20
    var searchQuery: String?
    var filters: RecipeFilters?

    static var `default`: RecipeSearchRequest {
        RecipeSearchRequest()
    }

    func with(page: Int) -> RecipeSearchRequest {
        var copy = self
        copy.page = page
        return copy
    }

    func with(searchQuery: String?) -> RecipeSearchRequest {
        var copy = self
        copy.searchQuery = searchQuery
        return copy
    }

    func with(filters: RecipeFilters?) -> RecipeSearchRequest {
        var copy = self
        copy.filters = filters
        return copy
    }
}
