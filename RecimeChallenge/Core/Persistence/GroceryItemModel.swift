import Foundation
import SwiftData

@Model
final class GroceryItemModel {
    var id: UUID
    var name: String
    var quantity: String
    var isChecked: Bool
    var categoryRaw: String

    var category: GroceryCategory {
        get { GroceryCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    var displayText: String {
        quantity.isEmpty ? name : "\(quantity) \(name)"
    }

    init(id: UUID = UUID(), name: String, quantity: String, isChecked: Bool = false, category: GroceryCategory) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.isChecked = isChecked
        self.categoryRaw = category.rawValue
    }
}
