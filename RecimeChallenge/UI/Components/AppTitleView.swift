import SwiftUI

/// App title component displaying logo + "ReciMe Challenge"
/// Uses Recoleta Bold font with primary color (#FF7A01)
struct AppTitleView: View {
    var showIcon: Bool = true

    var body: some View {
        HStack(spacing: 8) {
            if showIcon {
                Image("AppLogo")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(AppColors.primary)
            }
            Text("ReciMe Challenge")
                .font(AppFont.appTitle)
                .foregroundStyle(AppColors.primary)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AppTitleView()
        AppTitleView(showIcon: false)
    }
}
