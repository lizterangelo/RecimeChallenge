import SwiftUI

struct ImportRecipeView: View {
    @State private var viewModel = ImportRecipeViewModel()
    @State private var showingImportedRecipe = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                RecipeWebView(viewModel: viewModel)
                    .ignoresSafeArea(edges: .bottom)

                importButton
            }
            .navigationTitle("Import Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    navigationButtons
                }

                ToolbarItem(placement: .topBarTrailing) {
                    refreshButton
                }
            }
            .fullScreenCover(isPresented: $showingImportedRecipe) {
                if let recipe = viewModel.importedRecipe {
                    ImportedRecipeDetailView(recipe: recipe)
                }
            }
            .onChange(of: viewModel.importedRecipe) { _, newValue in
                if newValue != nil {
                    showingImportedRecipe = true
                }
            }
            .alert("Import Error", isPresented: .init(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }

    private var navigationButtons: some View {
        HStack(spacing: 16) {
            Button {
                viewModel.webView?.goBack()
            } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(!(viewModel.webView?.canGoBack ?? false))

            Button {
                viewModel.webView?.goForward()
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(!(viewModel.webView?.canGoForward ?? false))
        }
    }

    private var refreshButton: some View {
        Button {
            viewModel.webView?.reload()
        } label: {
            Image(systemName: "arrow.clockwise")
        }
    }

    private var importButton: some View {
        Button {
            Task {
                await viewModel.importRecipe()
            }
        } label: {
            HStack(spacing: 8) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "square.and.arrow.down")
                }
                Text(viewModel.isLoading ? "Importing..." : "Import Recipe")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
        }
        .disabled(viewModel.isLoading || viewModel.currentURL == nil)
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

#Preview {
    ImportRecipeView()
}
