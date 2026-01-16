const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

function findChrome() {
  // Possible Chrome cache locations
  const cachePaths = [
    // Explicit chrome-cache directory (set by build script)
    path.join(__dirname, '..', 'chrome-cache', 'chrome'),
    // Project's node_modules cache
    path.join(__dirname, '..', 'node_modules', '.cache', 'puppeteer', 'chrome'),
    // Render's default cache location
    '/opt/render/.cache/puppeteer/chrome',
  ];

  for (const cachePath of cachePaths) {
    if (fs.existsSync(cachePath)) {
      try {
        const versions = fs.readdirSync(cachePath);
        if (versions.length > 0) {
          // Try linux path first, then mac path
          const linuxPath = path.join(cachePath, versions[0], 'chrome-linux64', 'chrome');
          const macPath = path.join(cachePath, versions[0], 'chrome-mac-x64', 'Google Chrome for Testing.app', 'Contents', 'MacOS', 'Google Chrome for Testing');

          if (fs.existsSync(linuxPath)) {
            console.log('Found Chrome at:', linuxPath);
            return linuxPath;
          }
          if (fs.existsSync(macPath)) {
            console.log('Found Chrome at:', macPath);
            return macPath;
          }
        }
      } catch (e) {
        console.log('Error checking cache path:', cachePath, e.message);
      }
    }
  }

  console.log('Chrome not found in cache, letting puppeteer find it automatically');
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
