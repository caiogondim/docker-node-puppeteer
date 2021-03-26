const puppeteer = require('puppeteer-core')
const chromePaths = require('chrome-paths')

function readConf() {
  const conf = {
    executablePath: process.env.E2E_EXECUTABLE_PATH ?? chromePaths.chrome,
  }
  return conf
}

async function main() {
  // Configure puppeteer
  const conf = readConf()
  const browser = await puppeteer.launch(conf)
  const page = await browser.newPage()

  // Fetch first spotlight article title on nytimes.com
  await page.goto('https://nytimes.com')
  const firstArticleOnSpotlight = await page.$('[data-block-tracking-id="Spotlight"] h3')
  const firstArticleOnSpotlightText = await firstArticleOnSpotlight.evaluate(node => node.innerText)
  console.log(`NYT first article on spotlight: '${firstArticleOnSpotlightText}'`)

  // Teardown
  await browser.close()
}

main()