return {
    "mfussenegger/nvim-dap",
    keys = {
        { "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<CR>" },
        { "<leader>dl", "<cmd>lua require('dap').run_last()<CR>" },
        { "<leader>dc", "<cmd>lua require('dap').continue()<CR>" },
    },
    config = function()
        local dap = require("dap")

        -- Resolved from PATH, not a Homebrew prefix: LLVM, Xcode and nix each
        -- put this somewhere different. The binary was renamed lldb-vscode ->
        -- lldb-dap in LLVM 18, so try both, and register nothing when neither
        -- is installed rather than pointing the adapter at a missing file.
        local lldb = vim.fn.exepath("lldb-dap")
        if lldb == "" then
            lldb = vim.fn.exepath("lldb-vscode")
        end
        if lldb ~= "" then
            dap.adapters.lldb = {
                type = "executable",
                command = lldb,
                name = "lldb",
            }
        end

        dap.configurations.rust = {
            {
                name = "Launch lldb",
                type = "lldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
                runInTerminal = false,
            },
        }
        dap.configurations.c = dap.configurations.rust
        dap.configurations.cpp = dap.configurations.rust

        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                pythonPath = function()
                    -- Not /usr/bin/python: that is gone on current macOS, and
                    -- resolving from PATH picks up an active venv or pyenv shim.
                    local py = vim.fn.exepath("python3")
                    return py ~= "" and py or "python3"
                end,
            },
        }

        vim.keymap.set("n", "<leader>dc", function()
            dap.continue()
        end)
        vim.keymap.set("n", "<leader>dl", function()
            dap.run_last()
        end)
        vim.keymap.set("n", "<leader>b", function()
            dap.toggle_breakpoint()
        end)
    end,
}
