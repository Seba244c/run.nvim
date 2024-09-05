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
local config = require("run.config")
local run_actions = require("run.run_actions")

-----------------------------------------------------------
-- Export
-----------------------------------------------------------
local M = {}

local run_action = function(action)
    vim.notify("Running action: " .. action["name"])

    -- Create Terminal Buffer
    local buffer = api.nvim_create_buf(false, true)
    local h, w = o.lines, o.columns

    M.win = api.nvim_open_win(buffer, true, {
        relative = "editor",
        width = w - math.floor(w * config.ui.gap),
        height = h - math.floor(h * config.ui.gap) - 1,
        col = math.floor(w * config.ui.gap / 2),
        row = math.floor(h * config.ui.gap / 2) - 2,
        border = config.ui.border,
        style = "minimal",
    })

    api.nvim_win_set_option(M.win, "winhl", "NormalFloat:" .. config.ui.bg .. ",FloatBorder:" .. config.ui.border_cl)

    cmd("terminal " .. (action["cmd"] or "Invalid action!"))
    vim.schedule(function()
        vim.cmd("startinsert")
    end)
end

local pick_action = function(avail_actions)
    local opts = require("telescope.themes").get_dropdown({})
    local action_names = {}
    local action_map = {}
    for index, action in ipairs(avail_actions) do
        local name = utils.get_action_name(action)
        table.insert(action_names, name)
        action_map[name] = action
    end

    pickers
        .new(opts, {
            prompt_title = "Run: " .. fn.expand("%"),
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
    local run_files = run_actions.get_available_run_files()
    if not #run_files == 0 then
        vim.notify("run.json not found in the workspace", vim.log.levels.WARN)
        return
    end

    local avail_actions = run_actions.add_actions_from_files({}, run_files)
    pick_action(avail_actions)
end

function M.setup(opts)
    for a, _ in pairs(opts or {}) do
        for c, d in pairs(opts[a] or {}) do
            config[a][c] = d
        end
    end
    api.nvim_create_user_command("Run", M.run, {})
end

return M
