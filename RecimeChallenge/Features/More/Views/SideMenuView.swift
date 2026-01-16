import SwiftUI

struct SideMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let url: URL
}

struct SideMenuView: View {
    @Environment(\.openURL) private var openURL
    @Binding var isOpen: Bool
    let menuItems: [SideMenuItem]

    var body: some View {
        ZStack {
            if isOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { isOpen = false }
            }

            HStack {
                Spacer()
                if isOpen {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(menuItems) { item in
                            Button {
                                openURL(item.url)
                                isOpen = false
                            } label: {
                                HStack(spacing: 16) {
                                    Image(systemName: item.icon)
                                        .frame(width: 24)
                                    Text(item.title)
                                    Spacer()
                                }
                                .padding()
                            }
                            .foregroundStyle(.white)
                            Divider()
                                .background(.white.opacity(0.3))
                        }
                        Spacer()
                    }
                    .frame(width: 280)
                    .background(AppColors.primary)
                    .transition(.move(edge: .trailing))
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isOpen)
    }
}

#Preview {
    SideMenuView(
        isOpen: .constant(true),
        menuItems: [
            SideMenuItem(title: "Help & Support", icon: "questionmark.circle", url: URL(string: "https://recime.app/help/en")!),
            SideMenuItem(title: "Privacy Policy", icon: "hand.raised", url: URL(string: "https://recime.app/privacy-policy")!),
            SideMenuItem(title: "Terms of Service", icon: "doc.text", url: URL(string: "https://recime.app/terms-and-conditions")!)
        ]
    )
}
