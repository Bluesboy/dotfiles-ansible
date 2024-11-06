pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local ruled = require("ruled")
require("awful.autofocus")

-- Notification library
local naughty = require("naughty")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Lain collection of Awesome utilities
local lain = require("lain")

local function notify_error(err)
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Error",
    text = tostring(err),
  })
end

local theme = {}
theme.bg_focus = "#4d6d91"

local terminal = "alacritty"
local wallpapersDir = "/Pictures/wallpapers"
local browser = "opera"
local meta = "Mod4"
local alt = "Mod1"
local tag_count = 5

-- beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "default"))
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.font = "UbuntuMono Nerd Font 14"
beautiful.useless_gap = 2

if awesome.startup_errors then
  notify_error(awesome.startup_errors)
end
awesome.connect_signal("debug::error", notify_error)
--
-- setup quake-style terminal
local quake_term = lain.util.quake({
  app = terminal,
  argname = "--title=%s",
  extra = "--class QuakeDD",
  visible = true,
  height = 1,
  border = 0,
  followtag = 1,
})

awful.layout.layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.max,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}

local function scandir(directory)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('find "' .. directory .. '" -maxdepth 1 -type f')

  for filename in pfile:lines() do
    i = i + 1
    table.insert(t, filename)
  end
  pfile:close()

  return t
end

local function setWallpaper(directory, displayCount)
  local wallpapersDirFullPath = os.getenv("HOME") .. directory
  local wallpapers = scandir(wallpapersDirFullPath)

  for i = 1, displayCount do
    gears.wallpaper.maximized(wallpapers[math.random(#wallpapers)], i)
  end
end

ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  ruled.client.append_rule({
    id = "global",
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      titlebars_enabled = false,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  })

  ruled.client.append_rule({
    id = "slack",
    rule_any = {
      class = {
        "Slack",
      },
    },
    properties = {
      tag = "1",
      screen = "HDMI-1",
    },
  })
  ruled.client.append_rule({
    id = "telegram",
    rule_any = {
      class = {
        "TelegramDesktop",
      },
    },
    properties = {
      tag = "2",
      screen = "HDMI-1",
    },
  })
  ruled.client.append_rule({
    id = "element",
    rule_any = {
      class = {
        "Element",
      },
    },
    properties = {
      tag = "3",
      screen = "HDMI-1",
    },
  })
  ruled.client.append_rule({
    id = "thunderbird",
    rule_any = {
      class = {
        "thunderbird",
      },
    },
    properties = {
      tag = "1",
      screen = "HDMI-2",
    },
  })
  ruled.client.append_rule({
    id = "mpv",
    rule_any = {
      class = {
        "mpv",
      },
    },
    properties = {
      floating = true,
    },
  })
  ruled.client.append_rule({
    id = "opera",
    rule_any = {
      class = {
        "Opera",
      },
    },
    properties = {
      maximized = true,
    },
  })
  ruled.client.append_rule({
    id = "pip",
    rule_any = {
      name = {
        "Картинка в картинке",
        "Picture-in-picture",
      },
    },
    properties = {
      floating = true,
      ontop = true,
    },
  })
  ruled.client.append_rule({
    id = "telegram_viewer",
    rule_any = {
      name = {
        "Media viewer",
      },
    },
    properties = {
      floating = true,
      ontop = true,
    },
  })
  ruled.client.append_rule({
    id = "zoom",
    rule_any = {
      name = {
        "Zoom Meeting",
      },
    },
    properties = {
      screen = "HDMI-2",
      tag = "2",
    },
  })
end)

-- Create a wibox for each screen and add it
local function setup_screen_tags(screen)
  for i = 1, tag_count do
    awful.tag({ i }, screen, awful.layout.layouts[2])
  end

  -- Layout Box
  screen.mylayoutbox = awful.widget.layoutbox(screen)

  screen.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, 3, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 4, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(1)
    end)
  ))

  -- Create a taglist widget
  local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
      t:view_only()
    end),
    awful.button({ meta }, 1, function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ meta }, 3, function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end),
    awful.button({}, 4, function(t)
      awful.tag.viewprev(t.screen)
    end),
    awful.button({}, 5, function(t)
      awful.tag.viewnext(t.screen)
    end)
  )

  screen.mytaglist = awful.widget.taglist({
    screen = screen,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  })

  -- Create a tasklist widget
  local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal("request::activate", "tasklist", { raise = true })
      end
    end),
    awful.button({}, 3, function()
      awful.menu.client_list({ theme = { width = 350 } })
    end),
    awful.button({}, 4, function()
      awful.client.focus.byidx(-1)
    end),
    awful.button({}, 5, function()
      awful.client.focus.byidx(1)
    end)
  )

  screen.mytasklist = awful.widget.tasklist({
    screen = screen,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
  })

  -- Create the wibox
  screen.taskbar = awful.wibar({ position = "top", screen = screen })

  -- Add widgets to the wibox
  screen.taskbar:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      screen.mytaglist,
      screen.mypromptbox,
    },
    screen.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.widget.systray(),
      wibox.widget.textclock(),
      awful.widget.keyboardlayout(),
      wibox.container.background(screen.mylayoutbox, theme.bg_focus),
    },
  })
end

local function setup_root_interactions()
  local function launch_terminal()
    awful.spawn(terminal)
  end

  local function restart_awesome()
    awesome.restart()
  end

  local function start_browser()
    local matcher = function(c)
      return ruled.client.match(c, { class = "Opera" })
    end

    awful.spawn.raise_or_spawn(browser, nil, matcher, "opera")
  end

  local function start_slack()
    local matcher = function(c)
      return ruled.client.match(c, { class = "Slack" })
    end

    awful.client.run_or_raise("slack", matcher)
  end

  local function dmenu()
    awful.spawn("dmenu_run -fn 'UbuntuMono Nerd Font 16'")
  end

  local function setWall()
    setWallpaper(wallpapersDir, 3)
  end

  local keys = gears.table.join(
    -- Launch terminal
    awful.key({ meta }, "Return", launch_terminal),

    -- Restart Awesome
    awful.key({ meta, "Control" }, "r", restart_awesome),

    -- Open Dmenu
    awful.key({ meta }, "p", dmenu),

    -- Start Opera Browser
    awful.key({ meta }, "o", start_browser),

    awful.key({ meta }, "w", setWall),

    -- Start Slack
    awful.key({ meta }, "s", start_slack),

    -- Focus window to direction
    awful.key({ meta }, "j", function()
      awful.client.focus.bydirection("down")
    end),
    awful.key({ meta }, "k", function()
      awful.client.focus.bydirection("up")
    end),
    awful.key({ meta }, "h", function()
      awful.client.focus.bydirection("left")
    end),
    awful.key({ meta }, "l", function()
      awful.client.focus.bydirection("right")
    end),

    -- Move window to direction
    awful.key({ meta, "Shift" }, "j", function()
      awful.client.swap.bydirection("down")
    end),
    awful.key({ meta, "Shift" }, "k", function()
      awful.client.swap.bydirection("up")
    end),
    awful.key({ meta, "Shift" }, "h", function()
      awful.client.swap.bydirection("left")
    end),
    awful.key({ meta, "Shift" }, "l", function()
      awful.client.swap.bydirection("right")
    end),

    -- Revolve client forward/backward
    awful.key({ meta }, "Down", function()
      awful.client.cycle(false)
      awful.client.focus.byidx(1)
    end),
    awful.key({ meta }, "Up", function()
      awful.client.cycle(true)
      awful.client.focus.byidx(-1)
    end),

    -- Switch window
    awful.key({ alt }, "Tab", function()
      awful.client.focus.byidx(1)
    end),
    awful.key({ alt, "Shift" }, "Tab", function()
      awful.client.focus.byidx(-1)
    end),

    -- Switch layout
    awful.key({ meta }, "]", function()
      awful.layout.inc(1)
    end),
    awful.key({ meta }, "[", function()
      awful.layout.inc(-1)
    end),

    -- Switch tag
    awful.key({ meta }, "Tab", function()
      awful.tag.viewnext()
    end),
    awful.key({ meta, "Shift" }, "Tab", function()
      awful.tag.viewprev()
    end),

    -- Open drop down terminal
    awful.key({ "Control" }, "`", function()
      quake_term:toggle()
    end),

    -- Open Clipmenu
    awful.key({ meta }, "v", function()
      awful.spawn("clipmenu")
    end),

    -- Open Passmenu
    awful.key({ meta, "Shift" }, "p", function()
      awful.spawn("passmenu")
    end),

    -- Open Flameshot GUI
    awful.key({}, "Print", function()
      awful.spawn("flameshot gui")
    end),

    awful.key({ meta, "Control" }, "h", function()
      awful.screen.focus_bydirection("left", _screen)
    end),

    awful.key({ meta, "Control" }, "l", function()
      awful.screen.focus_bydirection("right", _screen)
    end)
  )
  -- set up keybindings based on existing monitors
  for s in screen do
    for screen_name, _ in pairs(s.outputs) do
      if screen_name == "HDMI-1" then
        keys = gears.table.join(
          keys,
          awful.key({ "Control" }, "F1", function()
            awful.screen.focus(s)
          end)
        )
      elseif screen_name == "DP-2" then
        keys = gears.table.join(
          keys,
          awful.key({ "Control" }, "F2", function()
            awful.screen.focus(s)
          end)
        )
      elseif screen_name == "HDMI-2" then
        keys = gears.table.join(
          keys,
          awful.key({ "Control" }, "F3", function()
            awful.screen.focus(s)
          end)
        )
      end
    end
  end

  for i = 1, tag_count do
    keys = gears.table.join(
      keys,
      -- Switch to tag.
      awful.key({ meta }, i, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end),
      -- Toggle tag display.
      awful.key({ meta, "Control" }, i, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end),
      -- Move client to tag.
      awful.key({ meta, "Shift" }, i, function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end),
      -- Toggle tag on focused client.
      awful.key({ meta, "Control", "Shift" }, i, function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end)
    )
  end

  root.keys(keys)
end

local function setup_client_placement(client)
  awful.placement.no_offscreen(client)
  client:move_to_screen(awful.screen.preferred(client))
end

local function setup_client_interactions(client)
  local function raise_client(c)
    client:emit_signal("request::activate", "mouse_click", { raise = true })
  end

  local function move_client(c)
    client:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(client)
  end

  local function resize_client(c)
    client:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(client)
  end

  local function client_kill(c)
    client:kill()
  end

  local buttons = gears.table.join(
    awful.button({}, 1, raise_client),
    awful.button({ meta }, 1, move_client),
    awful.button({ meta }, 3, resize_client)
  )

  local keys = gears.table.join(
    -- Close client
    awful.key({ meta }, "q", client_kill),

    -- Toggle fullscreen
    awful.key({ meta }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end),

    -- Toggle maximized
    awful.key({ meta }, "m", function(c)
      c.maximized = not c.maximized
      c:raise()
    end),

    -- Toggle floating
    awful.key({ meta, "Shift" }, "f", awful.client.floating.toggle),

    -- Toggle always on top
    awful.key({ meta }, "t", function()
      client.ontop = not client.ontop
    end),

    -- Make client master
    awful.key({ alt }, "Return", function()
      client:swap(awful.client.getmaster())
    end),

    awful.key({ meta, "Control", alt }, "1", function()
      client:move_to_screen("HDMI-1")
    end),

    awful.key({ meta, "Control", alt }, "2", function()
      client:move_to_screen("DP-2")
    end),

    awful.key({ meta, "Control", alt }, "3", function()
      client:move_to_screen("HDMI-2")
    end)
  )

  client:buttons(buttons)
  client:keys(keys)
end

setWallpaper(wallpapersDir, 3)

setup_root_interactions()
client.connect_signal("manage", setup_client_interactions)
client.connect_signal("manage", setup_client_placement)
awful.screen.connect_for_each_screen(setup_screen_tags)

local autostart = {
  "picom",
  "flameshot",
  "clipmenud",
  "slack",
  "element-desktop",
  "telegram-desktop",
  "thunderbird",
}

for _, i in pairs(autostart) do
  awful.spawn(i)
end
