-- inspiration: https://u.peppe.rs/bF.png
local down2 = "#13091C"
local down1 = "#1A0C26"
local base = "#200F2F"
local up1 = "#2B1B39"
local up2 = "#362744"

local text0 = "#F2ECF7"
local text1 = "#C3B1D3"
local text2 = "#AD96C1"
local text3 = "#9980AF"
local text4 = "#88709E"

local passive = "#9AF2E9"
local active = "#EEB683"
local error = "#E57D8B"

vim.api.nvim_create_user_command("HighlightUnderCursor", function()
  print(vim.inspect(vim.treesitter.get_captures_at_cursor(0)))
end, {})

-- highlights
local hl = {
  -- ui
  Normal = { bg = base, fg = text0 },
  EndOfBuffer = { link = "Normal" },
  SignColumn = { link = "Normal" },
  LineNr = { fg = text4 },
  CursorLineNr = { fg = text1 },
  Search = { bg = up2 },
  CurSearch = { fg = active, bg = up2 },
  CursorColumn = { bg = up1 },
  CursorLine = { bg = up1 },
  Visual = { bg = up2 },
  StatusLine = { link = "Normal" },
  StatusLineNC = { bg = base, fg = text4 },
  WinBar = { link = "Normal" },
  WinBarNC = { link = "Normal" },
  Pmenu = { bg = down1 },
  PmenuSel = { bg = up1 },
  PmenuKind = { bg = down1 },
  PmenuKindSel = { bg = up1, fg = passive },
  PmenuSbar = { bg = down2 },
  PmenuThumb = { bg = up1 },
  Title = { fg = passive },
  NonText = { fg = text4 },
  DiagnosticError = { fg = error },
  DiagnosticWarn = { fg = active },
  DiagnosticInfo = { fg = passive },
  DiagnosticHint = { fg = text0 },
  DiagnosticOk = { link = "DiagnosticHint" },
  DiffAdd = { fg = passive },
  diffAdded = { link = "DiffAdd" },
  DiffChange = { fg = active },
  diffChanged = { link = "DiffChange" },
  DiffDelete = { fg = error },
  diffRemoved = { link = "DiffDelete" },

  -- names
  Identifier = { fg = text0 },
  Function = { link = "Identifier" },
  PreProc = { link = "Identifier" },
  Type = { link = "Identifier" },

  -- values
  Constant = { fg = passive },
  Underlined = { link = "Constant" },

  -- syntax
  Statement = { fg = text0, bold = true },
  Comment = { fg = text4 },

  -- punctuation
  Special = { fg = text2 },
  operator = { fg = text3 },

  -- informational
  Error = { fg = error },
  ErrorMsg = { link = "Error" },
  Todo = { fg = passive },
  WarningMsg = { fg = active },

  -- telescope
  TelescopeBorder = { fg = down1, bg = down1 },
  TelescopeNormal = { fg = text0, bg = down1 },
}

for group, args in pairs(hl) do
  vim.api.nvim_set_hl(0, group, args)
end

-- statusline
local lualine_pigeon_theme = function()
  local tinted = function(c)
    return {
      a = { bg = base, fg = c },
      b = { bg = base, fg = c },
      c = { bg = base, fg = c },
    }
  end
  return {
    normal = tinted(text4),
    insert = tinted(active),
    visual = tinted(passive),
    replace = tinted(error),
    command = tinted(text0),
    inactive = tinted(text4),
  }
end

require("lualine").setup({
  options = {
    theme = lualine_pigeon_theme(),
    icons_enabled = false,
    fmt = string.lower,
    section_separators = { "   ", "   " },
    component_separators = { " ", " " },
    globalstatus = true,
  },
  sections = {
    lualine_a = { { "filename", symbols = { modified = "⬤" } } },
    lualine_b = { "branch", { "diff", colored = true } },
    lualine_c = { "searchcount", { "diagostics", sources = { "nvim_lsp" } } },
    lualine_x = { require("lsp-progress").progress },
    lualine_y = { "filetype", { "swenv", color = { fg = text4 } } },
    lualine_z = { "location", "mode" },
  },
})

-- refresh lualine on lsp progress update
vim.api.nvim_create_autocmd(
  "User",
  {
    pattern = "LspProgressStatusUpdated",
    group = vim.api.nvim_create_augroup("LualineLSPProgress", {}),
    callback = function() require("lualine").refresh() end,
  }
)