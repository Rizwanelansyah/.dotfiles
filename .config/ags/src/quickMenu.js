import Gtk from 'gi://Gtk'
import brightness from "./brightness.js"

const hyprland = await Service.import("hyprland")
const audio = await Service.import("audio")
const network = await Service.import("network")
const bluetooth = await Service.import("bluetooth")
const battery = await Service.import("battery")
const notifications = await Service.import("notifications")

const Grid = Widget.subclass(Gtk.Grid)
const date = Variable({ day: 0, month: 0, year: 0, dayName: "", monthName: "" })
const fetchData = async () => {
  const out = await Utils.execAsync("date +'%d-%m-%Y-%A-%B'")
  const [ day, month, year, dayName, monthName ] = out.split("-")
  date.value = {
    day: Number(day),
    month: Number(month),
    year: Number(year),
    dayName, monthName,
  }
}
await fetchData()

const Menu = Grid({
  className: "quick-menu",
  columnSpacing: 10,
  rowSpacing: 5,
})

Menu.attach(Widget.Box({
  className: "volume",
  children: [
    Widget.Button({
      className: "icon",
      label: " ",
      onClicked: self => {
        audio.speaker.stream.isMuted = !audio.speaker.stream.isMuted
      },
      setup: self => self.hook(audio, () => {
        if (audio.speaker.isMuted || audio.speaker.volume == 0) {
          self.label = " "
        } else {
          const vol = audio.speaker.volume
          if (vol > 0.5) {
            self.label = " "
          } else {
            self.label = " "
          }
        }
      })
    }),
    Widget.Label({
      className: "percentage",
      label: audio.speaker.bind("volume").as(v => `${Math.floor(v * 100)}%`),
    }),
    Widget.Slider({
      className: "slider",
      hexpand: true,
      drawValue: false,
      onChange: ({ value }) => audio.speaker.volume = value,
      value: audio.speaker.bind("volume"),
    })
  ],
}), 1, 1, 3, 1)

Menu.attach(Widget.Box({
  className: "brightness",
  children: [
    Widget.Label({
      className: "icon",
      label: "󰃟 ",
      setup: self => self.hook(brightness, (_, value) => {
        if (value > 0.9) {
          self.label = "󰃡 "
        } else if (value > 0.5) {
          self.label = "󰃠 "
        } else if (value > 0.2) {
          self.label = "󰃟 "
        } else {
          self.label = "󰃞 "
        }
      })
    }),
    Widget.Label({
      className: "percentage",
      label: brightness.bind("screen-value").as(v => `${Math.floor(v * 100)}%`),
    }),
    Widget.Slider({
      className: "slider",
      hexpand: true,
      drawValue: false,
      onChange: self => brightness.screen_value = self.value,
      value: brightness.bind('screen-value'),
    })
  ],
}), 1, 2, 3, 1)

Menu.attach(Widget.Button({
  className: "wifi",
  label: "󰖩 ",
  attribute: false,
  tooltipText: "Primary Click: Toggle Wifi\nSecondary Click: Open Wifi List",
  cursor: "pointer",
  onPrimaryClick: self => network.wifi.enabled = !network.wifi.enabled,
  onSecondaryClick: self => {
    // TODO: open an wifi list window
  },
  setup: self => self.hook(network, () => {
    self.toggleClassName("active", network.wifi.enabled)
  }),
}), 1, 8, 1, 1)

Menu.attach(Widget.Button({
  className: "bluetooth",
  label: " ",
  tooltipText: "Primary Click: Toggle Bluetooth\nSecondary Click: Open Bluetooth List",
  cursor: "pointer",
  onPrimaryClick: self => bluetooth.enabled = !bluetooth.enabled,
  onSecondaryClick: self => {
    // TODO: open an wifi list window
  },
  setup: self => self.hook(bluetooth, () => {
    self.toggleClassName("active", bluetooth.enabled)
  }),
}), 2, 8, 1, 1)

Menu.attach(Widget.Button({
  className: "do-not-disturb",
  attribute: notifications.dnd,
  label: " ",
  tooltipText: "Do Not Disturb",
  cursor: "pointer",
  onClicked: self => {
    self.attribute = !self.attribute
    notifications.dnd = self.attribute
    self.toggleClassName("active", self.attribute)
    if (self.attribute) {
      self.label = "󰂛 "
    } else {
      self.label = " "
    }
  },
}), 3, 8, 1, 1)

Menu.attach(Widget.Button({
  className: "off",
  label: " ",
  tooltipText: "Shutdown The System",
  cursor: "pointer",
  onClicked: () => Utils.execAsync("shutdown now"),
}), 1, 9, 1, 1)

Menu.attach(Widget.Button({
  className: "restart",
  label: " ",
  tooltipText: "Restart The System",
  cursor: "pointer",
  onClicked: () => Utils.execAsync("reboot"),
}), 2, 9, 1, 1)

Menu.attach(Widget.Button({
  className: "logout",
  label: " ",
  tooltipText: "Logout To Greetd",
  cursor: "pointer",
  onClicked: () => hyprland.messageAsync("dispatch exit"),
}), 3, 9, 1, 1)

Menu.attach(Widget.Box({
  className: "day-month",
  vertical: true,
  vexpand: true,
  hexpand: true,
  children: [
    Widget.Label({ label: date.bind().as(d => d.day < 10 ? `0${d.day}` : `${d.day}`) }),
    Widget.Separator({ vertical: true }),
    Widget.Label({ label: date.bind().as(d => d.month < 10 ? `0${d.month}` : `${d.month}`) }),
  ],
  tooltipText: date.bind().as(d => `Day: ${d.dayName}/${d.day}\nMonth: ${d.monthName}/${d.month}`),
}), 1, 10, 1, 2)

Menu.attach(Widget.CircularProgress({
  className: "battery",
  hexpand: true,
  vexpand: true,
  rounded: true,
  inverted: false,
  startAt: 0.75,
  value: battery.bind('percent').as(p => p / 100),
  child: Widget.Label({
    className: "percentage",
    label: battery.bind('percent').as(p => `${p}%`),
  }),
}), 2, 10, 2, 2)

Menu.attach(Widget.Label({
  className: "os-logo",
  label: "󰣇 ",
}), 3, 13, 1, 1)

Menu.attach(Widget.Label({
  className: "wm-logo",
  label: " ",
}), 3, 14, 1, 1)

const NotifItem = (n) => Widget.Box({
  attribute: n,
  className: "notif-item",
  children: [
    Widget.Icon({
      className: "icon",
      icon: n.appIcon,
    }),
    Widget.Button({
      className: "title",
      hexpand: true,
      label: n.summary,
      cursor: "pointer",
      onPrimaryClick: (self, event) => {
        if (n.actions.length < 1)
          return
        const menu = Widget.Menu({
          children: [
            Widget.MenuItem({
              child: Widget.Label('hello'),
            }),
          ],
          children: n.actions.map(({ id, label }) => Widget.MenuItem({
            child: Widget.Label(label),
            onActivate: () => {
              n.invoke(id)
              n.close()
            }
          }))
        })
        menu.popup_at_pointer(event)
      },
    }),
    Widget.Button({
      className: "dismiss",
      label: " ",
      cursor: "pointer",
      onClicked: () => {
        n.close()
      }
    })
  ],
})

const Notifications = Widget.Box({
  vertical: true,
  spacing: 4,
  children: notifications.notifications.map(NotifItem)
}).hook(notifications, self => {
  self.children = notifications.notifications.map(NotifItem)
})

Menu.attach(Widget.Scrollable({
  className: "notifications",
  hexpand: true,
  vexpand: true,
  child: Notifications,
}), 1, 13, 2, 2)

export default Widget.Window({
  monitor: 0,
  name: "quick-menu",
  widthRequest: 350,
  heightRequest: 600,
  anchor: ["top", "right"],
  layer: "overlay",
  keymode: "on-demand",
  visible: false,
  child: Menu,
}).hook(App, async (self, windowName, visible) => {
  if (windowName === self.name && visible) {
    await fetchData()
  }
}).keybind("Escape", self => {
  App.closeWindow(self.name)
})
