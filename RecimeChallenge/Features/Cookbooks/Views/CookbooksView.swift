import SwiftUI
import AdvancedList

struct CookbooksView: View {
    @State private var viewModel = CookbooksViewModel()
    @State private var selectedCookbook: Cookbook?
    @State private var selectedRecipe: Recipe?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                headerView
                searchBar
                    .padding(.vertical, 8)
                contentView
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .navigationDestination(item: $selectedCookbook) { cookbook in
                CookbookDetailView(cookbook: cookbook)
            }
            .navigationDestination(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .task {
                if viewModel.isEmpty {
                    await viewModel.loadInitialCookbooks()
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }

    // MARK: - Header with Dropdown

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                AppTitleView()
                Spacer()
                filterDropdown
            }

            HStack {
                Text(subtitleText)
                    .font(AppFont.subheadline)
                    .foregroundStyle(.secondary)

                if viewModel.currentTotalCount > 0 {
                    Text("(\(viewModel.currentDisplayedCount)/\(viewModel.currentTotalCount))")
                        .font(AppFont.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }

    private var subtitleText: String {
        switch viewModel.contentMode {
        case .cookbooks:
            return "Browse your delicious recipes"
        case .allRecipes:
            return "Browse your recipes"
        }
    }

    private var filterDropdown: some View {
        Menu {
            ForEach(ContentMode.allCases) { mode in
                Button {
                    viewModel.contentMode = mode
                } label: {
                    HStack {
                        Text(mode.rawValue)
                        if viewModel.contentMode == mode {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(viewModel.contentMode.rawValue)
                    .font(AppFont.subheadline)
                Image(systemName: "chevron.down")
                    .font(AppFont.caption)
            }
            .foregroundStyle(AppColors.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(searchPlaceholder, text: $viewModel.searchText)
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

    private var searchPlaceholder: String {
        switch viewModel.contentMode {
        case .cookbooks:
            return "Search cookbooks..."
        case .allRecipes:
            return "Search recipes..."
        }
    }

    // MARK: - Content Switching

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.contentMode {
        case .cookbooks:
            cookbooksList
        case .allRecipes:
            recipesList
        }
    }

    // MARK: - Cookbooks List with AdvancedList

    private var cookbooksList: some View {
        AdvancedList(viewModel.cookbooks, listView: { rows in
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    rows()
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .scrollDismissesKeyboard(.interactively)
        }, content: { cookbook in
            CookbookCard(cookbook: cookbook)
                .onTapGesture {
                    selectedCookbook = cookbook
                }
        }, listState: viewModel.listState, emptyStateView: {
            ContentUnavailableView {
                Label(emptyTitle, systemImage: "book.closed")
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
            LoadingView(message: "Loading cookbooks...")
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
        })
        .pagination(.init(type: .thresholdItem(offset: 5), shouldLoadNextPage: {
            Task { await viewModel.loadNextPage() }
        }) {
            paginationFooter
        })
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
                    selectedRecipe = recipe
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
            LoadingView(message: "Loading recipes...")
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
        })
        .pagination(.init(type: .thresholdItem(offset: 5), shouldLoadNextPage: {
            Task { await viewModel.loadNextPage() }
        }) {
            paginationFooter
        })
    }

    // MARK: - Pagination Footer

    private var paginationFooter: some View {
        EmptyView()
    }

    // MARK: - Empty State Helpers

    private var emptyTitle: String {
        viewModel.searchText.isEmpty ? "No Content" : "No Results"
    }

    private var emptyDescription: String {
        if viewModel.searchText.isEmpty {
            return viewModel.contentMode == .cookbooks
                ? "No cookbooks available"
                : "No recipes available"
        } else {
            return "Try adjusting your search"
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            EmptyView()
        }
    }
}

#Preview {
    CookbooksView()
}
