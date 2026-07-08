local M = {}

local health = vim.health or require("health")
local start = health.start or health.report_start
local ok = health.ok or health.report_ok
local warn = health.warn or health.report_warn
local health_error = health.error or health.report_error

local function executable(name)
  return vim.fn.executable(name) == 1
end

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

local function imagemagick_cli()
  if executable("magick") then
    return "magick", "ImageMagick CLI found: " .. vim.fn.exepath("magick")
  end

  if executable("convert") and executable("identify") then
    return "convert", "ImageMagick legacy CLIs found: " .. vim.fn.exepath("convert")
  end
end

local function has_sixel_format(cmd)
  local output = vim.fn.systemlist({ cmd, "-list", "format" })
  if vim.v.shell_error ~= 0 then
    return nil
  end

  for _, line in ipairs(output) do
    if line:match("^%s*SIXEL[%s*]") then
      return true
    end
  end

  return false
end

local function tmux_option(name)
  local output = vim.fn.systemlist({ "tmux", "show", "-gv", name })
  if vim.v.shell_error ~= 0 then
    return nil
  end

  return output[1] or ""
end

local function tmux_version()
  local output = vim.fn.systemlist({ "tmux", "-V" })
  if vim.v.shell_error ~= 0 then
    return nil
  end

  return (output[1] or ""):match("tmux%s+(.+)")
end

local function tmux_at_least(version, required_major, required_minor)
  local major, minor = (version or ""):match("^(%d+)%.(%d+)")
  major = tonumber(major)
  minor = tonumber(minor)

  if not major or not minor then
    return false
  end

  return major > required_major or (major == required_major and minor >= required_minor)
end

function M.check()
  start("System dependencies")

  if running_in_wsl() then
    ok("Running inside WSL")
  end

  local magick_cmd, magick_message = imagemagick_cli()
  if magick_cmd then
    ok(magick_message)

    local sixel = has_sixel_format(magick_cmd)
    if sixel == true then
      ok("ImageMagick can generate SIXEL data; terminal support is separate")
    elseif sixel == false then
      warn("ImageMagick does not list SIXEL format support", {
        "This is only required if a future image integration uses the sixel backend.",
        "The current WezTerm image viewer uses OSC 1337 instead.",
      })
    else
      warn("Could not inspect ImageMagick format support", {
        "Run `" .. magick_cmd .. " -list format` manually if image rendering fails.",
      })
    end
  else
    health_error("ImageMagick CLI not found", {
      "ImageMagick is useful for future image conversion workflows.",
      "Install it in the environment where Neovim runs.",
      "Ubuntu/WSL: sudo apt install imagemagick",
      "macOS: brew install imagemagick",
    })
  end

  if vim.env.TMUX then
    local version = tmux_version()
    if version and tmux_at_least(version, 3, 3) then
      ok("Running inside tmux " .. version)
    elseif version then
      warn("Running inside tmux " .. version, {
        "The current image viewer is disabled inside tmux.",
        "tmux >= 3.3 is only needed for future passthrough experiments.",
      })
    else
      warn("Running inside tmux, but tmux version could not be detected")
    end

    local allow_passthrough = tmux_option("allow-passthrough")
    if allow_passthrough == "on" or allow_passthrough == "all" then
      ok("tmux allow-passthrough is " .. allow_passthrough)
    else
      warn("tmux allow-passthrough is not enabled", {
        "The current image viewer does not use tmux passthrough.",
        "Enable it only when testing a future tmux image path.",
      })
    end

    local visual_activity = tmux_option("visual-activity")
    if visual_activity == "off" then
      ok("tmux visual-activity is off")
    elseif visual_activity then
      warn("tmux visual-activity is " .. visual_activity, {
        "Use `set -g visual-activity off` only when testing image passthrough.",
      })
    end

    warn("WezTerm image previews are disabled inside tmux", {
      "OSC 1337 image passthrough currently corrupts tmux pane redraws.",
      "Open image buffers in a direct WezTerm pane outside tmux for now.",
      running_in_wsl() and "In WSL, use a direct Windows-side WezTerm WSL pane." or nil,
    })
  elseif vim.env.TERM_PROGRAM == "WezTerm" or vim.env.WEZTERM_PANE then
    if running_in_wsl() then
      ok("Running directly inside WezTerm from WSL")
    else
      ok("Running directly inside WezTerm")
    end
  else
    warn("Not currently running inside WezTerm", {
      "Image buffers use WezTerm's OSC 1337 inline image protocol.",
      "Image rendering should be tested from a WezTerm session.",
      running_in_wsl() and "Windows Terminal will not render this viewer's image protocol." or nil,
    })
  end
end

return M
