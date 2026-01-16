import SwiftUI

struct DietaryBadge: View {
    let attribute: DietaryAttribute

    var body: some View {
        Text(attribute.displayName)
            .font(AppFont.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }

    private var badgeColor: Color {
        switch attribute {
        case .vegetarian: return Color(red: 0.2, green: 0.5, blue: 0.3)
        case .vegan: return Color(red: 0.15, green: 0.45, blue: 0.25)
        case .glutenFree: return Color(red: 0.7, green: 0.4, blue: 0.1)
        case .dairyFree: return Color(red: 0.2, green: 0.4, blue: 0.6)
        case .nutFree: return Color(red: 0.45, green: 0.3, blue: 0.55)
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
