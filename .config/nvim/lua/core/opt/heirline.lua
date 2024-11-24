local config = {}
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local colors = V.opt("colors")
config.opts = {
  colors = colors,
  disable_winbar_cb = function(_)
    return true
  end,
}

local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode():sub(1, 1)
  end,

  static = {
    mode_names = {
      n = "Normal",
      v = "Visual",
      V = "V-Line",
      ["\22"] = "V-Block",
      s = "Select",
      S = "S-Line",
      ["\19"] = "S-Block",
      i = "Insert",
      c = "Command",
      R = "Replace",
      r = "Prompt",
      ["!"] = "Shell",
      t = "Terminal",
    },
    mode_colors = {
      n = "green",
      i = "blue",
      v = "violet",
      V = "violet",
      ["\22"] = "violet",
      c = "orange",
      s = "cyan",
      S = "cyan",
      ["\19"] = "cyan",
      R = "red",
      r = "yellow",
      ["!"] = "green",
      t = "green",
    },
    mode_icons = {
      n = " ",
      i = " ",
      v = "󰒉 ",
      V = " ",
      ["\22"] = "󰿦 ",
      c = " ",
      s = "󰒇 ",
      S = " ",
      ["\19"] = "󰲏 ",
      R = " ",
      r = " ",
      ["!"] = " ",
      t = " ",
    },
  },

  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },

  {
    {
      provider = function(self)
        return " " .. self.mode_icons[self.mode] .. " " .. self.mode_names[self.mode] .. " "
      end,
      hl = function(self)
        return { fg = self.mode_colors[self.mode] }
      end,
    },
  },
}

local File = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    if self.filename then
      local extension = vim.fn.fnamemodify(self.filename, ":e")
      self.icon, self.color = require("nvim-web-devicons").get_icon_color(self.filename, extension, { default = true })
    end
  end,

  condition = function()
    local name = vim.api.nvim_buf_get_name(0)
    return name and name ~= ""
  end,

  {
    {
      provider = function(self)
        return self.icon .. " "
      end,
      hl = function(self)
        return { fg = self.color }
      end,
    },

    {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if not conditions.width_percent_below(#filename, 0.25) then
          filename = vim.fn.pathshorten(filename)
        end
        return filename .. " "
      end,
      hl = function(self)
        return { fg = self.color }
      end,

      {
        {
          provider = " ",
          condition = function()
            return vim.bo.modified
          end,
          hl = { fg = "green" },
        },

        {
          provider = " ",
          condition = function()
            return vim.bo.readonly or not vim.bo.modifiable
          end,
          hl = { fg = "yellow" },
        },
      },
    },
  },
}

local LspClients = {
  condition = conditions.lsp_attached,
  update = { "LspAttach", "LspDetach" },

  static = {
    custom_color = {
      lua_ls = "blue",
      jsonls = "yellow",
      cssls = "blue",
      html = "orange",
      intelephense = "purple",
      emmet_ls = "green",
      tailwindcss = "blue",
      bashls = "green",
      rust_analyzer = "orange",
      dartls = "blue",
    },
    custom_icon = {
      lua_ls = "󰢱 ",
      jsonls = "󰘦 ",
      cssls = " ",
      html = " ",
      intelephense = " ",
      emmet_ls = " ",
      tailwindcss = "󱏿 ",
      bashls = " ",
      rust_analyzer = " ",
      dartls = " ",
    },
  },

  init = function(self)
    local children = {}
    for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local icon = self.custom_icon[server.name] or " "
      local color = self.custom_color[server.name] or "green"
      local child = {
        {
          { provider = icon, hl = { fg = color } },
          { provider = server.name, hl = { fg = color } },
          { provider = ":", hl = { fg = "fg" } },
          { provider = server.id .. " ", hl = { fg = "yellow" } },
        },
      }
      table.insert(children, child)
    end
    self.child = self:new(children, 1)
  end,

  provider = function(self)
    return self.child:eval()
  end,
}

local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,
  {
    {
      provider = function()
        return " "
      end,
      hl = { fg = "orange" },
    },
    {
      provider = function(self)
        return self.status_dict.head
      end,
      hl = { bold = true, fg = "orange" },

      {
        condition = function(self)
          return self.has_changes
        end,
        provider = "(",
      },
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and ("+" .. count)
        end,
        hl = { fg = "git_add" },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and ("-" .. count)
        end,
        hl = { fg = "git_del" },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and ("~" .. count)
        end,
        hl = { fg = "git_change" },
      },
      {
        condition = function(self)
          return self.has_changes
        end,
        provider = ")",
      },
    },
  },
}

local diag = function(name, icon_name, color)
  return {
    condition = function(self)
      return self[name] > 0
    end,
    {
      {
        provider = function(self)
          return self[icon_name]
        end,
        hl = { fg = color, bold = true },
      },
      {
        provider = function(self)
          return self[name] .. " "
        end,
        hl = { fg = color, bold = true },
      },
    },
  }
end

local Diagnostics = {
  condition = conditions.has_diagnostics,
  static = {
    -- error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
    -- warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
    -- info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    -- hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    error_icon = " ",
    warn_icon = " ",
    info_icon = " ",
    hint_icon = " ",
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  update = { "DiagnosticChanged", "BufEnter" },

  diag("errors", "error_icon", "red"),
  diag("warnings", "warn_icon", "yellow"),
  diag("info", "info_icon", "blue"),
  diag("hints", "hint_icon", "violet"),
}

local Ruler = {
  { provider = "%l", hl = { fg = "blue" } },
  { provider = "/", hl = { fg = "yellow" } },
  { provider = "%L", hl = { fg = "red" } },
  { provider = ":", hl = { fg = "yellow" } },
  { provider = "%c", hl = { fg = "green" } },
  {
    provider = function()
      local percentage = "0"
      local buflines = vim.api.nvim_buf_line_count(0)
      local curline = vim.api.nvim_win_get_cursor(0)[1]
      percentage = tostring(math.floor((curline / buflines) * 100))
      return " " .. percentage .. "%%"
    end,
    hl = { fg = "orange" },
  },
}

local ScrollBar = {
  static = {
    sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = { fg = "blue", bg = "bg2" },
}

local TablineBufnr = {
  provider = function(self)
    return tostring(self.bufnr) .. ". "
  end,
  hl = "Comment",
}

local TablineFileName = {
  provider = function(self)
    local filename = self.filename
    filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
    return filename
  end,
  hl = function(self)
    return { bold = self.is_active or self.is_visible, italic = true }
  end,
}

local TablineFileFlags = {
  {
    condition = function(self)
      return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
    end,
    provider = "  ",
    hl = { fg = "green" },
  },
  {
    condition = function(self)
      return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
        or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
    end,
    provider = function(self)
      if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
        return "  "
      else
        return "  "
      end
    end,
    hl = { fg = "orange" },
  },
}

local TablineFileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return { bg = "bg0", fg = "fg", bold = true, italic = true }
    else
      return { bg = "black", fg = "fg" }
    end
  end,
  on_click = {
    callback = function(_, minwid, _, button)
      if button == "m" then
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
        end)
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = "heirline_tabline_buffer_callback",
  },
  { provider = " " },
  TablineBufnr,
  {
    init = function(self)
      if self.filename then
        local extension = vim.fn.fnamemodify(self.filename, ":e")
        self.icon, self.color =
          require("nvim-web-devicons").get_icon_color(self.filename, extension, { default = true })
      end
    end,
    provider = function(self)
      return self.icon .. " "
    end,
    hl = function(self)
      return { fg = self.color }
    end,
  },
  TablineFileName,
  TablineFileFlags,
}

local TablineCloseButton = {
  condition = function(self)
    return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
  end,
  { provider = " " },
  {
    provider = " X ",
    hl = { fg = "red" },
    on_click = {
      callback = function(_, minwid)
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
          vim.cmd.redrawtabline()
        end)
      end,
      minwid = function(self)
        return self.bufnr
      end,
      name = "heirline_tabline_close_buffer_callback",
    },
  },
}

local TablineBufferBlock = {
  hl = function(self)
    return { bg = self.is_active and "bg0" or "black" }
  end,
  { TablineFileNameBlock, TablineCloseButton },
}

local BufferLine = utils.make_buflist(
  TablineBufferBlock,
  { provider = "", hl = { fg = "gray" } },
  { provider = "", hl = { fg = "gray" } }
)

local navic = require("nvim-navic")
local NavicLabel = {
  { provider = " ", hl = { fg = "blue" } },
  {
    provider = " Navic",
    hl = { fg = "blue" },
  },
}

local Navic = {
  condition = function()
    return navic.is_available()
  end,
  static = {
    enc = function(line, col, winnr)
      return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
    end,
    dec = function(c)
      local line = bit.rshift(c, 16)
      local col = bit.band(bit.rshift(c, 6), 1023)
      local winnr = bit.band(c, 63)
      return line, col, winnr
    end,
  },
  init = function(self)
    local children = {}
    local data = require("nvim-navic").get_data() or {}
    for i, d in ipairs(data) do
      local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
      local child = {
        {
          provider = d.icon,
          hl = { fg = utils.get_highlight("NavicIcons" .. d.type).fg },
        },
        {
          provider = d.name:gsub("%%", "%%%%"),

          on_click = {
            minwid = pos,
            callback = function(_, minwid)
              local line, col, winnr = self.dec(minwid)
              vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
            end,
            name = "heirline_navic",
          },
        },
      }
      if #data > 1 and i < #data then
        table.insert(child, {
          provider = " -> ",
          hl = { fg = "cyan" },
        })
      end
      table.insert(children, child)
    end
    self.child = self:new(children, 1)
  end,
  provider = function(self)
    return self.child:eval()
  end,
}

config.statusline = {
  hl = { fg = "fg" },
  ViMode,
  { provider = " " },
  File,
  { provider = " " },
  Git,
  { provider = "%=" },
  Diagnostics,
  { provider = " " },
  LspClients,
  { provider = " " },
  Ruler,
  { provider = " " },
  ScrollBar,
}
config.winbar = {
  hl = { bg = "bg0", fg = "fg" },
  NavicLabel,
  { provider = " " },
  Navic,
  { provider = "%=" },
}
config.tabline = {
  hl = { bg = "black", fg = "fg" },
  BufferLine,
  { provider = "%=" },
}

return config
