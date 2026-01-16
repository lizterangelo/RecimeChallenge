import SwiftUI

@Observable
class AppCoordinator {
    var currentView: AppView = .splash

    enum AppView {
        case splash
        case main
    }

    func switchToMain() {
        withAnimation {
            currentView = .main
        }
    }
}
