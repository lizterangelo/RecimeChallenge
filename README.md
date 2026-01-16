# RecimeChallenge

A native iOS recipe app with **liquid glass UI** built with Swift and SwiftUI, featuring **45,000+ recipes**, AI-powered recipe import, and SwiftData persistence.

## Setup Instructions

### iOS App

**Requirements:**
- Xcode 16.0+
- iOS 26.0+ deployment target
- macOS Sequoia or later

**Getting Started:**
1. Clone the repository
2. Open `RecimeChallenge.xcodeproj` in Xcode
3. Select an iOS simulator (iPhone 16 Pro recommended)
4. Press `Cmd + R` to build and run

No additional package manager setup required - Swift Package Manager dependencies resolve automatically.

### Backend Server (Recipe Import)

The recipe import feature requires a backend server. A hosted version is available, but you can also run locally.

**Hosted Server:**
- URL: `https://recimechallengebackend.onrender.com`
- Note: If imports fail, the Firecrawl or Gemini API credits may be exhausted

**Local Server Setup:**

Prerequisites: Node.js 18+

```bash
cd RecimeChallengeBackend
npm install
```

Create `.env` file from template:
```bash
cp .env.example .env
```

Add your API keys to `.env`:
```
GEMINI_API_KEY=your_key_here      # Get from https://aistudio.google.com/
FIRECRAWL_API_KEY=your_key_here   # Get from https://www.firecrawl.dev/
PORT=3000
```

Run the server:
```bash
npm run dev    # Development with auto-reload
npm start      # Production
```

To use localhost, update the `baseURL` in `RecipeImportService.swift`:
```swift
private let baseURL = "http://localhost:3000"
```

---

## Architecture Overview

The app follows **MVVM** with feature-based organization:

```
RecimeChallenge/
├── Core/
│   ├── Coordinator/         # App navigation state
│   ├── Network/             # API client protocol & mock
│   ├── Persistence/         # SwiftData models
│   ├── Services/            # Analytics, Recipe Import
│   └── Utilities/           # JSON loader
├── Models/                  # Recipe, Cookbook, Filters
├── Features/
│   ├── Cookbooks/           # Browse & search recipes
│   ├── MealPlan/            # Weekly meal planning
│   ├── AddRecipe/           # Import recipes from web
│   ├── Groceries/           # Shopping list
│   └── More/                # Settings menu
├── UI/
│   ├── Components/          # Reusable UI (GlassCard, etc.)
│   ├── Theme/               # Colors, Typography
│   ├── Splash/              # Launch screen
│   └── Navigation/          # Tab bar
└── Resources/               # recipes.json (45K+ recipes)

RecimeChallengeBackend/
├── index.js                 # Express server
├── services/
│   ├── scraper.js           # Firecrawl integration
│   └── gemini.js            # AI recipe parsing
└── render.yaml              # Deployment config
```

---

## Tab Features

### 1. Cookbooks Tab

Browse and search through **45,413 recipes** across **1,000 cookbooks**.

**Key Features:**
- **Dual Mode** - Toggle between browsing cookbooks or all recipes
- **Infinite Scroll** - Pagination with 20 items per page, threshold loading at 5 items from end
- **Advanced Filtering:**
  - Vegetarian toggle
  - Servings filter
  - Include specific ingredients (must contain ALL)
  - Exclude specific ingredients (must contain NONE)
  - Search within cooking instructions
- **Search** - 300ms debounced search to prevent excessive API calls
- **Lazy Loading** - LazyVGrid/LazyVStack for memory-efficient rendering
- **Skeleton UI** - Loading placeholders while fetching data
- **Performance Optimized** - In-memory caching, efficient filtering for 45K+ recipes

### 2. Meal Plan Tab

Plan your weekly meals with persistent storage.

**Key Features:**
- **Week View** - 15-day calendar (1 week before → today → 1 week after)
- **4 Meal Slots** - Breakfast, Lunch, Dinner, Snacks
- **SwiftData Persistence** - Meals saved locally via `MealItemModel`
- **Recipe Integration** - Add recipes directly from the catalog
- **Swipe Actions** - Swipe to delete meals
- **Visual Indicators** - Dots show which days have planned meals

### 3. Import Tab

Import recipes from any website - works like the original ReciMe app.

**Key Features:**
- **Built-in Browser** - WebView for navigating recipe sites
- **AI-Powered Parsing** - Uses Gemini 2.5 Flash Lite to extract recipe data
- **Web Scraping** - Firecrawl converts pages to structured content
- **Smart Extraction** - Parses ingredients, instructions, times, dietary info
- **Navigation Controls** - Back, forward, refresh buttons

**How It Works:**
1. Browse to any recipe page
2. Tap "Import" button
3. Backend scrapes page with Firecrawl
4. Gemini AI parses into structured recipe
5. Review and save imported recipe

**Note:** If import fails, the hosted server may be out of API credits. See [Backend Setup](#backend-server-recipe-import) to run locally.

### 4. Groceries Tab

Manage your shopping list with categories.

**Key Features:**
- **6 Categories** - Produce, Dairy, Meat, Pantry, Frozen, Other
- **SwiftData Persistence** - Items saved locally via `GroceryItemModel`
- **Check/Uncheck** - Mark items as purchased
- **Bulk Actions** - Clear checked items or clear all
- **Swipe to Delete** - Remove individual items
- **Enhanced Empty State** - Friendly UI when list is empty

### 5. More Tab

Access additional app features and information.

**Features:**
- Side menu navigation
- Help & Support link
- Privacy Policy link
- Terms of Service link

---

## Analytics

The app integrates **Mixpanel** for comprehensive event tracking.

**Events Tracked:**
- Tab selections and navigation
- Search queries and filter usage
- Recipe and cookbook opens
- Import attempts (success/failure)
- Grocery list operations
- Menu link taps

**Public Dashboard:**
View live analytics at: https://mixpanel.com/p/LAvAfhfnoGzYGE2UQ2E3Wy

---

## Key Design Decisions

### 1. Protocol-Based Networking
```swift
protocol APIClientProtocol: Sendable {
    func fetchCookbooks(page: Int, pageSize: Int) async throws -> PaginatedResponse<Cookbook>
    func fetchRecipes(_ request: RecipeSearchRequest) async throws -> PaginatedResponse<Recipe>
}
```
- `MockAPIClient` loads from bundled JSON
- Easy to swap for real API implementation
- Supports testability and previews

### 2. @Observable ViewModels (iOS 17+)
```swift
@Observable
final class CookbooksViewModel {
    private(set) var recipes: [Recipe] = []
    var searchText = ""
    var recipeFilters: RecipeFilters = .empty
}
```
- Cleaner than `ObservableObject` + `@Published`
- Automatic change tracking
- No property wrappers needed in views

### 3. SwiftData for Persistence
- Simpler than CoreData
- Native Swift integration
- Models: `GroceryItemModel`, `MealItemModel`, `MealPlanModel`

### 4. AdvancedList for Infinite Scroll
- Threshold-based pagination (loads at 5 items from end)
- Built-in state management (loading, error, items)
- Supports both grid and list layouts

### 5. Backend Architecture
- **Firecrawl** for reliable web scraping (handles JavaScript rendering)
- **Gemini AI** for intelligent recipe parsing
- Stateless API design - no database needed
- Deployed on Render for easy scaling

---

## Dependencies

### iOS App
| Package | Purpose |
|---------|---------|
| AdvancedList | Infinite scroll with pagination |
| SkeletonUI | Loading state placeholders |
| Mixpanel | Analytics tracking |

### Backend
| Package | Purpose |
|---------|---------|
| express | Web server framework |
| @google/generative-ai | Gemini API client |
| cors | Cross-origin requests |
| dotenv | Environment variables |

---

## Models

| Model | Description |
|-------|-------------|
| `Recipe` | Title, description, servings, ingredients, instructions, dietary attributes, times |
| `Cookbook` | Collection of recipes with name and description |
| `Ingredient` | Name, quantity, unit |
| `DietaryAttribute` | Vegetarian, Vegan, Gluten-Free, Dairy-Free, Nut-Free |
| `RecipeFilters` | Advanced search filters |
| `GroceryItemModel` | SwiftData model for grocery items |
| `MealItemModel` | SwiftData model for meal plan entries |

---

## Known Limitations

1. **Recipe Import** - Depends on external API credits (Firecrawl, Gemini). May fail if credits exhausted.
2. **Mock Data** - Recipe catalog uses bundled JSON, not a live API
3. **Single Language** - English only
4. **No Authentication** - No user accounts or cloud sync
5. **Local Storage** - Groceries and meal plans stored on-device only

---

## Technical Highlights

- **45,413 recipes** loaded and filtered efficiently with pagination
- **In-memory caching** prevents redundant JSON parsing
- **Search debouncing** (300ms) reduces unnecessary API calls
- **Lazy loading** defers view creation for large lists
- **Skeleton UI** provides loading feedback
- **Threshold pagination** loads more content before user reaches end

---

## Future Enhancements

- Cloud sync for groceries and meal plans
- Recipe sharing
- Offline recipe storage
- Multi-language support
- User authentication
- Favorites and collections
