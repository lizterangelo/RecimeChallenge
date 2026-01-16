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
                    .frame(width: 36, height: 36)
                    .foregroundStyle(AppColors.primary)
            }
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("ReciMe")
                    .font(AppFont.appTitleMain)
                Text("Challenge")
                    .font(AppFont.appTitleSub)
            }
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
