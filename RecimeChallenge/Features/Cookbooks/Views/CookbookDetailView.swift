import SwiftUI

struct CookbookDetailView: View {
    let cookbook: Cookbook
    @State private var selectedRecipeId: UUID?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 12)

                LazyVStack(spacing: 12) {
                    ForEach(cookbook.recipes) { recipe in
                        Button {
                            AnalyticsService.shared.track(.recipeOpened, properties: [
                                "recipe_id": recipe.id.uuidString,
                                "recipe_title": recipe.title,
                                "source": "cookbook_detail",
                                "cookbook_id": cookbook.id.uuidString
                            ])
                            selectedRecipeId = recipe.id
                        } label: {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle(cookbook.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedRecipeId) { recipeId in
            if let recipe = cookbook.recipes.first(where: { $0.id == recipeId }) {
                RecipeDetailView(recipe: recipe)
            }
        }
    }

    private var headerSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(cookbook.description)
                    .font(AppFont.subheadline)
                    .foregroundStyle(.secondary)

                HStack {
                    Label("\(cookbook.recipeCount) recipes", systemImage: "book")
                        .font(AppFont.caption)
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
