#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Expanded base recipe templates (30 recipes)
const baseRecipeTemplates = [
  {
    title: "Classic Margherita Pizza",
    description: "A traditional Italian pizza with fresh tomatoes, mozzarella, and basil on a crispy thin crust.",
    servings: 4,
    ingredients: [
      {name: "pizza dough", quantity: "1", unit: "lb"},
      {name: "San Marzano tomatoes", quantity: "1", unit: "can"},
      {name: "fresh mozzarella", quantity: "8", unit: "oz"},
      {name: "fresh basil leaves", quantity: "10", unit: null},
      {name: "olive oil", quantity: "2", unit: "tbsp"}
    ],
    instructions: [
      "Preheat your oven to 500°F (260°C) with a pizza stone inside.",
      "Crush the San Marzano tomatoes by hand and season with salt.",
      "Stretch the pizza dough into a 12-inch circle.",
      "Spread the crushed tomatoes evenly over the dough.",
      "Tear the fresh mozzarella and distribute over the pizza.",
      "Bake for 8-10 minutes until crust is golden.",
      "Top with fresh basil and drizzle with olive oil."
    ],
    dietaryAttributes: ["vegetarian"],
    preparationTime: 20,
    cookingTime: 10
  },
  {
    title: "Creamy Mushroom Risotto",
    description: "A luxurious Italian rice dish with earthy mushrooms and Parmesan cheese.",
    servings: 4,
    ingredients: [
      {name: "arborio rice", quantity: "1.5", unit: "cups"},
      {name: "mixed mushrooms", quantity: "8", unit: "oz"},
      {name: "vegetable broth", quantity: "4", unit: "cups"},
      {name: "white wine", quantity: "0.5", unit: "cup"},
      {name: "Parmesan cheese", quantity: "0.5", unit: "cup"},
      {name: "butter", quantity: "3", unit: "tbsp"}
    ],
    instructions: [
      "Heat the vegetable broth and keep warm.",
      "Sauté mushrooms in butter until golden, set aside.",
      "Toast rice for 2 minutes, add wine and stir.",
      "Add broth one ladle at a time, stirring constantly.",
      "Continue for 18-20 minutes until creamy.",
      "Stir in mushrooms, Parmesan, and serve."
    ],
    dietaryAttributes: ["vegetarian"],
    preparationTime: 10,
    cookingTime: 30
  },
  {
    title: "Grilled Lemon Herb Chicken",
    description: "Tender chicken breasts marinated in lemon, garlic, and fresh herbs.",
    servings: 4,
    ingredients: [
      {name: "chicken breasts", quantity: "4", unit: null},
      {name: "lemon juice", quantity: "0.25", unit: "cup"},
      {name: "garlic cloves", quantity: "4", unit: null},
      {name: "fresh rosemary", quantity: "2", unit: "tbsp"},
      {name: "olive oil", quantity: "3", unit: "tbsp"}
    ],
    instructions: [
      "Mix lemon juice, minced garlic, rosemary, and olive oil.",
      "Marinate chicken for 2 hours in refrigerator.",
      "Preheat grill to medium-high heat.",
      "Grill chicken for 6-7 minutes per side.",
      "Let rest for 5 minutes before serving."
    ],
    dietaryAttributes: ["gluten-free"],
    preparationTime: 15,
    cookingTime: 15
  },
  {
    title: "Quinoa Buddha Bowl",
    description: "A nourishing bowl with quinoa, roasted vegetables, and tahini dressing.",
    servings: 2,
    ingredients: [
      {name: "quinoa", quantity: "1", unit: "cup"},
      {name: "chickpeas", quantity: "1", unit: "can"},
      {name: "sweet potato", quantity: "1", unit: "large"},
      {name: "kale", quantity: "2", unit: "cups"},
      {name: "tahini", quantity: "0.25", unit: "cup"}
    ],
    instructions: [
      "Cook quinoa according to package directions.",
      "Roast sweet potato and chickpeas at 400°F for 25 minutes.",
      "Massage kale with lemon juice.",
      "Assemble bowl and drizzle with tahini dressing."
    ],
    dietaryAttributes: ["vegan", "gluten-free"],
    preparationTime: 15,
    cookingTime: 25
  },
  {
    title: "Classic Beef Tacos",
    description: "Seasoned ground beef in crispy shells with fresh toppings.",
    servings: 4,
    ingredients: [
      {name: "ground beef", quantity: "1", unit: "lb"},
      {name: "taco seasoning", quantity: "2", unit: "tbsp"},
      {name: "taco shells", quantity: "12", unit: null},
      {name: "shredded cheese", quantity: "1", unit: "cup"},
      {name: "lettuce", quantity: "2", unit: "cups"}
    ],
    instructions: [
      "Brown ground beef in a skillet.",
      "Add taco seasoning and water, simmer 5 minutes.",
      "Warm taco shells in oven.",
      "Fill shells with beef and desired toppings."
    ],
    dietaryAttributes: [],
    preparationTime: 10,
    cookingTime: 15
  },
  {
    title: "Thai Green Curry",
    description: "Aromatic coconut curry with vegetables and fragrant Thai basil.",
    servings: 4,
    ingredients: [
      {name: "green curry paste", quantity: "3", unit: "tbsp"},
      {name: "coconut milk", quantity: "1", unit: "can"},
      {name: "bell peppers", quantity: "2", unit: null},
      {name: "bamboo shoots", quantity: "1", unit: "cup"},
      {name: "Thai basil", quantity: "0.5", unit: "cup"}
    ],
    instructions: [
      "Sauté curry paste in oil for 1 minute.",
      "Add coconut milk and bring to simmer.",
      "Add vegetables and cook until tender.",
      "Stir in Thai basil before serving."
    ],
    dietaryAttributes: ["vegan", "gluten-free"],
    preparationTime: 15,
    cookingTime: 20
  },
  {
    title: "Chocolate Chip Cookies",
    description: "Classic chewy cookies loaded with chocolate chips.",
    servings: 24,
    ingredients: [
      {name: "butter", quantity: "1", unit: "cup"},
      {name: "brown sugar", quantity: "1", unit: "cup"},
      {name: "eggs", quantity: "2", unit: null},
      {name: "flour", quantity: "2.5", unit: "cups"},
      {name: "chocolate chips", quantity: "2", unit: "cups"}
    ],
    instructions: [
      "Cream butter and sugar until fluffy.",
      "Beat in eggs and vanilla.",
      "Mix in flour, baking soda, and salt.",
      "Fold in chocolate chips.",
      "Bake at 375°F for 10-12 minutes."
    ],
    dietaryAttributes: ["vegetarian"],
    preparationTime: 15,
    cookingTime: 12
  },
  {
    title: "Caesar Salad",
    description: "Crisp romaine with creamy Caesar dressing and parmesan.",
    servings: 4,
    ingredients: [
      {name: "romaine lettuce", quantity: "2", unit: "heads"},
      {name: "Caesar dressing", quantity: "0.5", unit: "cup"},
      {name: "Parmesan cheese", quantity: "0.5", unit: "cup"},
      {name: "croutons", quantity: "1", unit: "cup"},
      {name: "lemon", quantity: "1", unit: null}
    ],
    instructions: [
      "Chop romaine into bite-sized pieces.",
      "Toss with Caesar dressing.",
      "Top with Parmesan and croutons.",
      "Serve with lemon wedges."
    ],
    dietaryAttributes: ["vegetarian"],
    preparationTime: 10,
    cookingTime: 0
  },
  {
    title: "Spaghetti Carbonara",
    description: "Classic Roman pasta with eggs, cheese, and pancetta.",
    servings: 4,
    ingredients: [
      {name: "spaghetti", quantity: "1", unit: "lb"},
      {name: "pancetta", quantity: "6", unit: "oz"},
      {name: "eggs", quantity: "4", unit: null},
      {name: "Pecorino Romano", quantity: "1", unit: "cup"},
      {name: "black pepper", quantity: "2", unit: "tsp"}
    ],
    instructions: [
      "Cook spaghetti in salted boiling water.",
      "Crisp pancetta in a large pan.",
      "Whisk eggs with cheese and pepper.",
      "Toss hot pasta with pancetta and egg mixture.",
      "Serve immediately."
    ],
    dietaryAttributes: [],
    preparationTime: 10,
    cookingTime: 15
  },
  {
    title: "Vegetable Stir Fry",
    description: "Quick and colorful veggie stir fry with ginger soy sauce.",
    servings: 4,
    ingredients: [
      {name: "broccoli", quantity: "2", unit: "cups"},
      {name: "bell peppers", quantity: "2", unit: null},
      {name: "snap peas", quantity: "1", unit: "cup"},
      {name: "soy sauce", quantity: "3", unit: "tbsp"},
      {name: "fresh ginger", quantity: "1", unit: "tbsp"}
    ],
    instructions: [
      "Heat oil in wok over high heat.",
      "Add ginger and stir for 30 seconds.",
      "Add vegetables and stir fry 5 minutes.",
      "Add soy sauce and toss to coat."
    ],
    dietaryAttributes: ["vegan"],
    preparationTime: 10,
    cookingTime: 8
  },
  {
    title: "Blueberry Pancakes",
    description: "Fluffy buttermilk pancakes studded with fresh blueberries.",
    servings: 4,
    ingredients: [
      {name: "flour", quantity: "2", unit: "cups"},
      {name: "buttermilk", quantity: "2", unit: "cups"},
      {name: "eggs", quantity: "2", unit: null},
      {name: "fresh blueberries", quantity: "1", unit: "cup"},
      {name: "butter", quantity: "4", unit: "tbsp"}
    ],
    instructions: [
      "Mix flour, sugar, baking powder, and salt.",
      "Whisk together buttermilk, eggs, and melted butter.",
      "Combine wet and dry ingredients.",
      "Fold in blueberries gently.",
      "Cook on griddle until golden."
    ],
    dietaryAttributes: ["vegetarian"],
    preparationTime: 10,
    cookingTime: 15
  },
  {
    title: "Chicken Noodle Soup",
    description: "Comforting homemade soup with tender chicken and vegetables.",
    servings: 6,
    ingredients: [
      {name: "chicken breast", quantity: "1", unit: "lb"},
      {name: "egg noodles", quantity: "8", unit: "oz"},
      {name: "carrots", quantity: "3", unit: null},
      {name: "celery", quantity: "3", unit: "stalks"},
      {name: "chicken broth", quantity: "8", unit: "cups"}
    ],
    instructions: [
      "Bring broth to boil with chicken.",
      "Simmer until chicken is cooked, 15 minutes.",
      "Remove chicken, shred, and return to pot.",
      "Add vegetables and noodles.",
      "Cook until noodles are tender."
    ],
    dietaryAttributes: [],
    preparationTime: 15,
    cookingTime: 30
  },
  {
    title: "Caprese Salad",
    description: "Simple Italian salad with tomatoes, mozzarella, and basil.",
    servings: 4,
    ingredients: [
      {name: "tomatoes", quantity: "4", unit: "large"},
      {name: "fresh mozzarella", quantity: "1", unit: "lb"},
      {name: "fresh basil", quantity: "1", unit: "bunch"},
      {name: "balsamic glaze", quantity: "3", unit: "tbsp"},
      {name: "olive oil", quantity: "3", unit: "tbsp"}
    ],
    instructions: [
      "Slice tomatoes and mozzarella into rounds.",
      "Arrange alternating slices on a platter.",
      "Tuck basil leaves between slices.",
      "Drizzle with olive oil and balsamic glaze."
    ],
    dietaryAttributes: ["vegetarian", "gluten-free"],
    preparationTime: 10,
    cookingTime: 0
  },
  {
    title: "Beef Stew",
    description: "Hearty slow-cooked stew with tender beef and root vegetables.",
    servings: 6,
    ingredients: [
      {name: "beef chuck", quantity: "2", unit: "lbs"},
      {name: "potatoes", quantity: "4", unit: null},
      {name: "carrots", quantity: "4", unit: null},
      {name: "onion", quantity: "1", unit: "large"},
      {name: "beef broth", quantity: "4", unit: "cups"}
    ],
    instructions: [
      "Brown beef in large pot.",
      "Add vegetables and broth.",
      "Bring to boil, then reduce to simmer.",
      "Cook covered for 2 hours until tender.",
      "Season and serve hot."
    ],
    dietaryAttributes: ["gluten-free"],
    preparationTime: 20,
    cookingTime: 120
  },
  {
    title: "Avocado Toast",
    description: "Trendy breakfast with mashed avocado on toasted sourdough.",
    servings: 2,
    ingredients: [
      {name: "sourdough bread", quantity: "4", unit: "slices"},
      {name: "avocados", quantity: "2", unit: null},
      {name: "lemon juice", quantity: "1", unit: "tbsp"},
      {name: "red pepper flakes", quantity: "0.5", unit: "tsp"},
      {name: "sea salt", quantity: "1", unit: "pinch"}
    ],
    instructions: [
      "Toast bread until golden.",
      "Mash avocado with lemon juice and salt.",
      "Spread avocado on toast.",
      "Sprinkle with red pepper flakes."
    ],
    dietaryAttributes: ["vegan"],
    preparationTime: 5,
    cookingTime: 3
  },
  {
    title: "Shrimp Scampi",
    description: "Garlic butter shrimp with white wine and lemon over pasta.",
    servings: 4,
    ingredients: [
      {name: "shrimp", quantity: "1", unit: "lb"},
      {name: "linguine", quantity: "1", unit: "lb"},
      {name: "garlic", quantity: "6", unit: "cloves"},
      {name: "white wine", quantity: "0.5", unit: "cup"},
      {name: "butter", quantity: "4", unit: "tbsp"}
    ],
    instructions: [
      "Cook linguine according to package.",
      "Sauté garlic in butter and oil.",
      "Add shrimp and cook 2 minutes per side.",
      "Add wine and lemon juice.",
      "Toss with pasta and serve."
    ],
    dietaryAttributes: [],
    preparationTime: 10,
    cookingTime: 12
  },
  {
    title: "Greek Yogurt Parfait",
    description: "Layered yogurt with granola and fresh berries.",
    servings: 2,
    ingredients: [
      {name: "Greek yogurt", quantity: "2", unit: "cups"},
      {name: "granola", quantity: "1", unit: "cup"},
      {name: "mixed berries", quantity: "1", unit: "cup"},
      {name: "honey", quantity: "2", unit: "tbsp"},
      {name: "mint leaves", quantity: "4", unit: null}
    ],
    instructions: [
      "Layer yogurt in glasses.",
      "Add granola and berries.",
      "Repeat layers.",
      "Drizzle with honey and garnish with mint."
    ],
    dietaryAttributes: ["vegetarian", "gluten-free"],
    preparationTime: 5,
    cookingTime: 0
  },
  {
    title: "Pulled Pork Sandwich",
    description: "Slow-cooked BBQ pork on a toasted bun with coleslaw.",
    servings: 8,
    ingredients: [
      {name: "pork shoulder", quantity: "4", unit: "lbs"},
      {name: "BBQ sauce", quantity: "2", unit: "cups"},
      {name: "hamburger buns", quantity: "8", unit: null},
      {name: "coleslaw", quantity: "2", unit: "cups"},
      {name: "pickles", quantity: "1", unit: "cup"}
    ],
    instructions: [
      "Season pork and place in slow cooker.",
      "Cook on low for 8 hours.",
      "Shred pork and mix with BBQ sauce.",
      "Serve on buns with coleslaw."
    ],
    dietaryAttributes: [],
    preparationTime: 15,
    cookingTime: 480
  },
  {
    title: "Vegetarian Chili",
    description: "Hearty bean chili with peppers and warming spices.",
    servings: 6,
    ingredients: [
      {name: "black beans", quantity: "2", unit: "cans"},
      {name: "kidney beans", quantity: "1", unit: "can"},
      {name: "diced tomatoes", quantity: "2", unit: "cans"},
      {name: "bell peppers", quantity: "2", unit: null},
      {name: "chili powder", quantity: "3", unit: "tbsp"}
    ],
    instructions: [
      "Sauté onions and peppers.",
      "Add beans, tomatoes, and spices.",
      "Simmer for 30 minutes.",
      "Serve with toppings of choice."
    ],
    dietaryAttributes: ["vegan", "gluten-free"],
    preparationTime: 10,
    cookingTime: 35
  },
  {
    title: "Salmon Teriyaki",
    description: "Glazed salmon with sweet and savory teriyaki sauce.",
    servings: 4,
    ingredients: [
      {name: "salmon fillets", quantity: "4", unit: null},
      {name: "teriyaki sauce", quantity: "0.5", unit: "cup"},
      {name: "sesame seeds", quantity: "1", unit: "tbsp"},
      {name: "green onions", quantity: "2", unit: null},
      {name: "ginger", quantity: "1", unit: "tbsp"}
    ],
    instructions: [
      "Marinate salmon in teriyaki for 30 minutes.",
      "Bake at 400°F for 12-15 minutes.",
      "Brush with more sauce halfway through.",
      "Garnish with sesame seeds and green onions."
    ],
    dietaryAttributes: ["gluten-free"],
    preparationTime: 35,
    cookingTime: 15
  },
  {
    title: "French Onion Soup",
    description: "Rich caramelized onion soup with melted Gruyère.",
    servings: 4,
    ingredients: [
      {name: "yellow onions", quantity: "4", unit: "large"},
      {name: "beef broth", quantity: "6", unit: "cups"},
      {name: "Gruyère cheese", quantity: "1", unit: "cup"},
      {name: "baguette", quantity: "1", unit: null},
      {name: "butter", quantity: "4", unit: "tbsp"}
    ],
    instructions: [
      "Caramelize onions in butter, 40 minutes.",
      "Add broth and simmer 20 minutes.",
      "Toast baguette slices.",
      "Top soup with bread and cheese.",
      "Broil until cheese is bubbly."
    ],
    dietaryAttributes: [],
    preparationTime: 15,
    cookingTime: 65
  },
  {
    title: "Spinach Artichoke Dip",
    description: "Creamy, cheesy dip perfect for entertaining.",
    servings: 8,
    ingredients: [
      {name: "cream cheese", quantity: "8", unit: "oz"},
      {name: "spinach", quantity: "2", unit: "cups"},
      {name: "artichoke hearts", quantity: "1", unit: "can"},
      {name: "mozzarella", quantity: "1", unit: "cup"},
      {name: "Parmesan", quantity: "0.5", unit: "cup"}
    ],
    instructions: [
      "Mix cream cheese with cheeses.",
      "Fold in spinach and chopped artichokes.",
      "Transfer to baking dish.",
      "Bake at 350°F for 25 minutes until bubbly."
    ],
    dietaryAttributes: ["vegetarian", "gluten-free"],
    preparationTime: 10,
    cookingTime: 25
  },
  {
    title: "Chicken Fajitas",
    description: "Sizzling chicken and peppers with warm tortillas.",
    servings: 4,
    ingredients: [
      {name: "chicken breast", quantity: "1.5", unit: "lbs"},
      {name: "bell peppers", quantity: "3", unit: null},
      {name: "onion", quantity: "1", unit: "large"},
      {name: "fajita seasoning", quantity: "2", unit: "tbsp"},
      {name: "flour tortillas", quantity: "8", unit: null}
    ],
    instructions: [
      "Slice chicken and vegetables into strips.",
      "Cook chicken until done, set aside.",
      "Sauté peppers and onions.",
      "Add chicken back with seasoning.",
      "Serve with warm tortillas."
    ],
    dietaryAttributes: [],
    preparationTime: 15,
    cookingTime: 15
  },
  {
    title: "Banana Bread",
    description: "Moist, sweet bread made with overripe bananas.",
    servings: 10,
    ingredients: [
      {name: "ripe bananas", quantity: "3", unit: null},
      {name: "flour", quantity: "2", unit: "cups"},
      {name: "sugar", quantity: "0.75", unit: "cup"},
      {name: "eggs", quantity: "2", unit: null},
      {name: "butter", quantity: "0.5", unit: "cup"}
    ],
    instructions: [
      "Mash bananas in a bowl.",
      "Mix in melted butter, eggs, and sugar.",
      "Stir in flour and baking soda.",
      "Pour into greased loaf pan.",
      "Bake at 350°F for 60 minutes."
    ],
    dietaryAttributes: ["vegetarian"],
    preparationTime: 15,
    cookingTime: 60
  },
  {
    title: "Cobb Salad",
    description: "Protein-packed salad with chicken, bacon, and blue cheese.",
    servings: 4,
    ingredients: [
      {name: "romaine lettuce", quantity: "1", unit: "head"},
      {name: "grilled chicken", quantity: "2", unit: "cups"},
      {name: "bacon", quantity: "6", unit: "slices"},
      {name: "hard-boiled eggs", quantity: "2", unit: null},
      {name: "blue cheese", quantity: "0.5", unit: "cup"}
    ],
    instructions: [
      "Chop lettuce and arrange on plates.",
      "Top with rows of chicken, bacon, eggs.",
      "Add avocado, tomatoes, and cheese.",
      "Drizzle with dressing of choice."
    ],
    dietaryAttributes: ["gluten-free"],
    preparationTime: 15,
    cookingTime: 0
  },
  {
    title: "Pad Thai",
    description: "Classic Thai noodles with tamarind sauce and peanuts.",
    servings: 4,
    ingredients: [
      {name: "rice noodles", quantity: "8", unit: "oz"},
      {name: "shrimp", quantity: "1", unit: "lb"},
      {name: "tamarind paste", quantity: "2", unit: "tbsp"},
      {name: "peanuts", quantity: "0.5", unit: "cup"},
      {name: "bean sprouts", quantity: "1", unit: "cup"}
    ],
    instructions: [
      "Soak noodles in warm water 30 minutes.",
      "Make sauce with tamarind, fish sauce, sugar.",
      "Stir fry shrimp, then add noodles.",
      "Toss with sauce and top with peanuts."
    ],
    dietaryAttributes: ["gluten-free"],
    preparationTime: 35,
    cookingTime: 10
  },
  {
    title: "Minestrone Soup",
    description: "Italian vegetable soup with pasta and beans.",
    servings: 6,
    ingredients: [
      {name: "diced tomatoes", quantity: "1", unit: "can"},
      {name: "kidney beans", quantity: "1", unit: "can"},
      {name: "small pasta", quantity: "1", unit: "cup"},
      {name: "mixed vegetables", quantity: "3", unit: "cups"},
      {name: "vegetable broth", quantity: "6", unit: "cups"}
    ],
    instructions: [
      "Sauté onions, carrots, and celery.",
      "Add broth, tomatoes, and beans.",
      "Simmer 20 minutes.",
      "Add pasta and cook until tender.",
      "Season with Italian herbs."
    ],
    dietaryAttributes: ["vegan"],
    preparationTime: 10,
    cookingTime: 30
  },
  {
    title: "Apple Pie",
    description: "Classic American dessert with flaky crust and cinnamon apples.",
    servings: 8,
    ingredients: [
      {name: "pie crusts", quantity: "2", unit: null},
      {name: "apples", quantity: "6", unit: "large"},
      {name: "sugar", quantity: "0.75", unit: "cup"},
      {name: "cinnamon", quantity: "1", unit: "tsp"},
      {name: "butter", quantity: "2", unit: "tbsp"}
    ],
    instructions: [
      "Peel and slice apples.",
      "Mix with sugar, cinnamon, and flour.",
      "Place in pie crust, dot with butter.",
      "Cover with top crust and crimp edges.",
      "Bake at 375°F for 50 minutes."
    ],
    dietaryAttributes: ["vegetarian"],
    preparationTime: 20,
    cookingTime: 50
  },
  {
    title: "Eggs Benedict",
    description: "Poached eggs with hollandaise sauce on English muffins.",
    servings: 4,
    ingredients: [
      {name: "eggs", quantity: "8", unit: null},
      {name: "English muffins", quantity: "4", unit: null},
      {name: "Canadian bacon", quantity: "8", unit: "slices"},
      {name: "butter", quantity: "0.5", unit: "cup"},
      {name: "lemon juice", quantity: "1", unit: "tbsp"}
    ],
    instructions: [
      "Make hollandaise sauce with egg yolks and butter.",
      "Poach eggs in simmering water.",
      "Toast English muffins.",
      "Layer with bacon, poached egg, and sauce."
    ],
    dietaryAttributes: [],
    preparationTime: 15,
    cookingTime: 15
  },
  {
    title: "Veggie Burger",
    description: "Hearty plant-based burger with black beans and quinoa.",
    servings: 4,
    ingredients: [
      {name: "black beans", quantity: "1", unit: "can"},
      {name: "cooked quinoa", quantity: "1", unit: "cup"},
      {name: "breadcrumbs", quantity: "0.5", unit: "cup"},
      {name: "egg", quantity: "1", unit: null},
      {name: "burger buns", quantity: "4", unit: null}
    ],
    instructions: [
      "Mash beans in a bowl.",
      "Mix in quinoa, breadcrumbs, and egg.",
      "Form into 4 patties.",
      "Cook on griddle 4 minutes per side.",
      "Serve on buns with toppings."
    ],
    dietaryAttributes: ["vegetarian"],
    preparationTime: 15,
    cookingTime: 10
  }
];

// Recipe photo assets (randomly assigned to recipes)
const recipeImages = [
  "recipe-photo-1",
  "recipe-photo-2",
  "recipe-photo-3",
  "recipe-photo-4",
  "recipe-photo-5"
];

const categories = [
  "Breakfast", "Lunch", "Dinner", "Desserts", "Snacks",
  "Appetizers", "Soups", "Salads", "Pasta", "Seafood",
  "Grilling", "Baking", "Slow Cooker", "Instant Pot", "Air Fryer",
  "Mexican", "Chinese", "Japanese", "Indian", "Thai",
  "French", "Greek", "Korean", "Vietnamese", "Mediterranean",
  "Italian", "Spanish", "Middle Eastern", "Caribbean", "Brazilian",
  "Healthy", "Keto", "Paleo", "Whole30", "Low Carb",
  "Budget Meals", "Family Favorites", "Date Night", "Party Food", "Holiday",
  "Summer", "Winter", "Fall", "Spring", "Comfort Food"
];

const adjectives = [
  "Classic", "Modern", "Quick", "Easy", "Gourmet",
  "Homestyle", "Traditional", "Authentic", "Fusion", "Creative",
  "Simple", "Elegant", "Rustic", "Fresh", "Bold",
  "Healthy", "Delicious", "Savory", "Sweet", "Spicy"
];

function generateCookbookUUID(index) {
  const part1 = index.toString(16).padStart(7, '0');
  const part2 = index.toString(16).padStart(12, '0');
  return `c${part1}-0000-0000-0000-${part2}`;
}

function generateRecipeUUID(cookbookIndex, recipeIndex) {
  // Use cookbook index in first part, recipe index in second part
  const part1 = cookbookIndex.toString(16).padStart(7, '0');
  const part2 = recipeIndex.toString(16).padStart(12, '0');
  return `a${part1}-0000-0000-0000-${part2}`;
}

function generateIngredientUUID(cookbookIndex, recipeIndex, ingredientIndex) {
  const part1 = (cookbookIndex * 1000 + recipeIndex).toString(16).padStart(7, '0');
  const part2 = ingredientIndex.toString(16).padStart(12, '0');
  return `b${part1}-0000-0000-0000-${part2}`;
}

// Shuffle array helper
function shuffleArray(array) {
  const shuffled = [...array];
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
  }
  return shuffled;
}

function generateRecipesForCookbook(cookbookIndex, count) {
  const recipes = [];
  const shuffledTemplates = shuffleArray(baseRecipeTemplates);

  for (let i = 0; i < count; i++) {
    // Cycle through shuffled templates
    const template = shuffledTemplates[i % shuffledTemplates.length];

    // Generate unique IDs for this recipe
    const recipeId = generateRecipeUUID(cookbookIndex, i + 1);

    // Generate ingredients with unique IDs
    const ingredients = template.ingredients.map((ing, idx) => ({
      id: generateIngredientUUID(cookbookIndex, i + 1, idx + 1),
      name: ing.name,
      quantity: ing.quantity,
      unit: ing.unit
    }));

    recipes.push({
      id: recipeId,
      title: template.title,
      description: template.description,
      servings: template.servings,
      ingredients: ingredients,
      instructions: template.instructions,
      dietaryAttributes: template.dietaryAttributes,
      imageURL: recipeImages[Math.floor(Math.random() * recipeImages.length)],
      preparationTime: template.preparationTime,
      cookingTime: template.cookingTime
    });
  }

  return recipes;
}

function generateCookbooks(count, minRecipes = 30, maxRecipes = 60) {
  const cookbooks = [];

  for (let i = 1; i <= count; i++) {
    const category = categories[i % categories.length];
    const adjective = adjectives[i % adjectives.length];

    // Randomize number of recipes between min and max
    const recipeCount = Math.floor(Math.random() * (maxRecipes - minRecipes + 1)) + minRecipes;

    const cookbook = {
      id: generateCookbookUUID(i),
      name: `${adjective} ${category} #${i}`,
      description: `A collection of ${adjective.toLowerCase()} ${category.toLowerCase()} recipes`,
      coverImageURL: null,
      recipes: generateRecipesForCookbook(i, recipeCount)
    };

    cookbooks.push(cookbook);

    // Log progress every 100 cookbooks
    if (i % 100 === 0) {
      console.log(`Generated ${i}/${count} cookbooks...`);
    }
  }

  return cookbooks;
}

// Generate 1000 cookbooks with 30-60 recipes each (randomized)
console.log('🚀 Starting cookbook generation...');
const cookbooks = generateCookbooks(1000, 30, 60);

// Write to JSON file
const outputPath = path.join(__dirname, 'RecimeChallenge', 'Resources', 'recipes.json');
fs.writeFileSync(outputPath, JSON.stringify(cookbooks, null, 2));

// Calculate total recipes
const totalRecipes = cookbooks.reduce((sum, cb) => sum + cb.recipes.length, 0);

console.log(`\n✅ Generated ${cookbooks.length} cookbooks`);
console.log(`📚 ${totalRecipes} total recipes (30-60 per cookbook)`);
console.log(`📝 Saved to: ${outputPath}`);
console.log(`📊 File size: ${(fs.statSync(outputPath).size / 1024 / 1024).toFixed(2)} MB`);
