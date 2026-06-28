module.exports = {
  testEnvironment: "jsdom",
  testMatch: ["<rootDir>/app/javascript/**/*.test.js"],
  moduleNameMapper: {
    "^controllers/(.*)$": "<rootDir>/app/javascript/controllers/$1"
  },
  transform: {
    "^.+\\.js$": "babel-jest"
  }
}
