import SwiftUI

struct CookbooksView: View {
    @State private var viewModel = CookbooksViewModel()
    @State private var selectedCookbook: Cookbook?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.cookbooks.isEmpty {
                    LoadingView(message: "Loading cookbooks...")
                } else if let error = viewModel.error, viewModel.cookbooks.isEmpty {
                    ErrorView(message: error.localizedDescription) {
                        Task { await viewModel.loadInitialCookbooks() }
                    }
                } else {
                    cookbookGrid
                }
            }
            .navigationTitle("Cookbooks")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.totalCount > 0 {
                        Text("\(viewModel.cookbooks.count)/\(viewModel.totalCount)")
                            .font(.caption)
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

    private var cookbookGrid: some View {
        ScrollView {
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
            .padding()
        }
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
                    .foregroundStyle(Color.accentColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)

                Text(cookbook.name)
                    .font(.headline)
                    .lineLimit(1)

                Text(cookbook.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text("\(cookbook.recipeCount) recipes")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
    }
}

#Preview {
    CookbooksView()
}
