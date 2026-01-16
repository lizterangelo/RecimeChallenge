import SwiftData
import SwiftUI

struct MealPlanView: View {
    @Query private var mealItems: [MealItemModel]
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel = MealPlanViewModel()
    @State private var showRecipeSelector = false
    @State private var selectedMealSlot: MealPlanViewModel.MealSlot?
    @State private var selectedRecipeForDetail: Recipe?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 20) {
                        weekSelector
                        mealCards
                    }
                    .padding()
                }

                floatingAddButton
            }
            .navigationTitle("Meal Plan")
            .sheet(isPresented: $showRecipeSelector) {
                recipeSelectorSheet
            }
            .navigationDestination(item: $selectedRecipeForDetail) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .onAppear {
                viewModel.setContext(modelContext)
            }
        }
    }

    private var weekSelector: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.weekDates(), id: \.self) { date in
                        DayButton(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate),
                            hasMeals: viewModel.hasAnyMeal(on: date, mealItems: mealItems)
                        ) {
                            viewModel.selectDate(date)
                        }
                        .id(date)
                    }
                }
            }
            .onAppear {
                // Scroll to today on appear, anchoring to the leading edge
                let today = Calendar.current.startOfDay(for: Date())
                proxy.scrollTo(today, anchor: .leading)
            }
        }
    }

    private var mealCards: some View {
        List {
            mealSlotSection(slot: .breakfast)
            mealSlotSection(slot: .lunch)
            mealSlotSection(slot: .dinner)
            mealSlotSection(slot: .snacks)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private func mealSlotSection(slot: MealPlanViewModel.MealSlot) -> some View {
        let items = viewModel.getMealItems(for: viewModel.selectedDate, slot: slot, from: mealItems)

        if items.isEmpty {
            MealSlotCard(
                mealType: slot.displayName,
                icon: slot.icon,
                recipeTitle: nil,
                recipeImageURL: nil,
                onTap: {
                    selectedMealSlot = slot
                    showRecipeSelector = true
                }
            )
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        } else {
            ForEach(items) { item in
                MealSlotCard(
                    mealType: slot.displayName,
                    icon: slot.icon,
                    recipeTitle: item.recipeTitle,
                    recipeImageURL: item.recipeImageURL,
                    onTap: {
                        loadAndShowRecipe(id: item.recipeId)
                    }
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deleteMealItem(item)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }

    private var floatingAddButton: some View {
        Menu {
            Button {
                selectedMealSlot = .breakfast
                showRecipeSelector = true
            } label: {
                Label("Breakfast", systemImage: "sunrise")
            }

            Button {
                selectedMealSlot = .lunch
                showRecipeSelector = true
            } label: {
                Label("Lunch", systemImage: "sun.max")
            }

            Button {
                selectedMealSlot = .dinner
                showRecipeSelector = true
            } label: {
                Label("Dinner", systemImage: "moon.stars")
            }

            Button {
                selectedMealSlot = .snacks
                showRecipeSelector = true
            } label: {
                Label("Snacks", systemImage: "carrot")
            }
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(AppColors.primary)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
    }

    private var recipeSelectorSheet: some View {
        NavigationStack {
            RecipeSelectorView { recipe in
                if let slot = selectedMealSlot {
                    viewModel.addMeal(recipe, for: slot, on: viewModel.selectedDate)
                }
                showRecipeSelector = false
            }
            .navigationTitle("Select Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showRecipeSelector = false
                    }
                }
            }
        }
    }

    private func loadAndShowRecipe(id: UUID) {
        // Load the full recipe from the API to show details
        Task {
            let apiClient = MockAPIClient()
            if let recipe = try? await apiClient.fetchRecipe(id: id) {
                await MainActor.run {
                    selectedRecipeForDetail = recipe
                }
            }
        }
    }
}

#Preview {
    MealPlanView()
        .modelContainer(for: MealItemModel.self, inMemory: true)
}
