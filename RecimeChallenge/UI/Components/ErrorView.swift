import SwiftUI

struct ErrorView: View {
    let message: String
    var retryAction: (() -> Void)?

    var body: some View {
        ContentUnavailableView {
            Label("Error", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            if let retryAction {
                Button("Try Again", action: retryAction)
                    .buttonStyle(.glassButton)
            }
        }
    }
}

#Preview("With Retry") {
    ErrorView(message: "Failed to load data") {
        print("Retry")
    }
}

#Preview("Without Retry") {
    ErrorView(message: "Something went wrong")
}
