pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
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
-- local editor = os.getenv("EDITOR")
-- local home_path = os.getenv("HOME")
local browser = "opera"
local meta = "Mod4"
local alt = "Mod1"
local tag_count = 5

-- beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "default"))
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.font = "UbuntuMono Nerd Font 11"
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

awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            titlebars_enabled = false,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    },
    -- Put messangers to second tag
    {
        rule_any = {
            class = {
                "Element",
                "TelegramDesktop",
                "Slack",
            },
        },
        properties = {
            tag = "2",
        },
    },
    -- Put Thunderbird to third tag
    {
        rule_any = {
            class = {
                "Thunderbird",
            },
        },
        properties = {
            tag = "3",
        },
    },
    -- MPV always floating
    {
        rule_any = {
            class = {
                "mpv",
            },
        },
        properties = {
            floating = true,
        },
    },
    -- Opera starts maximized
    {
        rule_any = {
            class = {
                "Opera",
            },
        },
        properties = {
            maximized = true,
        },
    },
}

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

    local function start_opera()
        awful.spawn(browser)
    end

    local function dmenu()
        awful.spawn("dmenu_run")
    end

    -- local c = awful.client.restore()

    local keys = gears.table.join(
        -- Launch terminal
        awful.key({ meta }, "Return", launch_terminal),

        -- Restart Awesome
        awful.key({ meta, "Control" }, "r", restart_awesome),

        -- Open Dmenu
        awful.key({ meta }, "p", dmenu),

        -- Start Opera Browser
        awful.key({ meta }, "o", start_opera),

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
            awful.util.spawn("flameshot gui")
        end)
    )

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
    local function raise_client(client)
        client:emit_signal("request::activate", "mouse_click", { raise = true })
    end

    local function move_client(client)
        client:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(client)
    end

    local function resize_client(client)
        client:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(client)
    end

    local function client_kill(client)
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
        end)
    )

    client:buttons(buttons)
    client:keys(keys)
end

setup_root_interactions()
client.connect_signal("manage", setup_client_interactions)
client.connect_signal("manage", setup_client_placement)
awful.screen.connect_for_each_screen(setup_screen_tags)

local autostart = {
    "picom",
    "flameshot",
    "slack",
    "element-desktop",
    "thunderbird",
    "telegram-desktop",
    "clipmenud",
}

for _, i in pairs(autostart) do
    awful.util.spawn(i)
end
