import SwiftUI

struct IngredientInputSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var quantity = ""
    @State private var unit = ""

    let onAdd: (String, String, String?) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Ingredient name", text: $name)
                TextField("Quantity", text: $quantity)
                TextField("Unit (optional)", text: $unit)
            }
            .navigationTitle("Add Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(name, quantity, unit.isEmpty ? nil : unit)
                        dismiss()
                    }
                    .disabled(name.isEmpty || quantity.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    IngredientInputSheet { _, _, _ in }
}
