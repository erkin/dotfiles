local gears = require("gears")

local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local lain = require("lain")

if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

do
   local in_error = false
   awesome.connect_signal(
      "debug::error", function (err)
         -- Make sure we don't go into an endless error loop
         if in_error then return end
         in_error = true
         
         naughty.notify({ preset = naughty.config.presets.critical,
                          title = "Oops, an error happened!",
                          text = tostring(err) })
         in_error = false
   end)
end

beautiful.init("/home/erkin/.config/awesome/theme.lua")

local volume = lain.widget.pulsebar
{
   ticks = true,
   ticks_size = 2,
   notification_preset = { font = "Unifont 10" },
   -- settings = function()
   --    if volume_now.muted == "yes"
   --    then
   --       vicon = " 🔇 "
   --    elseif tonumber(volume_now.left) == 0
   --    then
   --       vicon = " 🔈 "
   --    elseif tonumber(volume_now.left) == 100
   --    then
   --       vicon = " 🔊 "
   --    else
   --       vicon = " 🔉 "
   --    end
   --    widget:set_text(vicon .. volume_now.right .. "% ")
   -- end
}

local redshift = wibox.widget.textbox()
lain.widget.contrib.redshift:attach(
   redshift,
   function (active)
      if active
      then
         redshift:set_text("🌝")
      else
         redshift:set_text("🌞")
      end
   end
)

terminal = "kitty"
editor = os.getenv("EDITOR") or "emacs"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

local layouts =
   {
      awful.layout.suit.tile,
      awful.layout.suit.floating,
      awful.layout.suit.tile.left,
      awful.layout.suit.tile.bottom,
      awful.layout.suit.tile.top,
      awful.layout.suit.fair,
      awful.layout.suit.fair.horizontal,
      awful.layout.suit.spiral,
      awful.layout.suit.spiral.dwindle,
      awful.layout.suit.max.fullscreen,
      awful.layout.suit.max,
      awful.layout.suit.magnifier
   }

-- {{{ Helper functions
local function client_menu_toggle_fn()
   local instance = nil

   return function()
      if instance and instance.wibox.visible then
         instance:hide()
         instance = nil
      else
         instance = awful.menu.clients({ theme = { width = 250 } })
      end
   end
end

function run_rtorrent()
   awful.spawn(terminal .. " -T=rtorrent rtorrent",
               {
                  floating = false,
                  tag = "😿",
                  screen = 1,
   })
end
function run_hexchat()
   awful.spawn("hexchat",
               {
                  floating = false,
                  tag = "💖",
                  screen = 2,
   })
end
function run_firefox()
   awful.spawn("firefox",
               {
                  floating = false,
                  tag = "🐱",
                  screen = 1,
   })
end
function run_discord()
   awful.spawn("ripcord",
               {
                  floating = false,
                  tag = "🙀",
                  screen = 1,
   })
end

function run_keepassxc()
   awful.spawn("keep",
               {
                  floating = false,
                  tag = "😿",
                  screen = 1,
   })
end

menubar.utils.terminal = terminal

mytextclock = wibox.widget.textclock(" %y-%m-%d %w %H:%M ")

taglist_font = "Noto Color Emoji"

local taglist_buttons = awful.util.table.join(
   awful.button({ }, 1, function(t) t:view_only() end),
   awful.button({ modkey }, 1, function(t)
         if client.focus then
            client.focus:move_to_tag(t)
         end
   end),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, function(t)
         if client.focus then
            client.focus:toggle_tag(t)
         end
   end),
   awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
         if c == client.focus then
            c.minimized = true
         else
            c.minimized = false
            if not c:isvisible() and c.first_tag then
               c.first_tag:view_only()
            end
            client.focus = c
            c:raise()
         end
   end),
   awful.button({ }, 3, client_menu_toggle_fn()),
   awful.button({ }, 4, function()
         awful.client.focus.byidx(1)
   end),
   awful.button({ }, 5, function()
         awful.client.focus.byidx(-1)
end))

local function set_wallpaper(s)
   if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
      -- If wallpaper is a function, call it with the screen
      if type(wallpaper) == "function" then
         wallpaper = wallpaper(s)
      end
      gears.wallpaper.tiled(wallpaper, s)
   end
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
--      set_wallpaper(s)

      s.mypromptbox = awful.widget.prompt()

      mytagnames = {
         { "🐱", "🙀", "😹", "😺", "😻", "😼", "😽", "😾", "😿" },
         { "💖", "🧡", "💛", "💚", "💙", "💜" }}

      awful.tag(mytagnames[s.index], s, layouts[1])
      s.mywibox = awful.wibar({ position = "top", screen = s })

      s.mylayoutbox = awful.widget.layoutbox(s)
      s.mylayoutbox:buttons(
         awful.util.table.join(
            awful.button({ }, 1, function() awful.layout.inc( 1) end),
            awful.button({ }, 3, function() awful.layout.inc(-1) end),
            awful.button({ }, 4, function() awful.layout.inc( 1) end),
            awful.button({ }, 5, function() awful.layout.inc(-1) end)))

      s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

      s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

      if s.index == 1
      then
         s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
               layout = wibox.layout.fixed.horizontal,
               s.mytaglist,
               s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
               layout = wibox.layout.fixed.horizontal,
               redshift,
               volume.bar,
               wibox.widget.systray(),
               mytextclock,
               s.mylayoutbox,
            },
         }
      elseif s.index == 2
      then
         s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            {
               layout = wibox.layout.fixed.horizontal,
               s.mytaglist,
               s.mypromptbox,
            },
            s.mytasklist,
            {
               layout = wibox.layout.fixed.horizontal,
               mytextclock,
               s.mylayoutbox,
            },
         }
      end
   
end)

root.buttons(awful.util.table.join(
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
))

globalkeys = awful.util.table.join(
   awful.key({ modkey }, "Next",
      function() awful.client.moveresize(  0,  0,  -40, -40) end),
   awful.key({ modkey }, "Prior",
      function() awful.client.moveresize(  0,  0,   40,  40) end),
   awful.key({ modkey }, "Down",
      function() awful.client.moveresize(  0,  20,   0,   0) end),
   awful.key({ modkey }, "Up",
      function() awful.client.moveresize(  0, -20,   0,   0) end),
   awful.key({ modkey }, "Left",
      function() awful.client.moveresize(-20,   0,   0,   0) end),
   awful.key({ modkey }, "Right",
      function() awful.client.moveresize( 20,   0,   0,   0) end),

   awful.key({ modkey }, "l",
      function() awful.tag.incmwfact( 0.05)   end),
   awful.key({ modkey }, "h",
      function() awful.tag.incmwfact(-0.05)   end),

   awful.key({ modkey, "Shift" }, "l",
      function() awful.client.incwfact(-0.05) end),
   awful.key({ modkey, "Shift" }, "h",
      function() awful.client.incwfact( 0.05) end),

   awful.key({ modkey, "Control" }, "Next",
      function() awful.client.moveresize(  0,  0,  -1,  -1) end),
   awful.key({ modkey, "Control" }, "Prior",
      function() awful.client.moveresize(  0,  0,   1,   1) end),
   awful.key({ modkey, "Control" }, "Down",
      function() awful.client.moveresize(  0,  1,   0,   0) end),
   awful.key({ modkey, "Control" }, "Up",
      function() awful.client.moveresize(  0, -1,   0,   0) end),
   awful.key({ modkey, "Control" }, "Left",
      function() awful.client.moveresize(-1,   0,   0,   0) end),
   awful.key({ modkey, "Control" }, "Right",
      function() awful.client.moveresize( 1,   0,   0,   0) end),

   awful.key({                   }, "Menu",
      function() awful.spawn(terminal)                      end),

   awful.key({"Shift"            }, "Menu",
      function() awful.spawn("env emacsclient -c")          end),
   -- awful.key({ modkey,           }, "Menu",
   --    function() awful.spawn("rofi -show combi")            end),

   awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

   awful.key({                   }, "F6",
      function()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
   end),

   awful.key({                   }, "F7",     awful.tag.viewprev),
   awful.key({                   }, "F8",     awful.tag.viewnext),

   awful.key({         "Control" }, "F7",
      function() awful.screen.focus(1)                      end),
   awful.key({         "Control" }, "F8",
      function() awful.screen.focus(2)                      end),

   awful.key({ modkey,           }, "F2",
      function() awful.screen.focus(2)                      end),
   awful.key({ modkey,           }, "F1",
      function() awful.screen.focus(1)                      end),

   awful.key({ modkey,           }, "j",
      function()
         awful.client.focus.byidx( 1)
         if client.focus then
            client.focus:raise()
         end                                                end),
   awful.key({ modkey,           }, "k",
      function()
         awful.client.focus.byidx(-1)
         if client.focus then
            client.focus:raise()
         end                                                end),

   awful.key({                   }, "Print",
      function() awful.spawn("screensht")                   end),
   awful.key({         "Shift"   }, "Print",
      function() awful.spawn("scrot -e 'mv $f ~/media/image/screen/$(date +%Y)/ 2>/dev/null'") end),

   awful.key({ modkey,           }, "Return",
      function() awful.spawn("xautolock -locknow")                       end),

   awful.key({ modkey, "Shift"   }, "j",
      function() awful.client.swap.byidx(  1)               end),
   awful.key({ modkey, "Shift"   }, "k",
      function() awful.client.swap.byidx( -1)               end),
   awful.key({ modkey, "Control" }, "j",
      function() awful.screen.focus_relative( 1)            end),
   awful.key({ modkey, "Control" }, "k",
      function() awful.screen.focus_relative(-1)            end),

   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

   awful.key({                   }, "XF86AudioRaiseVolume",
      function()
         os.execute(string.format("pactl set-sink-volume %d +2%%", volume.device))
         volume.notify()                                   end),
   awful.key({                   }, "XF86AudioLowerVolume",
      function()
         os.execute(string.format("pactl set-sink-volume %d -2%%", volume.device))
         volume.notify()                                   end),
   awful.key({                   }, "XF86AudioMute",
      function()
         os.execute(string.format("pactl set-sink-mute %d toggle", volume.device))
         volume.notify()                                   end),

   -- Redshift
   awful.key({ modkey, "Shift"   }, "t",
      function () lain.widget.contrib.redshift:toggle()    end),

   -- PulseAudio volume control
   awful.key({ modkey,           }, "KP_Add",
      function ()
         os.execute(string.format("pactl set-sink-volume %d +2%%", volume.device))
         volume.notify()                                   end),
   awful.key({ modkey,           }, "KP_Subtract",
      function ()
         os.execute(string.format("pactl set-sink-volume %d -2%%", volume.device))
         volume.notify()                                   end),
   awful.key({ modkey, "Shift"   }, "m",
      function ()
         os.execute(string.format("pactl set-sink-mute %d toggle", volume.device))
         volume.notify()                                   end),

   -- MPD control
   awful.key({ modkey, "Control" }, "Up",
      function () awful.spawn.with_shell("mpc toggle")     end),
   awful.key({ modkey, "Control" }, "Down",
      function () awful.spawn.with_shell("mpc stop")       end),
   awful.key({ modkey, "Control" }, "Left",
      function () awful.spawn.with_shell("mpc prev")       end),
   awful.key({ modkey, "Control" }, "Right",
      function () awful.spawn.with_shell("mpc next")       end),

   -- Multimedia keys
   awful.key({                   }, "XF86AudioPlay",
    function() awful.spawn("mpc toggle")                   end),
   awful.key({                   }, "XF86AudioPrev",
    function() awful.spawn("mpc prev")                     end),
   awful.key({                   }, "XF86AudioNext",
    function() awful.spawn("mpc next")                     end),
   awful.key({                   }, "XF86AudioStop",
      function() awful.spawn("mpc stop")                   end),

   awful.key({ modkey,           }, "Tab",
      function()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end                                               end),

   awful.key({ modkey,           }, "i",
      function() run_firefox()                             end),
   awful.key({ modkey,           }, "x",
      function() run_hexchat()                             end),
   awful.key({ modkey,           }, "d",
      function() run_discord()                             end),

   -- awful.key({ modkey,           }, "c",
   --    function () awful.spawn("rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'") end),
   awful.key({ modkey, "Shift"   }, "t",
      function() awful.spawn("thunderbird")                end),

   awful.key({ modkey, "Control" }, "r", awesome.restart),
   awful.key({ modkey, "Shift"   }, "q", awesome.quit),

   awful.key({ modkey,           }, "l",
      function() awful.tag.incmwfact( 0.05)                end),
   awful.key({ modkey,           }, "h",
      function() awful.tag.incmwfact(-0.05)                end),
   awful.key({ modkey, "Shift"   }, "h",
      function() awful.tag.incnmaster( 1)                  end),
   awful.key({ modkey, "Shift"   }, "l",
      function() awful.tag.incnmaster(-1)                  end),
   awful.key({ modkey, "Control" }, "h",
      function() awful.tag.incncol( 1)                     end),
   awful.key({ modkey, "Control" }, "l",
      function() awful.tag.incncol(-1)                     end),
   awful.key({ modkey,           }, "space",
      function() awful.layout.inc(layouts,  1)             end),
   awful.key({ modkey, "Shift"   }, "space",
      function() awful.layout.inc(layouts, -1)             end),

   awful.key({ modkey, "Control" }, "n",     awful.client.restore),

   awful.key({ modkey },            "r",
      function() awful.screen.focused().mypromptbox:run()  end,
      {
         description = "run prompt",
         group = "launcher"
      })
)

clientkeys = awful.util.table.join(
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle),

   awful.key({ modkey,           }, "f",
      function (c) c.fullscreen = not c.fullscreen         end),
   awful.key({ modkey, "Shift"   }, "c",
      function (c) c:kill()                                end),
   awful.key({ modkey, "Control" }, "Return",
      function (c) c:swap(awful.client.getmaster())        end),
   awful.key({ modkey,           }, "o",
      function (c) c:move_to_screen()                      end),
   awful.key({ modkey,           }, "t",
      function (c) c.ontop = not c.ontop                   end),
   awful.key({ modkey,           }, "n",
      function (c) c.minimized = true                      end,
      {
         description = "minimize",
         group = "client"
      }),
   awful.key({ modkey,           }, "m",
      function (c)
         c.maximized = not c.maximized
         c:raise()                                         end,
      {
         description = "maximize",
         group = "client"
      })
)

for i = 1, 9 do
   globalkeys = awful.util.table.join(
      globalkeys,
      -- View tag only.
      awful.key({ modkey }, "#" .. i + 9,
         function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               tag:view_only()
            end
         end,
         {description = "view tag #"..i, group = "tag"}),
      -- Toggle tag display.
      awful.key({ modkey, "Control" }, "#" .. i + 9,
         function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               awful.tag.viewtoggle(tag)
            end
         end,
         {description = "toggle tag #" .. i, group = "tag"}),
      -- Move client to tag.
      awful.key({ modkey, "Shift" }, "#" .. i + 9,
         function()
            if client.focus then
               local tag = client.focus.screen.tags[i]
               if tag then
                  client.focus:move_to_tag(tag)
               end
            end
         end,
         {description = "move focused client to tag #"..i, group = "tag"}),
      -- Toggle tag on focused client.
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
         function()
            if client.focus then
               local tag = client.focus.screen.tags[i]
               if tag then
                  client.focus:toggle_tag(tag)
               end
            end
         end,
         {description = "toggle focused client on tag #" .. i, group = "tag"})
   )
end

clientbuttons = awful.util.table.join(
   awful.button({                   }, 1,
      function (c) client.focus = c; c:raise()              end),
   awful.button({ modkey            }, 1, awful.mouse.client.move),
   awful.button({ modkey            }, 3, awful.mouse.client.resize))

root.keys(globalkeys)

volume.bar:buttons(awful.util.table.join(
    awful.button({}, 2, function() -- middle click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 3, function() -- right click
          os.execute("pactl set-sink-mute " .. volume.device .. " toggle")
          volume.update()
    end),
    awful.button({}, 4, function() -- scroll up
          os.execute("pactl set-sink-volume " .. volume.device .. " +2%")
          volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
          os.execute("pactl set-sink-volume ".. volume.device .." -2%")
          volume.update()
    end)
))

awful.rules.rules = {
   { rule = { },
     properties = { border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    raise = true,
                    size_hints_honour = false,
                    keys = clientkeys,
                    buttons = clientbuttons,
                    screen = awful.screen.preferred,
                    placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
   },

   { rule_any = {
        instance = {
           "DTA",
           "copyq",
        },
        class = {
           "feh",
           "Arandr",
           "MPlayer",
           "Gpick",
           "Kruler",
           "MessageWin",
           "Sxiv",
           "Wpa_gui",
           "pinentry",
           "veromix",
           "gimp",
           "xtightvncviewer"},

        name = {
           "Emoji",
           "Event Tester",
        },
        role = {
           "AlarmWindow",
           "pop-up",
        }
   }, properties = { floating = true }},

   { rule_any = { type = { "dialog" } },
     properties = { titlebars_enabled = true } },

   { rule = { name = "rtorrent" }, -- 9
     properties = { screen = 1, tag = "😿" } },
   { rule = { name = "Ripcord Voice Chat" },
     properties = { floating = true } },

   { rule = { role = "conversation" }, -- for Pidgin & HexChat
     properties = { floating = true } },

   { rule = { class = "Firefox" }, -- 1
     properties = { screen = 1, tag = "🐱" } },
   { rule = { class = "Hexchat" }, -- 1
     properties = { screen = 2, tag = "💖" } },
   { rule = { class = "discord" }, -- 2
     properties = { screen = 1, tag = "🙀" } },
   { rule = { class = "Ripcord" }, -- 2
     properties = { screen = 1, tag = "🙀" } },
   { rule = { class = "keepassxc" }, -- 8
     properties = { screen = 1, tag = "😾" } },
   { rule = { class = "Audacious" }, -- for Winamp interface
     properties = { titlebars_enabled = false, ontop = true } },
}

client.connect_signal(
   "manage", function (c)
      if awesome.startup and
         not c.size_hints.user_position
      and not c.size_hints.program_position then
         awful.placement.no_offscreen(c)
      end
end)

client.connect_signal(
   "request::titlebars", function(c)
      local buttons = awful.util.table.join(
         awful.button({ }, 1, function()
               client.focus = c
               c:raise()
               awful.mouse.client.move(c)
         end),
         awful.button({ }, 3, function()
               client.focus = c
               c:raise()
               awful.mouse.client.resize(c)
         end)
      )

      awful.titlebar(c) : setup {
         { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
         },
         { -- Middle
            { -- Title
               align  = "center",
               widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
         },
         { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
         },
         layout = wibox.layout.align.horizontal
      }
end)

client.connect_signal("mouse::enter",
                      function(c)
                         if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                         and awful.client.focus.filter(c) then
                            client.focus = c
                         end
end)

client.connect_signal("focus",
                      function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus",
                      function(c) c.border_color = beautiful.border_normal end)

beautiful.useless_gap = 0

-- awful.spawn("xscreensaver -no-splash")

run_firefox()
run_discord()
run_hexchat()
run_rtorrent()
run_keepassxc()

-- Local Variables:
-- coding: utf-8-unix
-- indent-tabs-mode: nil
-- End:
