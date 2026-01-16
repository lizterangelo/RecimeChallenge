const express = require('express');
const cors = require('cors');
require('dotenv').config();

const { scrapeRecipePage } = require('./services/scraper');
const { parseRecipeWithGemini } = require('./services/gemini');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.post('/api/scrape', async (req, res) => {
  const { url } = req.body;

  if (!url) {
    return res.status(400).json({ error: 'URL is required' });
  }

  try {
    console.log(`Scraping recipe from: ${url}`);

    const scrapedData = await scrapeRecipePage(url);
    console.log('Scraped data:', JSON.stringify(scrapedData, null, 2).substring(0, 500));

    const recipe = await parseRecipeWithGemini(scrapedData);
    console.log('Parsed recipe:', recipe.title);

    res.json(recipe);
  } catch (error) {
    console.error('Error processing recipe:', error);
    res.status(500).json({
      error: error.message || 'Failed to process recipe'
    });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
