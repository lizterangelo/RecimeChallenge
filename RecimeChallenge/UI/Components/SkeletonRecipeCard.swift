import SkeletonUI
import SwiftUI

struct SkeletonRecipeCard: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 0) {
                // Image skeleton
                Rectangle()
                    .skeleton(with: true, animation: .pulse(), shape: .rectangle)
                    .frame(height: 120)

                VStack(alignment: .leading, spacing: 12) {
                    // Title and time row
                    HStack {
                        Text("Recipe Title Here")
                            .skeleton(with: true, animation: .pulse(), shape: .capsule)

                        Spacer()

                        Text("30 min")
                            .skeleton(with: true, animation: .pulse(), shape: .capsule)
                    }

                    // Description skeleton
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description line one goes here")
                            .skeleton(with: true, animation: .pulse(), shape: .capsule)
                        Text("Description line two")
                            .skeleton(with: true, animation: .pulse(), shape: .capsule)
                    }

                    // Bottom row skeleton
                    HStack(spacing: 12) {
                        Text("4 servings")
                            .skeleton(with: true, animation: .pulse(), shape: .capsule)

                        Text("Vegan")
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
    VStack(spacing: 12) {
        SkeletonRecipeCard()
        SkeletonRecipeCard()
        SkeletonRecipeCard()
    }
    .padding()
}
