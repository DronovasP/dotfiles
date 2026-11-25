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

-- Right Shift (and the Lift mouse DPI button, which Solaar + ydotool turn into
-- Right Shift) controls dictation with the configured backend (Handy):
--   tap  -> start recording; tap again to stop
--   hold -> record while held, stop on release (push-to-talk)
-- A press longer than HOLD_MS counts as a hold.
if o.dictation_installed() then
  local HOLD_MS = 400
  local SHIFT_R = 54 + 8 -- KEY_RIGHTSHIFT; the Lua event gives XKB codes (evdev + 8)
  -- Recording state as tracked by omarchy-dictation-handy, so Alt+Space and
  -- Right Alt stay in sync with this key.
  local FLAG = (os.getenv("XDG_RUNTIME_DIR") or "/tmp") .. "/omarchy-dictation-handy.recording"
  local function is_recording()
    local f = io.open(FLAG, "r")
    if f then f:close() return true end
    return false
  end
  local held, pressed_at, started = false, 0, false

  hl.on("input.keyboard.key", function(code, time, state)
    if code ~= SHIFT_R then return end
    if state == 1 and not held then
      held, pressed_at = true, time
      started = not is_recording()
      hl.exec_cmd(started and "omarchy-dictation start" or "omarchy-dictation stop")
    elseif state == 0 and held then
      held = false
      -- A long press that started recording is push-to-talk: stop on release.
      -- A tap leaves it recording until the next tap.
      if started and time - pressed_at >= HOLD_MS then
        hl.exec_cmd("omarchy-dictation stop")
      end
      started = false
    end
  end)
end

-- Raycast-style launcher. Replaces Alt+Space (was: Toggle dictation; dictation
-- still works on Right Shift / Right Alt). The vicinae server runs as the
-- vicinae.service user unit.
o.rebind("ALT + SPACE", "Launcher (Vicinae)", "vicinae toggle")

-- One-key display switching (two stacked monitors, so "next" = "the other one").
o.bind("SUPER + U", "Focus other monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("SUPER + SHIFT + U", "Move window to other monitor", hl.dsp.window.move({ monitor = "+1" }))

-- Replaces Super+` (was: Toggle Quake console running `claude`) with a new
-- T3 Code thread. t3code://new starts T3 if needed and opens a blank thread.
o.rebind("SUPER + grave", "New T3 Code thread", "xdg-open t3code://new")
