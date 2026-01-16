import AdvancedList
import SkeletonUI
import SwiftUI

struct RecipeSelectorView: View {
    @State private var viewModel = CookbooksViewModel()
    var onRecipeSelected: (Recipe) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            searchBar
                .padding(.vertical, 8)
            recipesList
        }
        .task {
            // Force recipes mode and load if empty
            viewModel.contentMode = .allRecipes
            if viewModel.recipes.isEmpty {
                await viewModel.loadInitialRecipes()
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Text("Select a recipe")
                .font(AppFont.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            if viewModel.recipesTotalCount > 0 {
                Text("Showing \(viewModel.recipes.count) of \(viewModel.recipesTotalCount) recipes")
                    .font(AppFont.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search recipes...", text: $viewModel.searchText)
                .font(AppFont.body)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    // MARK: - Recipes List with AdvancedList

    private var recipesList: some View {
        AdvancedList(viewModel.recipes, listView: { rows in
            ScrollView {
                LazyVStack(spacing: 12) {
                    rows()
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .scrollDismissesKeyboard(.interactively)
        }, content: { recipe in
            RecipeCard(recipe: recipe)
                .onTapGesture {
                    if let correctRecipe = viewModel.recipes.first(where: { $0.id == recipe.id }) {
                        onRecipeSelected(correctRecipe)
                    }
                }
        }, listState: viewModel.listState, emptyStateView: {
            ContentUnavailableView {
                Label(emptyTitle, systemImage: "fork.knife")
            } description: {
                Text(emptyDescription)
            }
            .padding(.top, 40)
        }, errorStateView: { error in
            ErrorView(message: error.localizedDescription) {
                Task { await viewModel.refresh() }
            }
            .padding(.top, 40)
        }, loadingStateView: {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { _ in
                        SkeletonRecipeCard()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
        })
        .pagination(.init(type: .thresholdItem(offset: 5), shouldLoadNextPage: {
            Task { await viewModel.loadNextPage() }
        }) {
            EmptyView()
        })
    }

    // MARK: - Empty State Helpers

    private var emptyTitle: String {
        viewModel.searchText.isEmpty ? "No Recipes" : "No Results"
    }

    private var emptyDescription: String {
        viewModel.searchText.isEmpty
            ? "No recipes available"
            : "Try adjusting your search"
    }
}

#Preview {
    NavigationStack {
        RecipeSelectorView { recipe in
            print("Selected: \(recipe.title)")
        }
        .navigationTitle("Select Recipe")
    }
}
