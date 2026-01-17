const { GoogleGenerativeAI } = require('@google/generative-ai');

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const RECIPE_SCHEMA = `
{
  "title": "string (recipe name)",
  "description": "string (brief description of the dish)",
  "servings": "number (serving size, default to 4 if not found)",
  "ingredients": [
    {
      "name": "string (ingredient name)",
      "quantity": "string (amount, e.g., '2', '1/2')",
      "unit": "string or null (e.g., 'cup', 'tbsp', 'lb', null for items like 'eggs')"
    }
  ],
  "instructions": ["string (step-by-step instructions, one step per array item)"],
  "dietaryAttributes": ["string (any of: vegetarian, vegan, glutenFree, dairyFree, nutFree, lowCarb, keto, paleo)"],
  "imageURL": "string or null (main image URL if available)",
  "preparationTime": "number or null (prep time in minutes)",
  "cookingTime": "number or null (cooking time in minutes)"
}
`;

async function parseRecipeWithGemini(scrapedData) {
  const model = genAI.getGenerativeModel({ model: 'gemini-2.5-flash-lite' });

  const prompt = `You are a recipe data extractor. Analyze the following scraped data from a recipe webpage and extract the recipe information into a structured JSON format.

${scrapedData.recipeSchema ? `
STRUCTURED DATA FOUND (JSON-LD):
${JSON.stringify(scrapedData.recipeSchema, null, 2)}
` : ''}

PAGE TITLE: ${scrapedData.title || 'Unknown'}
META DESCRIPTION: ${scrapedData.metaDescription || 'None'}
IMAGE URL: ${scrapedData.mainImage || 'None'}

PAGE CONTENT:
${scrapedData.bodyText}

Extract ONLY THE FIRST/MAIN recipe and return a single JSON object (NOT an array) matching this schema:
${RECIPE_SCHEMA}

Important:
- Return a single JSON object, never an array
- If the page has multiple recipes, only extract the primary/first one
- Parse ingredient amounts carefully (e.g., "2 cups flour" -> quantity: "2", unit: "cup", name: "flour")
- Split instructions into logical steps
- Identify dietary attributes based on ingredients (e.g., no meat = vegetarian, no animal products = vegan)
- Use the image URL from the scraped data if available
- Parse time values from strings like "30 minutes" to just the number 30
- If servings is not specified, default to 4
- Return ONLY the JSON object, no markdown formatting or explanation`;

  const result = await model.generateContent(prompt);
  const response = await result.response;
  const text = response.text();

  // Clean up the response - remove markdown code blocks if present
  let jsonString = text.trim();
  if (jsonString.startsWith('```json')) {
    jsonString = jsonString.slice(7);
  } else if (jsonString.startsWith('```')) {
    jsonString = jsonString.slice(3);
  }
  if (jsonString.endsWith('```')) {
    jsonString = jsonString.slice(0, -3);
  }
  jsonString = jsonString.trim();

  try {
    let recipe = JSON.parse(jsonString);

    // Handle case where Gemini returns an array instead of object
    if (Array.isArray(recipe)) {
      if (recipe.length === 0) {
        throw new Error('Gemini returned empty array');
      }
      console.warn('Gemini returned array, extracting first recipe');
      recipe = recipe[0];
    }

    // Validate required fields
    if (!recipe.title) {
      throw new Error('Recipe title is required');
    }
    if (!recipe.ingredients || recipe.ingredients.length === 0) {
      throw new Error('Recipe must have at least one ingredient');
    }
    if (!recipe.instructions || recipe.instructions.length === 0) {
      throw new Error('Recipe must have at least one instruction');
    }

    // Ensure defaults
    recipe.servings = recipe.servings || 4;
    recipe.description = recipe.description || '';
    recipe.dietaryAttributes = recipe.dietaryAttributes || [];

    return recipe;
  } catch (parseError) {
    console.error('Failed to parse Gemini response:', text);
    throw new Error(`Failed to parse recipe: ${parseError.message}`);
  }
}

module.exports = { parseRecipeWithGemini };
