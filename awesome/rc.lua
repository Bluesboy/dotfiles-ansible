pcall(require, "luarocks.loader")

require("awful.autofocus")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

local terminal = "alacritty"
-- local editor = os.getenv("EDITOR")
-- local home_path = os.getenv("HOME")
local browser = "opera"
local meta = "Mod4"
local alt = "Mod1"
local tag_count = 5

local function notify_error(err)
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Error",
        text = tostring(err)
    })
end

if awesome.startup_errors then notify_error(awesome.startup_errors) end
awesome.connect_signal("debug::error", notify_error)

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

    local function swap(dir)
        awful.client.swap.bydirection(dir)
    end

    -- local c = awful.client.restore()

    local keys = gears.table.join(
        awful.key({meta}, "Return", launch_terminal),
        awful.key({meta}, "o", start_opera),
        awful.key({meta}, "p", dmenu),
        awful.key({meta, "Control"}, "r", restart_awesome),
        awful.key({meta}, "j", function () awful.client.focus.bydirection("down") end),
        awful.key({meta}, "k", function () awful.client.focus.bydirection("up") end),
        awful.key({meta}, "h", function () awful.client.focus.bydirection("left") end),
        awful.key({meta}, "l", function () awful.client.focus.bydirection("right") end),
        awful.key({meta, "Shift"}, "j", swap("down")),
        awful.key({meta, "Shift"}, "k", swap("up")),
        awful.key({meta, "Shift"}, "h", swap("left")),
        awful.key({meta, "Shift"}, "l", swap("right")),
        awful.key({alt}, "Tab", function () awful.client.focus.byidx( 1) end),
        awful.key({alt, "Shift"}, "Tab", function () awful.client.focus.byidx(-1) end),
        awful.key({meta}, "]", function () awful.layout.inc( 1) end),
        awful.key({meta}, "[", function () awful.layout.inc(-1) end)
        )


    for i = 1, tag_count do
        keys = gears.table.join(keys,
            -- Switch to tag.
            awful.key({ meta }, i, 
                function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        tag:view_only()
                    end
                end),
            -- Toggle tag display.
            awful.key({ meta, "Control" }, i,
                function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                       awful.tag.viewtoggle(tag)
                    end
                end),
            -- Move client to tag.
            awful.key({ meta, "Shift" }, i,
                function ()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                   end
                end),
            -- Toggle tag on focused client.
            awful.key({ meta, "Control", "Shift" }, i,
                function ()
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


awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.max
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

local function setup_screen_tags(screen)
    for i = 1, tag_count do
        awful.tag({ i }, screen, awful.layout.layouts[2])
    end
end

local function setup_client_placement(client)
    awful.placement.no_offscreen(client)
    client:move_to_screen(awful.screen.preferred(client))
end

local function setup_client_interactions(client)
    local function raise_client(client)
        client:emit_signal("request::activate", "mouse_click", { raise = true })
    end

    local function client_kill(client)
        client:kill()
    end

    local buttons = gears.table.join(
        awful.button({}, 1, raise_client)
    )

    local keys = gears.table.join(
        awful.key({meta}, "q", client_kill)
    );

    client:buttons(buttons)
    client:keys(keys)
end

setup_root_interactions()
client.connect_signal("manage", setup_client_interactions)
client.connect_signal("manage", setup_client_placement)
awful.screen.connect_for_each_screen(setup_screen_tags)

local autostart = {
    "picom",
}

for _, i in pairs(autostart) do
    awful.util.spawn(i)
end
