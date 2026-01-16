import Foundation

struct Ingredient: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let quantity: String
    let unit: String?

    var displayText: String {
        if let unit {
            return "\(quantity) \(unit) \(name)"
        }
        return "\(quantity) \(name)"
    }
}
