local fold_hls = {
  "RainbowDelimiterRed",
  "RainbowDelimiterBlue",
  "RainbowDelimiterGreen",
  "RainbowDelimiterOrange",
  "RainbowDelimiterViolet",
  "RainbowDelimiterCyan",
  "RainbowDelimiterYellow",
}

function _G.core_options_status_column_func()
  if vim.wo.number then
    local foldable = require("nvim-treesitter.fold").get_fold_indic(vim.v.lnum):match("[^%d]+") ~= nil
    local nextfoldable = (require("nvim-treesitter.fold").get_fold_indic(vim.v.lnum + 1) or ""):match("[^%d]+") ~= nil
    local foldstart = vim.fn.foldclosed(vim.v.lnum)
    local foldlevel = vim.fn.foldlevel(vim.v.lnum)
    local nextfoldlevel = vim.fn.foldlevel(vim.v.lnum + 1)
    local folded = foldstart > 0
    local foldindicator = "  "
    local foldhl = fold_hls[((foldlevel - 1) % #fold_hls) + 1]
    if foldlevel > 0 then
      if (nextfoldable and nextfoldable == foldlevel) or nextfoldlevel < foldlevel then
        foldindicator = "%(%#" .. foldhl .. "#└ %)"
      else
        foldindicator = "%(%#" .. foldhl .. "#│ %)"
      end
    end
    local foldsign = foldable and (folded and "%(%#" .. foldhl .. "# %)" or "%(%#" .. foldhl .. "# %)")
    return (foldsign or foldindicator) .. "%s%=" .. (folded and "%#FoldColumn#" or "") .. "%l "
  else
    return ""
  end
end

local function fold_virt_text(result, s, lnum, coloff)
  if not coloff then
    coloff = 0
  end
  local text = ""
  local hl
  for i = 1, #s do
    local char = s:sub(i, i)
    local tokens = vim.lsp.semantic_tokens.get_at_pos(0, lnum, coloff + i - 1)
    local tok = tokens and tokens[#tokens]
    if tok then
      local new_hl = "@lsp.type." .. tok.type
      if new_hl ~= hl then
        table.insert(result, { text, hl })
        text = ""
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
      local _hl = hls[#hls]
      if _hl then
        local new_hl = "@" .. _hl.capture
        if new_hl ~= hl then
          table.insert(result, { text, hl })
          text = ""
          hl = nil
        end
        text = text .. char
        hl = new_hl
      else
        text = text .. char
      end
    end
  end

  table.insert(result, { text, hl })
end

function _G.core_options_foldtext_func()
  local start = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
  local end_str = vim.fn.getline(vim.v.foldend)
  local end_ = vim.trim(end_str)
  local result = {}
  fold_virt_text(result, start, vim.v.foldstart - 1)
  table.insert(result, { " ... ", "String" })
  fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match("^(%s+)") or ""))

  return result
end

vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.foldlevel = 100000
vim.opt.foldenable = false
vim.opt.laststatus = 3
vim.opt.scrolloff = 1000
vim.opt.showtabline = 2
vim.opt.fillchars = "fold: ,foldopen:,foldclose:,foldsep:1"
vim.opt.foldtext = "v:lua.core_options_foldtext_func()"
vim.opt.statuscolumn = "%{%v:lua.core_options_status_column_func()%}"
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
