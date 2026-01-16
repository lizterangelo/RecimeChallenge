import SwiftUI

/// App typography system
/// - Recoleta: Used for app title only
/// - Poppins: Used for all other text
enum AppFont {

    // MARK: - Recoleta (Title Only)

    /// Recoleta font family - use only for app title
    enum Recoleta {
        static func regular(_ size: CGFloat) -> Font {
            .custom("Recoleta-Regular", size: size)
        }

        static func medium(_ size: CGFloat) -> Font {
            .custom("Recoleta-Medium", size: size)
        }

        static func semiBold(_ size: CGFloat) -> Font {
            .custom("Recoleta-SemiBold", size: size)
        }

        static func bold(_ size: CGFloat) -> Font {
            .custom("Recoleta-Bold", size: size)
        }
    }

    // MARK: - Poppins (Everything Else)

    /// Poppins font family - use for all text except app title
    enum Poppins {
        static func light(_ size: CGFloat) -> Font {
            .custom("Poppins-Light", size: size)
        }

        static func regular(_ size: CGFloat) -> Font {
            .custom("Poppins-Regular", size: size)
        }

        static func medium(_ size: CGFloat) -> Font {
            .custom("Poppins-Medium", size: size)
        }

        static func semiBold(_ size: CGFloat) -> Font {
            .custom("Poppins-SemiBold", size: size)
        }

        static func bold(_ size: CGFloat) -> Font {
            .custom("Poppins-Bold", size: size)
        }
    }
}

// MARK: - Semantic Typography

extension AppFont {
    /// App title - "ReciMe Challenge" (Recoleta Bold 28pt)
    static let appTitle = Recoleta.bold(28)

    // MARK: - Headings (Poppins)

    /// Large title - 32pt Bold
    static let largeTitle = Poppins.bold(32)

    /// Title - 24pt SemiBold
    static let title = Poppins.semiBold(24)

    /// Title 2 - 20pt SemiBold
    static let title2 = Poppins.semiBold(20)

    /// Title 3 - 18pt Medium
    static let title3 = Poppins.medium(18)

    // MARK: - Body (Poppins)

    /// Headline - 16pt SemiBold
    static let headline = Poppins.semiBold(16)

    /// Body - 16pt Regular
    static let body = Poppins.regular(16)

    /// Callout - 14pt Regular
    static let callout = Poppins.regular(14)

    /// Subheadline - 14pt Medium
    static let subheadline = Poppins.medium(14)

    /// Footnote - 12pt Regular
    static let footnote = Poppins.regular(12)

    /// Caption - 11pt Regular
    static let caption = Poppins.regular(11)

    /// Caption 2 - 10pt Light
    static let caption2 = Poppins.light(10)
}

// MARK: - View Modifier

extension View {
    /// Apply app title style (Recoleta Bold + Primary Color)
    func appTitleStyle() -> some View {
        self
            .font(AppFont.appTitle)
            .foregroundStyle(AppColors.primary)
    }
}
