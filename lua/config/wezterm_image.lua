local M = {}

local image_file_patterns = {
  "*.png",
  "*.jpg",
  "*.jpeg",
  "*.gif",
  "*.webp",
  "*.avif",
  "*.bmp",
}

local group = vim.api.nvim_create_augroup("config.wezterm_image", { clear = true })
local tty = nil

local function running_in_wsl()
  if vim.env.WSL_DISTRO_NAME or vim.env.WSL_INTEROP then
    return true
  end

  local file = io.open("/proc/version", "r")
  if not file then
    return false
  end

  local version = file:read("*a"):lower()
  file:close()
  return version:find("microsoft", 1, true) ~= nil or version:find("wsl", 1, true) ~= nil
end

local function supported_terminal()
  if vim.env.TMUX then
    -- OSC 1337 passthrough currently corrupts tmux pane redraws in WezTerm, so
    -- this viewer only emits image escapes when Neovim owns the terminal pane.
    return false
  end

  return vim.env.TERM_PROGRAM == "WezTerm" or vim.env.WEZTERM_PANE ~= nil
end

local function unsupported_message()
  if vim.env.TMUX then
    local message = {
      "Image preview is disabled inside tmux.",
      "",
      "This viewer writes WezTerm OSC 1337 image data directly to the pane.",
      "OSC 1337 passthrough currently corrupts tmux pane redraws in WezTerm.",
      "Open image buffers outside tmux for now.",
    }

    if running_in_wsl() then
      table.insert(message, "")
      table.insert(message, "In WSL, use a direct Windows-side WezTerm WSL pane for image buffers.")
    end

    return message
  end

  if vim.env.TERM_PROGRAM ~= "WezTerm" and not vim.env.WEZTERM_PANE then
    local message = {
      "Image preview requires WezTerm.",
      "",
      "Open this buffer in a WezTerm pane outside tmux to render the image.",
    }

    if running_in_wsl() then
      table.insert(message, "Windows Terminal will not render this viewer's image protocol.")
    end

    return message
  end

  return { "Image preview is not available in this terminal session." }
end

local function path_matches_patterns(path)
  local filename = vim.fn.fnamemodify(path, ":t")

  for _, pattern in ipairs(image_file_patterns) do
    if vim.fn.match(filename, vim.fn.glob2regpat(pattern)) >= 0 then
      return true
    end
  end

  return false
end

local function read_file(path)
  local file = io.open(path, "rb")
  if not file then
    return nil
  end

  local data = file:read("*a")
  file:close()
  return data
end

local function write_terminal(data)
  if not tty then
    local uv = vim.uv or vim.loop
    tty = uv.new_tty(1, false)
  end

  if not tty then
    return false
  end

  tty:write(data)
  return true
end

local function display_image(win, path)
  if not supported_terminal() then
    return
  end

  local data = read_file(path)
  if not data then
    return
  end

  local pos = vim.fn.win_screenpos(win)
  local row = pos[1]
  local col = pos[2]

  if row <= 0 or col <= 0 then
    return
  end

  local encoded = vim.base64.encode(data)

  write_terminal(table.concat({
    "\27[?2026h",
    "\27[s",
    ("\27[%d;%dH"):format(row, col),
    "\27]1337;File=inline=1;width=auto;height=auto;preserveAspectRatio=1:",
    encoded,
    "\7",
    "\27[u",
    "\27[?2026l",
  }))
end

local function render_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local path = vim.b[buf].wezterm_image_path
  if not path or path == "" then
    return
  end

  local wins = vim.fn.win_findbuf(buf)
  if #wins == 0 then
    return
  end

  vim.cmd("redraw")
  vim.defer_fn(function()
    for _, win in ipairs(wins) do
      if vim.api.nvim_win_is_valid(win) then
        display_image(win, path)
      end
    end
  end, 20)
end

local function set_image_buffer(buf, path)
  local preview_supported = supported_terminal()
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, preview_supported and { "" } or unsupported_message())
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nowrite"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].filetype = "wezterm_image"
  vim.bo[buf].readonly = true

  vim.b[buf].wezterm_image_path = path

  local ok = pcall(vim.keymap.set, "n", "r", function()
    render_buffer(buf)
  end, { buffer = buf, desc = "Refresh Image" })
  if not ok then
    -- The mapping may already exist if the buffer is reused.
  end

  if preview_supported then
    vim.schedule(function()
      render_buffer(buf)
    end)
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("BufReadPre", {
    group = group,
    pattern = image_file_patterns,
    callback = function(event)
      vim.bo[event.buf].swapfile = false
    end,
  })

  vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
    group = group,
    pattern = image_file_patterns,
    callback = function(event)
      local path = vim.api.nvim_buf_get_name(event.buf)
      if path ~= "" and path_matches_patterns(path) then
        set_image_buffer(event.buf, path)
      end
    end,
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      local path = vim.api.nvim_buf_get_name(buf)
      if path ~= "" and path_matches_patterns(path) then
        set_image_buffer(buf, path)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
    group = group,
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      if vim.b[buf].wezterm_image_path then
        render_buffer(buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    group = group,
    pattern = image_file_patterns,
    callback = function()
      vim.cmd("redraw")
    end,
  })
end

return M
