import SwiftUI

struct AddGrocerySheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var quantity = ""
    @State private var category: GroceryCategory = .other

    let onAdd: (String, String, GroceryCategory) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Item name", text: $name)
                TextField("Quantity (optional)", text: $quantity)

                Picker("Category", selection: $category) {
                    ForEach(GroceryCategory.allCases) { cat in
                        Label(cat.displayName, systemImage: cat.iconName)
                            .tag(cat)
                    }
                }
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(name, quantity, category)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    AddGrocerySheet { _, _, _ in }
}
