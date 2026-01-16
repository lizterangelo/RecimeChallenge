import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var previousTab = 0
    @State private var showSideMenu = false

    private let menuItems = [
        SideMenuItem(title: "Help & Support", icon: "questionmark.circle", url: URL(string: "https://recime.app/help/en")!),
        SideMenuItem(title: "Privacy Policy", icon: "hand.raised", url: URL(string: "https://recime.app/privacy-policy")!),
        SideMenuItem(title: "Terms of Service", icon: "doc.text", url: URL(string: "https://recime.app/terms-and-conditions")!)
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

                Tab("Import", systemImage: "square.and.arrow.down", value: 2) {
                    ImportRecipeView()
                }

                Tab("Groceries", systemImage: "cart", value: 3) {
                    GroceriesView()
                }

                Tab("More", systemImage: "ellipsis.circle", value: 4) {
                    Color.clear
                }
            }
            .tint(AppColors.primary)
            .onChange(of: selectedTab) { oldValue, newValue in
                if newValue == 4 {
                    showSideMenu = true
                    selectedTab = previousTab
                } else {
                    previousTab = newValue
                    // Track tab selection
                    let tabNames = ["Cookbooks", "Meal Plan", "Import", "Groceries"]
                    if newValue < tabNames.count {
                        AnalyticsService.shared.track(.tabSelected, properties: ["tab_name": tabNames[newValue]])
                    }
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
