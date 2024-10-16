vim.g.nvx_profile = vim.g.nvx_profile or "default"
V = {}
local options_loaded = {}

function V.req(module)
  if module then
    return require(vim.g.nvx_profile .. "." .. module)
  else
    return require(vim.g.nvx_profile)
  end
end

function V.opt(name)
  if not name then
    return {}
  end
  local last_opt = options_loaded[name]
  if last_opt then
    return last_opt
  end
  local success, opt = pcall(require, "core.opt." .. name)
  if not success then
    opt = {}
  end

  local profile_opt, replace
  success, profile_opt, replace = pcall(V.req, "opt." .. name)
  if replace then
    opt = profile_opt
  else
    local t = type(profile_opt)
    if success and t == "table" then
      opt = vim.tbl_extend("force", opt, profile_opt)
    elseif success and t == "function" then
      opt = profile_opt(opt) or opt
    end
  end
  options_loaded[name] = opt
  return opt
end

require("core.lazy")
require("core.opt")

require("heirline").setup(V.opt("heirline"))
vim.opt.winbar = nil
function V.check_winbar(buf, args)
  local force = false
  if not vim.api.nvim_buf_is_loaded(buf) then
    return
  end
  local clients = vim.lsp.get_clients({ bufnr = buf })
  if args and args.event == "LspDetach" then
    local has_server = false
    for _, server in ipairs(clients) do
      if server.id == args.data.client_id then
        has_server = true
      end
    end
    if has_server and #clients < 2 then
      force = true
    end
  end
  local navic = require("nvim-navic")
  if not force and (navic.is_available(buf) and #clients > 0) then
    vim.wo.winbar = "%{%v:lua.require'heirline'.eval_winbar()%}"
  else
    vim.wo.winbar = nil
  end
end

require("neotest").setup(V.opt("neotest"))

require("core.autocmds")
require("core.mappings")
pcall(V.req)
