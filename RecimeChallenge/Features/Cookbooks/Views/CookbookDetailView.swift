import SwiftUI

struct CookbookDetailView: View {
    let cookbook: Cookbook
    @State private var selectedRecipe: Recipe?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                headerSection

                ForEach(cookbook.recipes) { recipe in
                    RecipeCard(recipe: recipe)
                        .onTapGesture {
                            selectedRecipe = recipe
                        }
                }
            }
            .padding()
        }
        .navigationTitle(cookbook.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedRecipe) { recipe in
            RecipeDetailView(recipe: recipe)
        }
    }

    private var headerSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(cookbook.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack {
                    Label("\(cookbook.recipeCount) recipes", systemImage: "book")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack {
        CookbookDetailView(cookbook: Cookbook(
            id: UUID(),
            name: "Italian Classics",
            description: "Traditional Italian recipes",
            recipes: [],
            coverImageURL: nil
        ))
    }
}
