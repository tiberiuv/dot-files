local dap = require("dap")

dap.adapters.lldb = {
    type = "executable",
    command = "/opt/homebrew/opt/llvm/bin/lldb-vscode", -- adjust as needed
    name = "lldb",
}

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
            return "/usr/bin/python"
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
