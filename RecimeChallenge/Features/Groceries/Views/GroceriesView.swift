import SwiftUI

struct GroceriesView: View {
    @State private var viewModel = GroceriesViewModel()
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.items.isEmpty {
                    emptyState
                } else {
                    groceryList
                }
            }
            .navigationTitle("Groceries")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                if !viewModel.items.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Button("Clear Checked", action: viewModel.clearChecked)
                            Button("Clear All", role: .destructive, action: viewModel.clearAll)
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddGrocerySheet { name, quantity, category in
                    viewModel.addItem(name: name, quantity: quantity, category: category)
                }
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Groceries", systemImage: "cart")
        } description: {
            Text("Add items to your shopping list")
        } actions: {
            Button {
                showingAddSheet = true
            } label: {
                Text("Add Item")
            }
            .buttonStyle(.glassButton)
        }
    }

    private var groceryList: some View {
        List {
            ForEach(GroceryCategory.allCases) { category in
                let categoryItems = viewModel.groupedItems[category] ?? []
                if !categoryItems.isEmpty {
                    Section {
                        ForEach(categoryItems) { item in
                            GroceryItemRow(
                                item: item,
                                onToggle: { viewModel.toggleItem(item) },
                                onDelete: { viewModel.removeItem(item) }
                            )
                        }
                    } header: {
                        Label(category.displayName, systemImage: category.iconName)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

#Preview {
    GroceriesView()
}
