import Foundation

@Observable
final class AddRecipeViewModel {
    var title: String = ""
    var description: String = ""
    var servings: Int = 4
    var preparationTime: Int = 15
    var cookingTime: Int = 30
    var ingredients: [Ingredient] = []
    var instructions: [String] = [""]
    var dietaryAttributes: Set<DietaryAttribute> = []

    var isValid: Bool {
        !title.isEmpty && !description.isEmpty && !ingredients.isEmpty && !instructions.filter { !$0.isEmpty }.isEmpty
    }

    func addIngredient(name: String, quantity: String, unit: String?) {
        let ingredient = Ingredient(id: UUID(), name: name, quantity: quantity, unit: unit)
        ingredients.append(ingredient)
    }

    func removeIngredient(at index: Int) {
        guard ingredients.indices.contains(index) else { return }
        ingredients.remove(at: index)
    }

    func addInstruction() {
        instructions.append("")
    }

    func removeInstruction(at index: Int) {
        guard instructions.indices.contains(index), instructions.count > 1 else { return }
        instructions.remove(at: index)
    }

    func toggleDietaryAttribute(_ attribute: DietaryAttribute) {
        if dietaryAttributes.contains(attribute) {
            dietaryAttributes.remove(attribute)
        } else {
            dietaryAttributes.insert(attribute)
        }
    }

    func reset() {
        title = ""
        description = ""
        servings = 4
        preparationTime = 15
        cookingTime = 30
        ingredients = []
        instructions = [""]
        dietaryAttributes = []
    }
}
