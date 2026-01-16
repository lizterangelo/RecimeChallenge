import Foundation

@Observable
final class GroceriesViewModel {
    var items: [GroceryItem] = []

    var groupedItems: [GroceryCategory: [GroceryItem]] {
        Dictionary(grouping: items) { $0.category }
    }

    var checkedCount: Int {
        items.filter { $0.isChecked }.count
    }

    var uncheckedCount: Int {
        items.filter { !$0.isChecked }.count
    }

    func addItem(name: String, quantity: String, category: GroceryCategory) {
        let item = GroceryItem(id: UUID(), name: name, quantity: quantity, isChecked: false, category: category)
        items.append(item)
    }

    func toggleItem(_ item: GroceryItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isChecked.toggle()
    }

    func removeItem(_ item: GroceryItem) {
        items.removeAll { $0.id == item.id }
    }

    func clearChecked() {
        items.removeAll { $0.isChecked }
    }

    func clearAll() {
        items.removeAll()
    }
}
