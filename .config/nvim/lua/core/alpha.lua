local quotes = require("utils.quotes")
local str = require("utils.str")

local function colorize(lines, pallete)
  local hl = {}
  local new_lines = {}
  for _, line in ipairs(lines) do
    local line_hl = {}
    local new_line = ""
    local len = #line
    local i = 1
    local col = 1
    local last_col = 0
    while i < len do
      local c = line:sub(i, i)
      local n = line:sub(i + 1, i + 1)
      if c == "%" and n then
        i = i + 2
        local start = col
        local cur_hl = pallete[n] or "Normal"
        while i < len do
          c = line:sub(i, i)
          n = line:sub(i + 1, i + 1)
          if c == "%" and n == "$" then
            i = i + 2
            table.insert(line_hl, {
              cur_hl,
              start - 1,
              col - 1,
            })
            last_col = col
            break
          else
            new_line = new_line .. c
            i = i + 1
            col = col + 1
          end
        end
      else
        new_line = new_line .. c
        i = i + 1
        col = col + 1
      end
    end
    table.insert(new_lines, new_line)
    table.insert(line_hl, { "Normal", last_col, -1 })
    table.insert(hl, line_hl)
  end
  return new_lines, hl
end

local function colored_text(lines, pallete)
  local new_lines, hl = colorize(lines, pallete)

  local res = {
    type = "text",
    val = new_lines,
    opts = {
      position = "center",
      hl = hl,
    },
  }
  return res
end

local separator = " "
local separator_right = " "
---@param icon string
---@param desc string
---@param action? function | string
---@param opts? table
local function button(icon, desc, action, opts)
  opts = opts or {}
  local fmt_desc = str.align(desc, 50, "center")
  local cursor_pos = vim.fn.strchars(icon) + #separator + #fmt_desc:match("^%s*")
  local key = opts.shortcut or (desc and desc:sub(1, 1):lower())
  local mapping = (key and action) and { "n", key, action }
  local lines, hl = colorize({
    string.format(
      "%%i%s%%$ %%s%s%%$ %%d%s%%$ %%s%s%%$ %%k   %s%%$",
      icon,
      separator,
      fmt_desc,
      separator_right,
      key
    ),
  }, {
    i = "AlphaIcon",
    s = "AlphaSeparator",
    d = "AlphaText",
    k = "AlphaShortcut",
  })
  return {
    type = "button",
    val = lines[1],
    on_press = action,
    opts = {
      keymap = opts.keymap or mapping,
      position = opts.position or "center",
      hl = hl[1],
      cursor = cursor_pos - 1,
    },
  }
end

local function text(val, opts)
  opts = opts or {}
  return {
    type = "text",
    val = val,
    opts = {
      position = opts.position or "center",
      hl = opts.hl or "AlphaText",
    },
  }
end

local function recent_files(width, max)
  local home = vim.env.HOME
  local rf = vim.v.oldfiles
  local files = {}
  for i = 1, max do
    if not rf[i] then
      break
    end
    local w = #tostring(max)
    local lines, hl = colorize({
      string.format(
        "%%d[%%$%%n%s%%$%%d]%%$ %%f%s%%$",
        str.align(tostring(i), w, "left"),
        str.limit(
          str.align(vim.fn.fnamemodify(rf[i], ":."):gsub("^" .. home, "~"):gsub("^([^/~])", "./%1"), width, "left"),
          width,
          "left"
        )
      ),
    }, {
      d = "Delimiter",
      n = "@number",
      f = "Directory",
    })
    if i % 2 ~= 0 then
      table.insert(hl[1], { "CursorLine", 4, -1 })
    end
    local action = function()
      vim.cmd.e(rf[i])
    end
    files[i] = {
      type = "button",
      val = lines[1],
      on_press = action,
      opts = {
        keymap = i < 10 and { "n", tostring(i), action } or nil,
        hl = hl,
        position = "center",
        cursor = 1,
      },
    }
  end
  return files
end

local function pad(val)
  return {
    type = "padding",
    val = val or 1,
  }
end

local function group(elements, opts)
  opts = opts or {}
  return {
    type = "group",
    val = elements,
    opts = {
      spacing = opts.spacing or 1,
      priority = opts.priority,
      inherit = opts.inherit,
    },
  }
end

local loaded_plugins = {}
local rest_loaded_plugins = 0
local header_text = {
  "          %p🭍🬿%$                                    %p🭍🬿%$                                       ",
  "%s████%$    %p██🭍🬿%$   %p██████████%$  %s███%$%S%$%p%$          %p🭋███%$ %s███████%$  %s████%$             %s████%$ ",
  " %S%$%s████%$   %p████%$  %p██████████%$  %s███%$%S%$%p██%$         %p🭅███🭡%$ %s███████%$   %S%$%s████%$           %s████%$%S%$  ",
  " %p█%$%S%$%s████%$  %p████%$  %p████%$        %s███%$%p███%$       %p🭋████🭛%$   %s████%$%P%$     %p█%$%S%$%s████%$         %s████%$%S█%$  ",
  " %p██%$%S%$%s████%$ %p████%$  %p████%$        %s███%$  %p██%$ %s█%$   %p🭅███🭡%$    %P█%$%p█%$     %p██%$%S%$%s████%$       %s████%$%S██%$  ",
  " %p███%$%S%$%s████%$%p████%$  %p████%$%S%$%s████%$ %s███%$    %p%$ %s███%$ %p🭋████🭛%$    %P%$%p████%$     %p███%$%S%$%s████%$     %s████%$%S███%$  ",
  " %p████%$%s████%$%S%$%p███%$  %p████%$%S%$%s████%$ %s██%$%S%$%p%$    %p%$ %s████%$%p🭅███🭡%$     %p█████%$     %p████%$%s████%$   %s████%$%p████%$  ",
  " %p████%$ %s████%$%S%$%p██%$  %p████%$        %s%$%S%$%p██%$  %p██%$ %s████%$%S%$%p███🭛%$     %p█████%$     %p████%$ %s████%$ %s████%$ %p████%$  ",
  " %p████%$  %s████%$%S%$%p█%$  %S%$%p%$        %p██████%$  %s████%$%S%$%p█🭡%$      %p█████%$     %p████%$  %s████🭩████%$  %p████%$  ",
  " %p████%$   %s████%$%S%$  %s██████████%$  %p██████%$    %s████%$%S%$%p🭙%$    %p███████%$   %p████%$   %s███████%$   %p████%$  ",
  " %p🭥🭓██%$    %s████%$  %s██████████%$  %p████%$      %s████%$    %p███████%$   %p🭥🭓██%$    %s█████%$    %p██🭞🭚%$  ",
  "   %p🭥🭓%$                                                              %p🭥🭓%$               %p🭞🭚%$    ",
}
local header = colored_text(header_text, {
  p = "AlphaHeaderPrimary",
  s = "AlphaHeaderSecondary",
  P = "AlphaHeaderSecPri",
  S = "AlphaHeaderPriSec",
})

---@type { author: string, content: string }
local quote = quotes[vim.fn.rand() % #quotes + 1]
local recent_files_width = 70

local layout = {
  pad(),
  header,
  group(function()
    local stats = require("lazy").stats()
    local lazy_btn = colored_text({
      string.format(
        "%%l󰒲  %%$%%uL%%$%%lazy%%$%%d:%%$ %%n%d%%$ %%d/%%$ %%n%d%%$ %%p %%$",
        stats.loaded,
        stats.count
      ),
    }, {
      l = "MoreMsg",
      d = "Delimiter",
      p = "@module",
      n = "@number",
      u = "Underlined",
    })
    local open_lazy = vim.cmd.Lazy
    lazy_btn.type = "button"
    lazy_btn.on_press = open_lazy
    lazy_btn.val = lazy_btn.val[1]
    lazy_btn.opts.hl = lazy_btn.opts.hl[1]
    lazy_btn.opts.cursor = 3
    lazy_btn.opts.keymap = { "n", "L", open_lazy }
    return {
      lazy_btn,
      #loaded_plugins >= 0
        and colored_text({
          string.format(
            "%%p %%$%%s%%$ %%d|%%$ %%mLoaded%%$ %%p%s%%$%s",
            vim.fn.join(loaded_plugins, "%$%d,%$%p "),
            rest_loaded_plugins > 0 and string.format(" %%mand other%%$ %%n%s%%$ %%p%%$ ", rest_loaded_plugins + 1)
              or ""
          ),
        }, {
          p = "@module",
          s = "Special",
          d = "Delimiter",
          m = "MoreMsg",
          n = "@number",
        }),
    }
  end, {
    spacing = 0,
  }),
  pad(),
  group({
    button(" ", "Open File Explorer", function()
      vim.cmd.NvimTreeOpen()
    end, { shortcut = "e" }),
    button(" ", "Find Files", function()
      vim.cmd.Telescope("find_files")
    end),
    button(" ", "Live Grep", function()
      vim.cmd.Telescope("live_grep")
    end, { shortcut = "g" }),
    button(" ", "Configure", function()
      local cfg = vim.env.HOME .. "/.config"
      local dirs = {}
      for dir in vim.fs.dir(cfg) do
        table.insert(dirs, dir)
      end
      vim.ui.select(dirs, {
        prompt = "Configure",
        format_item = function(item)
          return ((vim.fn.isdirectory(cfg .. "/" .. item) == 1) and " " or " ")
            .. " "
            .. separator_right
            .. " "
            .. item
        end,
      }, function(_, idx)
        local sel = dirs[idx]
        if sel then
          vim.cmd.e(cfg .. "/" .. sel)
        end
      end)
    end, { shortcut = "c" }),
    button(" ", "Shuffle Quote", function()
      quote = quotes[vim.fn.rand() % #quotes + 1]
      require("alpha").redraw()
    end),
    button(" ", "Exit", function()
      vim.cmd.q()
    end, { shortcut = "q" }),
  }),
  group({
    colored_text(
      { "%d~%$%tRecent Files%$%d:%$ %d(%$%p" .. vim.fn.getcwd() .. "%$%d)%$" },
      { t = "Title", d = "Delimiter", p = "Special" }
    ),
    group(function()
      return recent_files(recent_files_width, 6)
    end, {
      spacing = 0,
    }),
  }, {
    spacing = 0,
  }),
  pad(),
  group({
    text(function()
      return string.format('"%s"', quote.content)
    end, {
      hl = { { "Delimiter", 0, 1 }, { "@string", 1, -2 }, { "Delimiter", -2, -1 } },
    }),
    text(function()
      return string.format("-- %s", quote.author)
    end, {
      hl = { { "Delimiter", 0, 2 }, { "Underlined", 3, -1 } },
    }),
  }, { spacing = 0 }),
}

local max_display_plugin = math.floor(vim.o.columns / 25)
local alpha = require("alpha")
require("alpha.term")
alpha.setup({
  layout = layout,
  opts = {
    margin = 3,
    setup = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(e)
          table.insert(loaded_plugins, e.data)
          if #loaded_plugins > max_display_plugin then
            rest_loaded_plugins = rest_loaded_plugins + 1
            table.remove(loaded_plugins, 1)
          end
          alpha.redraw()
        end,
      })
      vim.api.nvim_create_autocmd("VimResized", {
        buffer = vim.api.nvim_get_current_buf(),
        callback = function()
          alpha.redraw()
        end,
      })
    end,
  },
})
