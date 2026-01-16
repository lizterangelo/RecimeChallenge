import Foundation
import Mixpanel

enum AnalyticsEvent: String {
    // Recipe Import
    case importRecipeTapped = "import_recipe_tapped"
    case importRecipeSuccess = "import_recipe_success"
    case importRecipeFailed = "import_recipe_failed"

    // Navigation
    case tabSelected = "tab_selected"
    case cookbookOpened = "cookbook_opened"
    case recipeOpened = "recipe_opened"

    // Search
    case searchPerformed = "search_performed"

    // Filters
    case filtersOpened = "filters_opened"
    case filtersApplied = "filters_applied"

    // Groceries
    case groceryItemAdded = "grocery_item_added"
    case groceryItemToggled = "grocery_item_toggled"
    case groceryListCleared = "grocery_list_cleared"

    // Side Menu
    case menuLinkTapped = "menu_link_tapped"
}

final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    func initialize(token: String) {
        Mixpanel.initialize(token: token, trackAutomaticEvents: false)
        #if DEBUG
        Mixpanel.mainInstance().loggingEnabled = true
        #endif
    }

    func track(_ event: AnalyticsEvent, properties: [String: MixpanelType]? = nil) {
        Mixpanel.mainInstance().track(event: event.rawValue, properties: properties)
    }
}
