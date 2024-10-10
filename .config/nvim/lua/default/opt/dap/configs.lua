---@type table<string, dap.Configuration[]>
local M = {}

M.rust = {
  {
    name = "Rust (codelldb)",
    type = "codelldb",
    request = "launch",
    -- This is where cargo outputs the executable
    program = function()
      os.execute("cargo build &> /dev/null")
      return "target/debug/${workspaceFolderBasename}"
    end,
    args = function()
      local argv = {}
      arg = vim.fn.input("argv: ")
      for a in string.gmatch(arg, "%S+") do
        table.insert(argv, a)
      end
      return argv
    end,
    cwd = "${workspaceFolder}",
    -- Uncomment if you want to stop at main
    -- stopOnEntry = true,
    MIMode = "gdb",
    miDebuggerPath = "/usr/bin/gdb",
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
      },
    },
  },
}

return M
