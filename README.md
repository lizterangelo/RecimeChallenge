# RecimeChallenge

A native iOS recipe app with **liquid glass UI** built with Swift and SwiftUI.

## Setup Instructions

### Requirements
- Xcode 16.0+
- iOS 26.0+ deployment target
- macOS Sequoia or later

### Getting Started

1. Clone the repository
2. Open `RecimeChallenge.xcodeproj` in Xcode
3. Select an iOS simulator (iPhone 16 Pro recommended)
4. Press `Cmd + R` to build and run

No additional dependencies or package managers required.

## Architecture Overview

The app follows **MVVM (Model-View-ViewModel)** with feature-based organization:

```
RecimeChallenge/
├── Core/
│   ├── Network/              # API client protocol & mock
│   └── Utilities/            # JSON loader
├── Models/                   # Recipe, Cookbook, MealPlan, GroceryItem
├── Features/
│   ├── Cookbooks/           # Browse recipe collections
│   ├── MealPlan/            # Weekly meal planning
│   ├── AddRecipe/           # Create new recipes
│   ├── Groceries/           # Shopping list
│   └── More/                # Settings & profile
├── UI/
│   ├── Components/          # GlassCard, DietaryBadge, etc.
│   ├── Styles/              # Glass styles & modifiers
│   └── Navigation/          # MainTabView (5 tabs)
├── Resources/               # recipes.json mock data
└── Preview Content/         # SwiftUI preview data
```

## Key Features

### 5-Tab Navigation
1. **Cookbooks** - Browse recipe collections organized by category
2. **Meal Plan** - Weekly meal planning with breakfast/lunch/dinner
3. **Add** - Create new recipes with ingredients and instructions
4. **Groceries** - Shopping list with categories and check-off
5. **More** - Settings, profile, and app info

### Liquid Glass UI
- `.ultraThinMaterial` for glass card effects
- Custom `GlassCard` component
- `GlassButtonStyle` for interactive elements
- Subtle shadows for depth

## Key Design Decisions

### 1. Protocol-Based Networking
```swift
protocol APIClientProtocol: Sendable {
    func fetchCookbooks() async throws -> [Cookbook]
    func fetchRecipes() async throws -> [Recipe]
    func fetchRecipe(id: UUID) async throws -> Recipe
}
```
- `MockAPIClient` loads from local JSON
- Simulated network delay (500ms)
- Easy to swap for real API

### 2. @Observable ViewModels
Modern iOS 17+ observation for cleaner reactive state:
```swift
@Observable
final class CookbooksViewModel {
    private(set) var cookbooks: [Cookbook] = []
    private(set) var isLoading = false
    private(set) var error: APIError?
}
```

### 3. Feature-Based Organization
Each feature is self-contained with:
- `Views/` - SwiftUI views
- `ViewModels/` - State management
- Clear separation of concerns

### 4. Reusable UI Components
- `GlassCard` - Container with glass effect
- `DietaryBadge` - Color-coded dietary tags
- `RecipeCard` - Recipe preview card
- `LoadingView` - Loading state
- `ErrorView` - Error with retry

## Models

| Model | Description |
|-------|-------------|
| `Recipe` | Title, description, servings, ingredients, instructions, dietary |
| `Ingredient` | Name, quantity, unit |
| `DietaryAttribute` | Vegetarian, vegan, gluten-free, dairy-free, nut-free |
| `Cookbook` | Collection of recipes with name and description |
| `MealPlan` | Date with breakfast, lunch, dinner slots |
| `GroceryItem` | Name, quantity, category, checked state |

## Assumptions & Tradeoffs

### Assumptions
- Recipes have unique UUIDs
- Dietary attributes from fixed set
- Mock data bundled with app
- iOS 26+ for latest SwiftUI features

### Tradeoffs
- **No Persistence**: Groceries and meal plans are in-memory only
- **No Images**: Recipe images defined but not displayed
- **No Search in Cookbooks**: Focus on browsing by cookbook
- **No Localization**: English only

## Known Limitations

1. Data not persisted between app launches
2. Recipe images not implemented
3. Mock data only (no real API)
4. No user authentication
5. Single language support

## SwiftUI Previews

All views include previews for rapid development:
1. Open any view file in Xcode
2. Press `Cmd + Option + Enter` to show Canvas
3. Interact with previews

## Future Enhancements

- SwiftData for local persistence
- Recipe image loading
- Search across all recipes
- Share recipes
- Import/export data
- Dark mode optimization
- Unit tests for ViewModels
