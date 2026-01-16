import Foundation

struct Recipe: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let servings: Int
    let ingredients: [Ingredient]
    let instructions: [String]
    let dietaryAttributes: [DietaryAttribute]
    let imageURL: String?
    let preparationTime: Int?
    let cookingTime: Int?

    var totalTime: Int? {
        switch (preparationTime, cookingTime) {
        case let (prep?, cook?): return prep + cook
        case let (prep?, nil): return prep
        case let (nil, cook?): return cook
        case (nil, nil): return nil
        }
    }

    var totalTimeFormatted: String? {
        guard let total = totalTime else { return nil }
        if total >= 60 {
            let hours = total / 60
            let minutes = total % 60
            return minutes == 0 ? "\(hours)h" : "\(hours)h \(minutes)m"
        }
        return "\(total)m"
    }

    var isVegetarian: Bool {
        dietaryAttributes.contains(.vegetarian) || dietaryAttributes.contains(.vegan)
    }
}
