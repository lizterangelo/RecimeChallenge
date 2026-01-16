import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Cookbooks", systemImage: "book.closed", value: 0) {
                CookbooksView()
            }

            Tab("Meal Plan", systemImage: "calendar", value: 1) {
                MealPlanView()
            }

            Tab("Add", systemImage: "plus.circle.fill", value: 2) {
                AddRecipeView()
            }

            Tab("Groceries", systemImage: "cart", value: 3) {
                GroceriesView()
            }

            Tab("More", systemImage: "ellipsis.circle", value: 4) {
                MoreView()
            }
        }
        .tint(.primary)
    }
}

#Preview {
    MainTabView()
}
