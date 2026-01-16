import SwiftUI

struct SplashScreenView: View {
    @State private var logoOffset: CGFloat = 0
    @State private var logoRotation: Double = 0
    @State private var textOpacity: Double = 0

    private let textWidth: CGFloat = 150

    var body: some View {
        ZStack {
            AppColors.primary
                .ignoresSafeArea()

            HStack(spacing: 8) {
                Image("SplashLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(logoRotation), anchor: .bottom)
                    .offset(x: logoOffset)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("ReciMe")
                        .font(AppFont.splashTitleMain)
                    Text("Challenge")
                        .font(AppFont.splashTitleSub)
                }
                .foregroundStyle(.white)
                .opacity(textOpacity)
            }
        }
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        // Start with logo offset to center
        logoOffset = textWidth / 2

        // Wave sequence: 0 -> 12 -> -12 -> 10 -> -10 -> 8 -> 0 (damped wave)
        let waveDuration = 0.12

        // Wave 1: right
        withAnimation(.easeOut(duration: waveDuration)) {
            logoRotation = 12
        }

        // Wave 1: left
        DispatchQueue.main.asyncAfter(deadline: .now() + waveDuration) {
            withAnimation(.easeInOut(duration: waveDuration)) {
                logoRotation = -12
            }
        }

        // Wave 2: right (smaller)
        DispatchQueue.main.asyncAfter(deadline: .now() + waveDuration * 2) {
            withAnimation(.easeInOut(duration: waveDuration)) {
                logoRotation = 10
            }
        }

        // Wave 2: left (smaller)
        DispatchQueue.main.asyncAfter(deadline: .now() + waveDuration * 3) {
            withAnimation(.easeInOut(duration: waveDuration)) {
                logoRotation = -10
            }
        }

        // Wave 3: right (even smaller)
        DispatchQueue.main.asyncAfter(deadline: .now() + waveDuration * 4) {
            withAnimation(.easeInOut(duration: waveDuration)) {
                logoRotation = 8
            }
        }

        // Wave 3: settle back to 0
        DispatchQueue.main.asyncAfter(deadline: .now() + waveDuration * 5) {
            withAnimation(.easeOut(duration: waveDuration * 1.5)) {
                logoRotation = 0
            }
        }

        // After waving completes, slide logo left (no rotation during slide)
        DispatchQueue.main.asyncAfter(deadline: .now() + waveDuration * 6.5) {
            withAnimation(.easeOut(duration: 0.4)) {
                logoOffset = 0
            }

            // Fade in text
            withAnimation(.easeIn(duration: 0.4).delay(0.2)) {
                textOpacity = 1
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
