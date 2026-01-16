import SwiftUI
import SSSwiftUISideMenu

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var previousTab = 0
    @State private var showSideMenu = false
    @State private var selectedMenuIndex = 0

    private let menuItems = [
        MenuItem(title: "Profile", icon: "person.circle"),
        MenuItem(title: "Preferences", icon: "gearshape"),
        MenuItem(title: "Notifications", icon: "bell"),
        MenuItem(title: "Appearance", icon: "paintbrush"),
        MenuItem(title: "About", icon: "info.circle"),
        MenuItem(title: "Help & Support", icon: "questionmark.circle"),
        MenuItem(title: "Privacy Policy", icon: "hand.raised"),
        MenuItem(title: "Terms of Service", icon: "doc.text")
    ]

    var body: some View {
        ZStack {
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
                    Color.clear
                }
            }
            .tint(.primary)
            .onChange(of: selectedTab) { oldValue, newValue in
                if newValue == 4 {
                    showSideMenu = true
                    selectedTab = previousTab
                } else {
                    previousTab = newValue
                }
            }

            SSSwiftUISideMenu(
                openSideMenu: $showSideMenu,
                selectedIndex: $selectedMenuIndex,
                menuItems: menuItems,
                menuConfig: SSMenuConfig(
                    menuDirection: .right,
                    backgroundColor: .systemBackground,
                    titleColor: .primary
                )
            )
        }
    }
}

#Preview {
    MainTabView()
}
