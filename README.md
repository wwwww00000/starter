# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Local Dependencies

Run `:checkhealth config` after setting up this config in a new environment.

- Image buffers use WezTerm's OSC 1337 inline image protocol outside tmux.
  The tested setup is WSL running in a Windows-side WezTerm pane. The viewer
  sends inline image bytes, so it does not need `wezterm` on the WSL `PATH` and
  does not ask Windows-side WezTerm to read WSL filesystem paths.
- ImageMagick is useful for future image conversion workflows.
  - Ubuntu/WSL: `sudo apt install imagemagick`
  - macOS: `brew install imagemagick`
- Image previews are currently disabled inside tmux. Even with tmux `>= 3.3`
  and `allow-passthrough`, OSC 1337 passthrough corrupts pane redraws in
  WezTerm.
