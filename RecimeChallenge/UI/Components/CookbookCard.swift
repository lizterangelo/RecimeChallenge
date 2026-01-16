import SwiftUI

struct CookbookCard: View {
    let cookbook: Cookbook

    private var recipeImages: [String] {
        cookbook.recipes
            .compactMap { $0.imageURL }
            .prefix(3)
            .map { $0 }
    }

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 0) {
                if recipeImages.count >= 3 {
                    photoGrid
                } else {
                    placeholderImage
                        .padding(.horizontal)
                        .padding(.top)
                }

                VStack(alignment: .leading, spacing: 4) {
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

    private var photoGrid: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let rightWidth: CGFloat = 50
            let leftWidth = totalWidth - rightWidth - 2

            HStack(spacing: 2) {
                Image(recipeImages[0])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: leftWidth, height: 100)
                    .clipped()

                VStack(spacing: 2) {
                    Image(recipeImages[1])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: rightWidth, height: 49)
                        .clipped()

                    Image(recipeImages[2])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: rightWidth, height: 49)
                        .clipped()
                }
            }
        }
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var placeholderImage: some View {
        Image(systemName: "book.closed.fill")
            .font(AppFont.largeTitle)
            .foregroundStyle(AppColors.primary)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 100)
    }
}

#Preview("With Photos") {
    CookbookCard(cookbook: Cookbook(
        id: UUID(),
        name: "Italian Classics",
        description: "Traditional Italian recipes",
        recipes: [
            Recipe(id: UUID(), title: "Recipe 1", description: "", servings: 4, ingredients: [], instructions: [], dietaryAttributes: [], imageURL: "recipe-photo-1", preparationTime: nil, cookingTime: nil),
            Recipe(id: UUID(), title: "Recipe 2", description: "", servings: 4, ingredients: [], instructions: [], dietaryAttributes: [], imageURL: "recipe-photo-2", preparationTime: nil, cookingTime: nil),
            Recipe(id: UUID(), title: "Recipe 3", description: "", servings: 4, ingredients: [], instructions: [], dietaryAttributes: [], imageURL: "recipe-photo-3", preparationTime: nil, cookingTime: nil)
        ],
        coverImageURL: nil
    ))
    .frame(width: 180)
    .padding()
}

#Preview("Without Photos") {
    CookbookCard(cookbook: Cookbook(
        id: UUID(),
        name: "Quick & Easy",
        description: "Simple recipes for busy days",
        recipes: [],
        coverImageURL: nil
    ))
    .frame(width: 180)
    .padding()
}
