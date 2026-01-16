import SwiftUI

struct DietaryBadge: View {
    let attribute: DietaryAttribute

    var body: some View {
        Text(attribute.displayName)
            .font(AppFont.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor.opacity(0.15))
            .foregroundStyle(backgroundColor)
            .clipShape(Capsule())
    }

    private var backgroundColor: Color {
        switch attribute {
        case .vegetarian: return .green
        case .vegan: return .green
        case .glutenFree: return .orange
        case .dairyFree: return .blue
        case .nutFree: return .purple
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        ForEach(DietaryAttribute.allCases) { attribute in
            DietaryBadge(attribute: attribute)
        }
    }
    .padding()
}
