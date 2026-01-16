import SwiftUI

struct RecipeFiltersSheet: View {
    @Binding var filters: RecipeFilters
    @Environment(\.dismiss) private var dismiss

    @State private var tempFilters: RecipeFilters
    @State private var ingredientInput = ""
    @State private var excludeIngredientInput = ""
    @State private var servingsInput = ""

    init(filters: Binding<RecipeFilters>) {
        _filters = filters
        _tempFilters = State(initialValue: filters.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            Form {
                // Vegetarian Toggle
                Section("Dietary") {
                    Toggle("Vegetarian Only", isOn: Binding(
                        get: { tempFilters.isVegetarian ?? false },
                        set: { tempFilters.isVegetarian = $0 ? true : nil }
                    ))
                }

                // Servings Filter
                Section("Servings") {
                    HStack {
                        TextField("Any", text: $servingsInput)
                            .keyboardType(.numberPad)
                            .onChange(of: servingsInput) {
                                tempFilters.servings = Int(servingsInput)
                            }

                        if !servingsInput.isEmpty {
                            Button(action: {
                                servingsInput = ""
                                tempFilters.servings = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                // Include Ingredients
                Section {
                    HStack {
                        TextField("Add ingredient to include...", text: $ingredientInput)
                            .textInputAutocapitalization(.never)

                        Button("Add") {
                            addIncludedIngredient()
                        }
                        .disabled(ingredientInput.trimmingCharacters(in: .whitespaces).isEmpty)
                    }

                    if !tempFilters.includedIngredients.isEmpty {
                        ForEach(tempFilters.includedIngredients, id: \.self) { ingredient in
                            HStack {
                                Text(ingredient)
                                Spacer()
                                Button(action: {
                                    tempFilters.includedIngredients.removeAll { $0 == ingredient }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Include Ingredients")
                } footer: {
                    Text("Recipes must contain ALL listed ingredients")
                }

                // Exclude Ingredients
                Section {
                    HStack {
                        TextField("Add ingredient to exclude...", text: $excludeIngredientInput)
                            .textInputAutocapitalization(.never)

                        Button("Add") {
                            addExcludedIngredient()
                        }
                        .disabled(excludeIngredientInput.trimmingCharacters(in: .whitespaces).isEmpty)
                    }

                    if !tempFilters.excludedIngredients.isEmpty {
                        ForEach(tempFilters.excludedIngredients, id: \.self) { ingredient in
                            HStack {
                                Text(ingredient)
                                Spacer()
                                Button(action: {
                                    tempFilters.excludedIngredients.removeAll { $0 == ingredient }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Exclude Ingredients")
                } footer: {
                    Text("Recipes must NOT contain any listed ingredients")
                }

                // Search in Instructions
                Section {
                    TextField("Search instructions...", text: Binding(
                        get: { tempFilters.searchInInstructions ?? "" },
                        set: { tempFilters.searchInInstructions = $0.isEmpty ? nil : $0 }
                    ))
                    .textInputAutocapitalization(.never)
                } header: {
                    Text("Instructions")
                } footer: {
                    Text("Find recipes with specific cooking steps")
                }
            }
            .navigationTitle("Recipe Filters")
            .onAppear {
                // Sync state with binding when sheet appears
                tempFilters = filters
                servingsInput = filters.servings.map { String($0) } ?? ""
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        tempFilters = .empty
                        servingsInput = ""
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        filters = tempFilters
                        dismiss()
                    }
                }
            }
        }
    }

    private func addIncludedIngredient() {
        let trimmed = ingredientInput.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !tempFilters.includedIngredients.contains(trimmed) else { return }
        tempFilters.includedIngredients.append(trimmed)
        ingredientInput = ""
    }

    private func addExcludedIngredient() {
        let trimmed = excludeIngredientInput.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !tempFilters.excludedIngredients.contains(trimmed) else { return }
        tempFilters.excludedIngredients.append(trimmed)
        excludeIngredientInput = ""
    }
}

#Preview {
    RecipeFiltersSheet(filters: .constant(.empty))
}
