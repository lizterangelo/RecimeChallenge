import SwiftUI

struct AppCoordinatorView: View {
    var coordinator: AppCoordinator

    var body: some View {
        switch coordinator.currentView {
        case .splash:
            SplashScreenView(coordinator: coordinator)
        case .main:
            MainTabView()
        }
    }
}
