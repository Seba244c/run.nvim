local cmd = vim.cmd
local api = vim.api
local o = vim.o
local fn = vim.fn
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local utils = require("run.utils")

-----------------------------------------------------------
-- Export
-----------------------------------------------------------
local M = {}

local run_action = function(action)
    vim.notify("Running action: " .. action["name"])
end

local pick_action = function(run_actions, run_filename)
    local opts = require("telescope.themes").get_dropdown({})
    local action_names = {}
    local action_map = {}
    for index, action in ipairs(run_actions) do
        local name = utils.get_action_name(action)
        table.insert(action_names, name)
        action_map[name] = action
    end

    pickers
        .new(opts, {
            prompt_title = "Run:: " .. run_filename,
            finder = finders.new_table({
                results = action_names,
            }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    run_action(action_map[selection[1]])
                end)
                return true
            end,
        })
        :find()
end

function M.run()
    local run_file = utils.find_file_in_dirs("run.json", { utils.get_parent_dir(vim.fn.expand("%:p")), fn.getcwd() })
    if not run_file then
        vim.notify("run.json not found in the workspace", vim.log.levels.WARN)
        return
    end

    local run_actions = utils.load_json_file(run_file)
    pick_action(run_actions, run_file)
end

function M.setup(opts)
    api.nvim_create_user_command("Run", M.run, {})
end

return M
