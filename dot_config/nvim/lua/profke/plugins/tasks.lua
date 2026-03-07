-- Task runner: <leader>tn opens a telescope picker of tasks,
-- selecting one sends the command to a tmux pane (splits or reuses).
-- Press <C-e> on a task to open this file for editing.

local tasks_file = debug.getinfo(1, "S").source:sub(2) -- resolves to this file's path
-- silent by default; set silent = false to switch to the zsh window on run
local tasks = {
    { name = "smoke --debug", cmd = "pnpm run test --project=smoke --debug" },
    { name = "smoke", cmd = "pnpm run test --project=smoke" },
    { name = "health", cmd = "pnpm run test --project=health", },
    { name = "prettier:write", cmd = "pnpm run prettier:write" },
    { name = "chezmoi apply", cmd = "chezmoi apply" },
}

local function get_or_create_zsh_window()
    local target = vim.trim(vim.fn.system(
        "tmux list-windows -F '#{window_index}:#{window_name}' | grep ':zsh$' | head -1 | cut -d: -f1"
    ))

    if target == "" then
        -- Create a new window at the end running zsh (tmux auto-names it "zsh")
        target = vim.trim(vim.fn.system("tmux new-window -d -P -F '#{window_index}'"))
    end

    return target
end

local function run_task_in_tmux(task)
    local target = get_or_create_zsh_window()

    -- Send the command to the zsh window's active pane
    vim.fn.system(string.format("tmux send-keys -t :%s %s Enter", target, vim.fn.shellescape(task.cmd)))

    if task.silent == false then
        vim.fn.system(string.format("tmux select-window -t :%s", target))
    else
        vim.notify("Task sent: " .. task.name, vim.log.levels.INFO)
    end
end

vim.keymap.set("n", "<leader>tn", function()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers
        .new({}, {
            prompt_title = "Run Task",
            finder = finders.new_table({
                results = tasks,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry.name,
                        ordinal = entry.name,
                    }
                end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    if selection then
                        run_task_in_tmux(selection.value)
                    end
                end)
                -- <C-e> opens the chezmoi source of this file for editing
                map({ "i", "n" }, "<C-e>", function()
                    actions.close(prompt_bufnr)
                    -- Resolve chezmoi source path for this file
                    local source = vim.trim(vim.fn.system("chezmoi source-path " .. vim.fn.shellescape(tasks_file)))
                    if vim.v.shell_error ~= 0 or source == "" then
                        source = tasks_file
                    end
                    vim.cmd("edit " .. vim.fn.fnameescape(source))
                end)
                return true
            end,
        })
        :find()
end, { desc = "[T]ask Ru[n]ner" })
