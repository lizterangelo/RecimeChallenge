import SwiftUI

struct GroceryItemRow: View {
    let item: GroceryItem
    let onToggle: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(AppFont.title2)
                    .foregroundStyle(item.isChecked ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(AppFont.body)
                    .strikethrough(item.isChecked)
                    .foregroundStyle(item.isChecked ? .secondary : .primary)

                if !item.quantity.isEmpty {
                    Text(item.quantity)
                        .font(AppFont.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(AppFont.caption)
                    .foregroundStyle(.red.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        GroceryItemRow(
            item: GroceryItem(id: UUID(), name: "Milk", quantity: "1 gallon", isChecked: false, category: .dairy),
            onToggle: {},
            onDelete: {}
        )
        GroceryItemRow(
            item: GroceryItem(id: UUID(), name: "Eggs", quantity: "1 dozen", isChecked: true, category: .dairy),
            onToggle: {},
            onDelete: {}
        )
    }
}
