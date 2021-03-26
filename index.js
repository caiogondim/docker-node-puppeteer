const puppeteer = require('puppeteer-core')
const chromePaths = require('chrome-paths')

async function main() {
  const browser = await puppeteer.launch({
    executablePath: chromePaths.chrome,
    headless: false
  })
  const page = await browser.newPage()
  await page.goto('https://nytimes.com')

  //
  const firstArticleOnSpotlight = await page.$('[data-block-tracking-id="Spotlight"] h3')
  const firstArticleOnSpotlightText = await firstArticleOnSpotlight.evaluate(node => node.innerText)
  console.log(`NYT first article on spotlight: '${firstArticleOnSpotlightText}'`)

  await browser.close()
}

main()