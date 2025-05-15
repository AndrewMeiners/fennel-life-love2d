-- main.lua
local fennel = require("fennel")
fennel.path = "./?.fnl"
table.insert(package.loaders or package.searchers, fennel.searcher)
require("game")
