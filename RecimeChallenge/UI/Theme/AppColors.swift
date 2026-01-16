import SwiftUI

/// App color palette
/// Primary color: #FF7A01 (Orange)
enum AppColors {
    /// Primary brand color - #FF7A01
    static let primary = Color("PrimaryColor")

    /// System background colors
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)

    /// Label colors
    static let label = Color(.label)
    static let secondaryLabel = Color(.secondaryLabel)
    static let tertiaryLabel = Color(.tertiaryLabel)

    /// Semantic colors
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
}

// MARK: - Color Extension

extension Color {
    /// Primary brand color
    static let appPrimary = AppColors.primary
}

// MARK: - ShapeStyle Extension

extension ShapeStyle where Self == Color {
    /// Primary brand color
    static var appPrimary: Color { AppColors.primary }
}
