vim.g.mapleader = " "
if vim.g.vscode then
  require("config.vscode")
else
  require("config.standalone")
end