local M = {}

local function open_clock_window(opts)
    local buf = vim.api.nvim_create_buf(false, true)

    local width = #os.date("%H:%M:%S")
    local height = 1

    local row = nil
    local col = nil
    if opts.position == 'center' then
        row = math.floor((vim.o.lines - height) / 2)
        col = math.floor((vim.o.columns - width) / 2)
    elseif opts.position == 'top' then
        row = 0
        col = math.floor((vim.o.columns - width) / 2)
    elseif opts.position == 'topleft' then
        row = 0
        col = 0
    elseif opts.position == 'topright' then
        row = 0
        col = vim.o.columns - width
    elseif opts.position == 'bottom' then
        row = vim.o.lines - height
        col = math.floor((vim.o.columns - width) / 2)
    elseif opts.position == 'bottomleft' then
        row = vim.o.lines - height
        col = 0
    elseif opts.position == 'bottomright' then
        row = vim.o.lines - height
        col = vim.o.columns - width
    elseif opts.position == 'cursor' then
        local cursor = vim.api.nvim_win_get_cursor(0)
        row = cursor[1] - 1
        col = cursor[2] + width
    end

    local original_win = vim.api.nvim_get_current_win()

    local popclock_win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        focusable = false,
    })

     -- Define custom highlight groups
    vim.api.nvim_command("highlight MyClockColor guifg=" .. opts.fgcolor)
    if opts.bgcolor == nil then
        vim.api.nvim_command("highlight MyClockBg guibg=NONE")
    else
        vim.api.nvim_command("highlight MyClockBg guibg=" .. opts.bgcolor)
    end

    -- Set the background color after creating the window
    vim.api.nvim_win_set_option(popclock_win, "winhighlight", "Normal:MyClockBg")

    -- Switch focus back to the original window (to hide the cursor)
    vim.api.nvim_set_current_win(original_win)

    -- Display the current time in the buffer
    local function update_time()
        local time_str = tostring(os.date("%H:%M:%S"))
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { time_str })
        vim.api.nvim_buf_add_highlight(buf, -1, "MyClockColor", 0, 0, -1)
    end

    -- Initial display and start timer to update every second
    update_time()
    local timer = vim.loop.new_timer()
    timer:start(0, 1000, vim.schedule_wrap(update_time))

    M.close_window = function()
        vim.schedule(function()
            if vim.api.nvim_win_is_valid(popclock_win) then
                vim.api.nvim_win_close(popclock_win, true)
            end
            if vim.api.nvim_buf_is_valid(popclock_win) then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end)
        timer:stop()
        timer:close()
    end
end

function M.setup(opts)
    opts = opts or {}
    if opts.key_binding == nil then
        opts.key_binding = "<leader>kl"
    end
    if opts.position == nil then
        opts.position = 'top'
    end
    if opts.fgcolor == nil then
        opts.fgcolor = "#b5befe"
    end

    local is_open = false
    vim.keymap.set("n", opts.key_binding, function()
        if is_open then
            M.close_window()
            is_open = false
        else
            open_clock_window(opts)
            is_open = true
        end
    end, { desc = "Open Clock" })
end

return M

