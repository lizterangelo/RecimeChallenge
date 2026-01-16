import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var previousTab = 0
    @State private var showSideMenu = false

    private let menuItems = [
        SideMenuItem(title: "Profile", icon: "person.circle"),
        SideMenuItem(title: "Settings", icon: "gearshape"),
        SideMenuItem(title: "About", icon: "info.circle")
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

            SideMenuView(
                isOpen: $showSideMenu,
                menuItems: menuItems
            )
        }
    }
}

#Preview {
    MainTabView()
}
