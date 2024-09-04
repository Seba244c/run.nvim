local cmd = vim.cmd
local api = vim.api
local o = vim.o
local fn = vim.fn
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-----------------------------------------------------------
-- Export
-----------------------------------------------------------
local M = {}

local pick_action = function()
    opts = require("telescope.themes").get_dropdown({})
    pickers
        .new(opts, {
            prompt_title = "Run",
            finder = finders.new_table({
                results = { "Foo", "Bar" },
            }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    vim.api.nvim_put({ selection[1] }, "", false, true)
                end)
                return true
            end,
        })
        :find()
end

function M.run()
    pick_action()
end

function M.setup(opts)
    api.nvim_create_user_command("Run", M.run, {})
end

return M
