import SwiftData
import SwiftUI

struct GroceriesView: View {
    // Using @Query from SwiftData for fetching grocery items
    @Query(sort: \GroceryItemModel.name) private var items: [GroceryItemModel]
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel = GroceriesViewModel()
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if items.isEmpty {
                        emptyState
                    } else {
                        groceryList
                    }
                }

                floatingAddButton
            }
            .navigationTitle("Groceries")
            .toolbar {
                if !items.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Button("Clear Checked") { viewModel.clearChecked(items) }
                            Button("Clear All", role: .destructive) { viewModel.clearAll(items) }
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
            .onAppear {
                viewModel.setContext(modelContext)
            }
        }
    }

    private var floatingAddButton: some View {
        Button {
            showingAddSheet = true
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(AppColors.primary)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
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
                let categoryItems = viewModel.groupedItems(items)[category] ?? []
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
        .modelContainer(for: GroceryItemModel.self, inMemory: true)
}
