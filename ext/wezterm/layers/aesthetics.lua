local M = {}

local setup_tab_bar = function(config, wez)
  wez.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    -- limit text to max_width-2
    local title = tab.active_pane.title
    if #title > max_width - 4 then
      title = string.sub(title, 1, max_width - 4)
    end

    local palette = config.resolved_palette
    local bg = palette.tab_bar.background
    local fg = tab.is_active and palette.background or palette.tab_bar.inactive_tab.bg_color
    local text = palette.foreground

    return {
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = "" },
      { Background = { Color = fg } },
      { Foreground = { Color = text } },
      { Text = " " .. title .. " " },
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = "" },
    }
  end)

  config.use_fancy_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true
  config.tab_bar_at_bottom = true
end

local catppigeon = function()
  local catppigeon = require("wezterm").color.get_builtin_schemes()["Catppuccin Mocha"]
  catppigeon.background = "#200F2F"
  catppigeon.tab_bar.background = "#0B0510"
  catppigeon.tab_bar.inactive_tab.bg_color = "#150A1F"
  catppigeon.tab_bar.new_tab.bg_color = "#150A1F"
  return catppigeon
end

M.apply = function(config, wez)
  setup_tab_bar(config, wez)

  local colours = function(appearance)
    if appearance:find("Dark") then
      return "Catppigeon Mocha"
    else
      return "Catppuccin Latte"
    end
  end

  config.color_schemes = {
    ["Catppigeon Mocha"] = catppigeon(),
  }
  config.color_scheme = colours(wez.gui.get_appearance())

  config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
  config.font = wez.font("JetBrains Mono", { weight = "Light" })
  config.font_size = string.match(wez.target_triple, "darwin") and 17 or 11
  config.font_rules = {
    {
      intensity = "Bold",
      italic = false,
      font = wez.font("JetBrains Mono", { weight = "ExtraBold" }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wez.font("JetBrains Mono", { weight = "ExtraBold", italic = true }),
    },
  }

  config.window_padding = { top = 32, bottom = 32, left = 32, right = 32 }
  config.use_resize_increments = true
end

return M
