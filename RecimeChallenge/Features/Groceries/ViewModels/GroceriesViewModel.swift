import Foundation
import SwiftData

@Observable
final class GroceriesViewModel {
    private var modelContext: ModelContext?

    func setContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // Computed properties now take items from @Query in the view
    func groupedItems(_ items: [GroceryItemModel]) -> [GroceryCategory: [GroceryItemModel]] {
        Dictionary(grouping: items) { $0.category }
    }

    func checkedCount(_ items: [GroceryItemModel]) -> Int {
        items.filter { $0.isChecked }.count
    }

    func uncheckedCount(_ items: [GroceryItemModel]) -> Int {
        items.filter { !$0.isChecked }.count
    }

    func addItem(name: String, quantity: String, category: GroceryCategory) {
        guard let context = modelContext else { return }
        let item = GroceryItemModel(name: name, quantity: quantity, category: category)
        context.insert(item)
    }

    func toggleItem(_ item: GroceryItemModel) {
        item.isChecked.toggle()
    }

    func removeItem(_ item: GroceryItemModel) {
        modelContext?.delete(item)
    }

    func clearChecked(_ items: [GroceryItemModel]) {
        items.filter { $0.isChecked }.forEach { modelContext?.delete($0) }
    }

    func clearAll(_ items: [GroceryItemModel]) {
        items.forEach { modelContext?.delete($0) }
    }
}
