-- Keep only your personal keybinding overrides here. Add new bindings with
-- o.bind or replace defaults with o.rebind.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding. o.rebind takes the same arguments as o.bind.
-- This example replaces the default file manager with Flea.
-- o.rebind("SUPER + SHIFT + F", "File manager", { launch = "flea" })

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, { panel = "omarchy.emojis" })

-- Right Shift (keyboard, and the Lift mouse DPI button that Solaar + ydotool
-- turn into Right Shift) is Handy's own shortcut (Handy settings: Transcribe =
-- shift_right, "hold or toggle"). Handy reads input devices directly, so no
-- Hyprland handler here: a second one toggled Handy again and cancelled every
-- recording the moment it started.

-- Raycast-style launcher. Replaces Alt+Space (was: Toggle dictation; dictation
-- still works on Right Shift / Right Alt). The vicinae server runs as the
-- vicinae.service user unit.
o.rebind("ALT + SPACE", "Launcher (Vicinae)", "vicinae toggle")

-- One-key display switching (two stacked monitors, so "next" = "the other one").
o.bind("SUPER + U", "Focus other monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("SUPER + SHIFT + U", "Move window to other monitor", hl.dsp.window.move({ monitor = "+1" }))

-- Replaces Super+` (was: Toggle Quake console running `claude`) with a new
-- T3 Code thread: focus T3 (starting it if needed), then press T3's own
-- "new thread without project" shortcut, Ctrl+Alt+N (no project picker).
do
  local T3_CLASS = "com.t3tools.T3Code"

  local function t3_window()
    for _, window in ipairs(hl.get_windows()) do
      if window.class == T3_CLASS then return window end
    end
  end

  local function press(mods, key)
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end

  local function open_new_thread(window)
    hl.dispatch(hl.dsp.focus({ window = "address:" .. window.address }))
    hl.timer(function() press("CTRL ALT", "N") end, { timeout = 150, type = "oneshot" })
  end

  -- T3 takes a few seconds to start; wait for its window, up to ~15s.
  local function when_t3_ready(tries)
    local window = t3_window()
    if window then
      -- Give the UI a moment to load before pressing the shortcut.
      hl.timer(function() open_new_thread(window) end, { timeout = 1500, type = "oneshot" })
    elseif tries > 0 then
      hl.timer(function() when_t3_ready(tries - 1) end, { timeout = 250, type = "oneshot" })
    end
  end

  o.rebind("SUPER + grave", "New T3 Code thread", function()
    local window = t3_window()
    if window then
      open_new_thread(window)
    else
      hl.exec_cmd("uwsm-app -- gtk-launch t3code")
      when_t3_ready(60)
    end
  end)
end

-- Escape cancels a Handy dictation (Handy's own Escape shortcut doesn't fire).
-- Non-consuming: Escape still reaches the focused app as usual.
o.bind("Escape", "Cancel dictation (Handy)", "handy-cancel-if-recording", { non_consuming = true })
