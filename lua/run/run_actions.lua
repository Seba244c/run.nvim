local cmd = vim.cmd
local api = vim.api
local o = vim.o
local fn = vim.fn
local utils = require("run.utils")

local M = {}

function M.get_available_run_files()
    local files = {}

    -- Find local file --
    local local_file = fn.getcwd() .. "/run.json"
    if utils.file_exist(local_file) then
        table.insert(files, local_file)
    end

    -- Find root file --
    local root_file = utils.get_parent_dir(vim.fn.expand("%:p")) .. "/run.json"
    if utils.file_exist(root_file) and local_file ~= root_file then
        table.insert(files, root_file)
    end

    return files
end

function M.add_actions_from_files(actions, files)
    for index, file in ipairs(files) do
        local json = utils.load_json_file(file)

        for index2, action in ipairs(json) do
            table.insert(actions, action)
        end
    end

    return actions
end

return M
