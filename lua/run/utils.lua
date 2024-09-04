local M = {}

local fn, api, opt = vim.fn, vim.api, vim.opt

function M.get_action_name(run_action)
    return run_action["name"]
end

--- Loads file as a json object
--- @param filename string
function M.load_json_file(filename)
    return fn.json_decode(fn.readfile(filename))
end

function M.get_parent_dir(file)
    return file:match("(.*)/[^/]+$")
end

---@return string|nil
function M.find_file_in_dirs(filename, dirs)
    for i, dir in ipairs(dirs) do
        local test = dir .. "/" .. filename
        if fn.empty(fn.glob(test)) == 0 then
            return test
        end
    end
end

return M
