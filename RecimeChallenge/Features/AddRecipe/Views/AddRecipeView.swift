import SwiftUI

struct AddRecipeView: View {
    @State private var viewModel = AddRecipeViewModel()
    @State private var showingIngredientSheet = false

    var body: some View {
        NavigationStack {
            Form {
                basicInfoSection
                timingSection
                ingredientsSection
                instructionsSection
                dietarySection
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        // Save action - placeholder
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }

    private var basicInfoSection: some View {
        Section("Basic Info") {
            TextField("Recipe Title", text: $viewModel.title)

            TextField("Description", text: $viewModel.description, axis: .vertical)
                .lineLimit(3...6)

            Stepper("Servings: \(viewModel.servings)", value: $viewModel.servings, in: 1...20)
        }
    }

    private var timingSection: some View {
        Section("Time") {
            Stepper("Prep: \(viewModel.preparationTime) min", value: $viewModel.preparationTime, in: 0...180, step: 5)

            Stepper("Cook: \(viewModel.cookingTime) min", value: $viewModel.cookingTime, in: 0...300, step: 5)
        }
    }

    private var ingredientsSection: some View {
        Section("Ingredients") {
            ForEach(viewModel.ingredients) { ingredient in
                Text(ingredient.displayText)
            }
            .onDelete { indexSet in
                indexSet.forEach { viewModel.removeIngredient(at: $0) }
            }

            Button {
                showingIngredientSheet = true
            } label: {
                Label("Add Ingredient", systemImage: "plus.circle")
            }
        }
        .sheet(isPresented: $showingIngredientSheet) {
            IngredientInputSheet { name, quantity, unit in
                viewModel.addIngredient(name: name, quantity: quantity, unit: unit)
            }
        }
    }

    private var instructionsSection: some View {
        Section("Instructions") {
            ForEach(Array(viewModel.instructions.enumerated()), id: \.offset) { index, _ in
                HStack(alignment: .top) {
                    Text("\(index + 1).")
                        .foregroundStyle(.secondary)

                    TextField("Step \(index + 1)", text: $viewModel.instructions[index], axis: .vertical)
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { viewModel.removeInstruction(at: $0) }
            }

            Button {
                viewModel.addInstruction()
            } label: {
                Label("Add Step", systemImage: "plus.circle")
            }
        }
    }

    private var dietarySection: some View {
        Section("Dietary") {
            ForEach(DietaryAttribute.allCases) { attribute in
                Toggle(attribute.displayName, isOn: Binding(
                    get: { viewModel.dietaryAttributes.contains(attribute) },
                    set: { _ in viewModel.toggleDietaryAttribute(attribute) }
                ))
            }
        }
    }
}

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
    AddRecipeView()
}
