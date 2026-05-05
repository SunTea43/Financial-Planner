const fs = require("fs")
const path = require("path")

const sourceDir = path.join(__dirname, "..", "node_modules", "bootstrap-icons", "font", "fonts")
const targetDir = path.join(__dirname, "..", "app", "assets", "builds", "fonts")

fs.mkdirSync(targetDir, { recursive: true })

for (const fileName of fs.readdirSync(sourceDir)) {
  fs.copyFileSync(path.join(sourceDir, fileName), path.join(targetDir, fileName))
}
