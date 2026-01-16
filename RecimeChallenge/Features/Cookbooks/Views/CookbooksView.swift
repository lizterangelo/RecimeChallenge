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
                        Task { await viewModel.loadCookbooks() }
                    }
                } else {
                    cookbookGrid
                }
            }
            .navigationTitle("Cookbooks")
            .navigationDestination(item: $selectedCookbook) { cookbook in
                CookbookDetailView(cookbook: cookbook)
            }
            .task {
                if viewModel.cookbooks.isEmpty {
                    await viewModel.loadCookbooks()
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
                }
            }
            .padding()
        }
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
