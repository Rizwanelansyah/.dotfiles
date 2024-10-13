local alphrim, alphsec = "#56A634", "#1788CE"

return {
  style = "darker", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  transparent = true, -- Show/hide background
  term_colors = true, -- Change terminal color as per the selected theme style
  ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden

  -- Change code style ---
  -- Options are italic, bold, underline, none
  -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
  code_style = {
    comments = "italic",
    keywords = "none",
    functions = "none",
    strings = "none",
    variables = "none",
  },

  -- Custom Highlights --
  colors = {},
  highlights = {
    TelescopePromptNormal = {
      bg = "$bg1",
    },
    TelescopePromptBorder = {
      bg = "$bg1",
    },
    TelescopePromptTitle = {
      bg = "$bg1",
    },
    TelescopeResultsTitle = {
      bg = "$bg2",
    },
    TelescopeResultsNormal = {
      bg = "$bg2",
    },
    TelescopeResultsBorder = {
      bg = "$bg2",
    },
    TelescopeSelection = {
      bg = "$bg1",
    },
    TelescopePreviewTitle = {
      bg = "$bg0",
    },
    TelescopePreviewNormal = {
      bg = "$bg0",
    },
    TelescopePreviewBorder = {
      bg = "$bg0",
      fg = "$fg",
    },
    Float = {
      bg = "$bg1",
    },
    debugPC = {
      bg = "none",
      fg = "$green",
    },
    debugBreakpoint = {
      bg = "none",
      fg = "$red",
    },
    AlphaShortcut = { fg = "$red" },
    AlphaText = { fg = "$green" },
    AlphaSeparator = { fg = "$purple" },
    AlphaIcon = { fg = "$blue" },
    AlphaHeaderPrimary = { fg = alphrim },
    AlphaHeaderSecondary = { fg = alphsec },
    AlphaHeaderPriSec = { fg = alphrim, bg = alphsec },
    AlphaHeaderSecPri = { fg = alphsec, bg = alphrim },
    SniprunVirtualTextOk = { fg = "$grey", bg = "none" },
    SniprunVirtualTextErr = { fg = "$red", bg = "none" },
    FoldColumn = { fg = "$blue", bg = "none" },
    CursorLine = { bg = "none" }
},

  -- Plugins Config --
  diagnostics = {
    darker = true,
    undercurl = true,
    background = false,
  },
}
