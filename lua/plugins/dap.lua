-- C/C++ debugging with cppdbg (cpptools) on top of the dap.core extra.
-- The codelldb configurations from lang.clangd stay available alongside.
local function input_program()
  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

local function set_dap_colors()
  vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff5555" })
  vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#ffaa00" })
  vim.api.nvim_set_hl(0, "DapStopped", { fg = "#00ff99" })
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      icons = {
        dap = {
          Breakpoint = { "●", "DapBreakpoint" },
          BreakpointRejected = { "◌", "DapBreakpointRejected" },
          Stopped = { "→", "DapStopped", "DapStoppedLine" },
        },
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "cppdbg" },
      -- adapters and configurations are defined below and by lang.clangd;
      -- skip mason-nvim-dap's presets so they don't pile up as duplicates
      handlers = {
        cppdbg = function() end,
        codelldb = function() end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = vim.fn.exepath("OpenDebugAD7") ~= "" and vim.fn.exepath("OpenDebugAD7")
          or vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
      }

      local configs = {
        {
          name = "Launch file (cppdbg)",
          type = "cppdbg",
          request = "launch",
          program = input_program,
          args = function()
            return vim.split(vim.fn.input("Args: "), " +", { trimempty = true })
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
        },
        {
          name = "Attach to gdbserver localhost:5678",
          type = "cppdbg",
          request = "launch",
          MIMode = "gdb",
          miDebuggerServerAddress = "localhost:5678",
          miDebuggerPath = vim.fn.exepath("gdb") ~= "" and vim.fn.exepath("gdb") or "/usr/bin/gdb",
          program = input_program,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
        },
      }

      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = vim.list_extend(vim.deepcopy(configs), dap.configurations[lang] or {})
      end

      set_dap_colors()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("dap_colors", { clear = true }),
        callback = set_dap_colors,
      })
    end,
  },
}
