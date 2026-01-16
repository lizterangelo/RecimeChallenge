import SwiftUI

struct HighlightedInstructionText: View {
    let text: String
    let keywords: [String]

    var body: some View {
        highlightedText
            .font(AppFont.body)
    }

    private var highlightedText: Text {
        var result = Text("")
        var remainingText = text

        while !remainingText.isEmpty {
            // Find the earliest keyword match
            var earliestMatch: (range: Range<String.Index>, keyword: String)?

            for keyword in keywords {
                if let range = remainingText.range(of: keyword, options: .caseInsensitive) {
                    if earliestMatch == nil || range.lowerBound < earliestMatch!.range.lowerBound {
                        earliestMatch = (range, keyword)
                    }
                }
            }

            if let match = earliestMatch {
                // Add text before the match
                let beforeText = String(remainingText[..<match.range.lowerBound])
                if !beforeText.isEmpty {
                    result = result + Text(beforeText)
                }

                // Add the highlighted keyword
                let matchedText = String(remainingText[match.range])
                result = result + Text(matchedText).foregroundColor(AppColors.primary)

                // Continue with remaining text
                remainingText = String(remainingText[match.range.upperBound...])
            } else {
                // No more matches, add remaining text
                result = result + Text(remainingText)
                break
            }
        }

        return result
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        HighlightedInstructionText(
            text: "Heat oil in a cooking pot. Sauté the garlic and onion.",
            keywords: ["oil", "garlic", "onion"]
        )

        HighlightedInstructionText(
            text: "Add the chicken broth and bring to a boil.",
            keywords: ["chicken broth", "salt", "pepper"]
        )

        HighlightedInstructionText(
            text: "No keywords in this instruction.",
            keywords: ["something", "else"]
        )
    }
    .padding()
}
