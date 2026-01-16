import SwiftUI

struct SideMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}

struct SideMenuView: View {
    @Binding var isOpen: Bool
    let menuItems: [SideMenuItem]
    var onItemTap: ((SideMenuItem) -> Void)?

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
                                onItemTap?(item)
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
                            .foregroundStyle(.primary)
                            Divider()
                        }
                        Spacer()
                    }
                    .frame(width: 280)
                    .background(.regularMaterial)
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
            SideMenuItem(title: "Profile", icon: "person.circle"),
            SideMenuItem(title: "Settings", icon: "gearshape"),
            SideMenuItem(title: "About", icon: "info.circle")
        ]
    )
}
