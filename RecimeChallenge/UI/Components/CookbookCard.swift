import SwiftUI

struct CookbookCard: View {
    let cookbook: Cookbook

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "book.closed.fill")
                    .font(AppFont.largeTitle)
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
    CookbookCard(cookbook: Cookbook(
        id: UUID(),
        name: "Italian Classics",
        description: "Traditional Italian recipes",
        recipes: [],
        coverImageURL: nil
    ))
    .frame(width: 180)
    .padding()
}
