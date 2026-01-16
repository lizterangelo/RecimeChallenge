const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

function findChrome() {
  // Check Render's cache location
  const renderCachePath = '/opt/render/.cache/puppeteer/chrome';
  if (fs.existsSync(renderCachePath)) {
    const versions = fs.readdirSync(renderCachePath);
    if (versions.length > 0) {
      const chromePath = path.join(renderCachePath, versions[0], 'chrome-linux64', 'chrome');
      if (fs.existsSync(chromePath)) {
        console.log('Found Chrome at:', chromePath);
        return chromePath;
      }
    }
  }
  // Let puppeteer find it automatically
  return undefined;
}

async function scrapeRecipePage(url) {
  let browser;

  try {
    const executablePath = findChrome();
    browser = await puppeteer.launch({
      headless: 'new',
      executablePath,
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-accelerated-2d-canvas',
        '--disable-gpu',
        '--window-size=1920x1080'
      ]
    });

    const page = await browser.newPage();

    await page.setUserAgent(
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
    );

    await page.goto(url, {
      waitUntil: 'networkidle2',
      timeout: 30000
    });

    await page.waitForSelector('body', { timeout: 5000 });

    const scrapedData = await page.evaluate(() => {
      // Try to find JSON-LD structured data first
      const jsonLdScripts = document.querySelectorAll('script[type="application/ld+json"]');
      let recipeSchema = null;

      for (const script of jsonLdScripts) {
        try {
          const data = JSON.parse(script.textContent);
          if (data['@type'] === 'Recipe') {
            recipeSchema = data;
            break;
          }
          if (Array.isArray(data)) {
            const recipe = data.find(item => item['@type'] === 'Recipe');
            if (recipe) {
              recipeSchema = recipe;
              break;
            }
          }
          if (data['@graph']) {
            const recipe = data['@graph'].find(item => item['@type'] === 'Recipe');
            if (recipe) {
              recipeSchema = recipe;
              break;
            }
          }
        } catch (e) {
          // Continue to next script
        }
      }

      // Get page title
      const title = document.querySelector('h1')?.innerText ||
                    document.querySelector('[class*="title"]')?.innerText ||
                    document.title;

      // Get meta description
      const metaDescription = document.querySelector('meta[name="description"]')?.content ||
                              document.querySelector('meta[property="og:description"]')?.content;

      // Get main image
      const ogImage = document.querySelector('meta[property="og:image"]')?.content;
      const mainImage = document.querySelector('img[class*="recipe"]')?.src ||
                        document.querySelector('article img')?.src ||
                        ogImage;

      // Get body text for context
      const bodyText = document.body.innerText.substring(0, 10000);

      return {
        url: window.location.href,
        title,
        metaDescription,
        mainImage,
        recipeSchema,
        bodyText
      };
    });

    return scrapedData;
  } finally {
    if (browser) {
      await browser.close();
    }
  }
}

module.exports = { scrapeRecipePage };
