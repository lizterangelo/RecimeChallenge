import SwiftUI

struct FilterButton: View {
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "line.3.horizontal.decrease.circle" + (isActive ? ".fill" : ""))
                    .font(AppFont.subheadline)
                Text("Filters")
                    .font(AppFont.caption)
            }
            .foregroundStyle(isActive ? AppColors.primary : .secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background {
                if isActive {
                    AppColors.primary.opacity(0.1)
                } else {
                    Color.clear.background(.ultraThinMaterial)
                }
            }
            .clipShape(Capsule())
        }
    }
}
