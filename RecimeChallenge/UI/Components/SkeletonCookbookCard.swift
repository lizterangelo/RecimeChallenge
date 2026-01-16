import SkeletonUI
import SwiftUI

struct SkeletonCookbookCard: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 0) {
                // Photo grid skeleton
                GeometryReader { geometry in
                    HStack(spacing: 2) {
                        Rectangle()
                            .skeleton(with: true, animation: .pulse(), shape: .rectangle)
                            .frame(width: geometry.size.width * 0.6)

                        VStack(spacing: 2) {
                            Rectangle()
                                .skeleton(with: true, animation: .pulse(), shape: .rectangle)
                            Rectangle()
                                .skeleton(with: true, animation: .pulse(), shape: .rectangle)
                        }
                        .frame(width: geometry.size.width * 0.4 - 2)
                    }
                }
                .frame(height: 100)
                .clipped()

                VStack(alignment: .leading, spacing: 8) {
                    // Title skeleton
                    Text("Cookbook Title")
                        .skeleton(with: true, animation: .pulse(), shape: .capsule)

                    // Description skeleton
                    Text("Description text here")
                        .skeleton(with: true, animation: .pulse(), shape: .capsule)

                    // Recipe count skeleton
                    HStack {
                        Text("10 recipes")
                            .skeleton(with: true, animation: .pulse(), shape: .capsule)
                        Spacer()
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
        SkeletonCookbookCard()
        SkeletonCookbookCard()
        SkeletonCookbookCard()
        SkeletonCookbookCard()
    }
    .padding()
}
