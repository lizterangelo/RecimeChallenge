import SwiftUI

/// App title component displaying logo + "ReciMe Challenge"
/// Uses Recoleta Bold font with primary color (#FF7A01)
struct AppTitleView: View {
    var showIcon: Bool = true

    var body: some View {
        HStack(spacing: 4) {
            if showIcon {
                Image("AppLogo")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
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
