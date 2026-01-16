async function scrapeRecipePage(url) {
  const response = await fetch('https://api.firecrawl.dev/v1/scrape', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.FIRECRAWL_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      url,
      formats: ['markdown', 'html']
    })
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Firecrawl error: ${error}`);
  }

  const result = await response.json();

  if (!result.success) {
    throw new Error(`Firecrawl failed: ${result.error || 'Unknown error'}`);
  }

  const data = result.data;

  // Extract image from metadata or HTML
  let mainImage = data.metadata?.ogImage || data.metadata?.image;

  // Try to find image in HTML if not in metadata
  if (!mainImage && data.html) {
    const ogImageMatch = data.html.match(/<meta[^>]*property="og:image"[^>]*content="([^"]+)"/i);
    if (ogImageMatch) {
      mainImage = ogImageMatch[1];
    }
  }

  return {
    url: data.metadata?.url || url,
    title: data.metadata?.title || data.metadata?.ogTitle || 'Unknown',
    metaDescription: data.metadata?.description || data.metadata?.ogDescription,
    mainImage,
    recipeSchema: null, // Firecrawl doesn't extract JSON-LD, Gemini will parse from markdown
    bodyText: data.markdown || ''
  };
}

module.exports = { scrapeRecipePage };
