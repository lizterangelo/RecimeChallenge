import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        Text("Profile settings coming soon")
                            .navigationTitle("Profile")
                    } label: {
                        Label("Profile", systemImage: "person.circle")
                    }

                    NavigationLink {
                        Text("Preferences coming soon")
                            .navigationTitle("Preferences")
                    } label: {
                        Label("Preferences", systemImage: "gearshape")
                    }
                }

                Section {
                    NavigationLink {
                        Text("Notifications settings coming soon")
                            .navigationTitle("Notifications")
                    } label: {
                        Label("Notifications", systemImage: "bell")
                    }

                    NavigationLink {
                        Text("Appearance settings coming soon")
                            .navigationTitle("Appearance")
                    } label: {
                        Label("Appearance", systemImage: "paintbrush")
                    }
                }

                Section {
                    NavigationLink {
                        aboutView
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }

                    Link(destination: URL(string: "https://example.com/help")!) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                }

                Section {
                    NavigationLink {
                        Text("Privacy Policy")
                            .navigationTitle("Privacy")
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }

                    NavigationLink {
                        Text("Terms of Service")
                            .navigationTitle("Terms")
                    } label: {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                }
            }
            .navigationTitle("More")
        }
    }

    private var aboutView: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "book.closed.fill")
                    .font(AppFont.iconLarge)
                    .foregroundStyle(Color.accentColor)

                Text("RecimeChallenge")
                    .font(AppFont.title)
                    .fontWeight(.bold)

                Text("Version 1.0.0")
                    .font(AppFont.subheadline)
                    .foregroundStyle(.secondary)

                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(AppFont.headline)

                        Text("A beautiful recipe app built with SwiftUI featuring liquid glass design, cookbook organization, meal planning, and grocery lists.")
                            .font(AppFont.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            .padding()
        }
        .navigationTitle("About")
    }
}

#Preview {
    MoreView()
}
