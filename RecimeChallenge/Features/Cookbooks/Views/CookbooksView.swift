import SwiftUI

struct CookbooksView: View {
    @State private var viewModel = CookbooksViewModel()
    @State private var selectedCookbook: Cookbook?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // App Title Header
                    headerView

                    // Content
                    if viewModel.isLoading && viewModel.cookbooks.isEmpty {
                        LoadingView(message: "Loading cookbooks...")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    } else if let error = viewModel.error, viewModel.cookbooks.isEmpty {
                        ErrorView(message: error.localizedDescription) {
                            Task { await viewModel.loadInitialCookbooks() }
                        }
                        .padding(.top, 40)
                    } else {
                        cookbookGrid
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.totalCount > 0 {
                        Text("\(viewModel.cookbooks.count)/\(viewModel.totalCount)")
                            .font(AppFont.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationDestination(item: $selectedCookbook) { cookbook in
                CookbookDetailView(cookbook: cookbook)
            }
            .task {
                if viewModel.cookbooks.isEmpty {
                    await viewModel.loadInitialCookbooks()
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            AppTitleView()

            Text("Discover delicious recipes")
                .font(AppFont.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var cookbookGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(viewModel.cookbooks) { cookbook in
                CookbookCard(cookbook: cookbook)
                    .onTapGesture {
                        selectedCookbook = cookbook
                    }
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded(currentItem: cookbook)
                        }
                    }
            }

            if viewModel.isLoadingMore {
                loadingFooter
            }
        }
        .padding(.horizontal)
    }

    private var loadingFooter: some View {
        HStack {
            Spacer()
            ProgressView()
                .padding()
            Spacer()
        }
        .gridCellColumns(2)
    }
}

struct CookbookCard: View {
    let cookbook: Cookbook

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "book.closed.fill")
                    .font(.largeTitle)
                    .foregroundStyle(AppColors.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)

                Text(cookbook.name)
                    .font(AppFont.headline)
                    .lineLimit(1)

                Text(cookbook.description)
                    .font(AppFont.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text("\(cookbook.recipeCount) recipes")
                    .font(AppFont.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
    }
}

#Preview {
    CookbooksView()
}
