import SwiftUI

struct SplashScreenView: View {
    var coordinator: AppCoordinator
    @State private var opacity: Double = 0
    @State private var logoRotation: Double = 15

    var body: some View {
        ZStack {
            AppColors.primary
                .ignoresSafeArea()

            HStack(spacing: 4) {
                Image("SplashLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(logoRotation), anchor: .bottom)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("ReciMe")
                        .font(AppFont.splashTitleMain)
                    Text("Challenge")
                        .font(AppFont.splashTitleSub)
                }
                .foregroundStyle(.white)
            }
            .opacity(opacity)
        }
        .onAppear {
            // Fade in
            withAnimation(.easeIn(duration: 0.5)) {
                opacity = 1.0
            }

            // Wave animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.4, blendDuration: 0)) {
                    logoRotation = 0
                }
            }

            // Transition to main
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                coordinator.switchToMain()
            }
        }
    }
}

#Preview {
    SplashScreenView(coordinator: AppCoordinator())
}
