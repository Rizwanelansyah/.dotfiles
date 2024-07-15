const hyprland = await Service.import("hyprland")
import Gtk from 'gi://Gtk'

export default async () => {
  const Grid = Widget.subclass(Gtk.Grid)
  const Menu = Grid({
    className: "quick-menu",
    columnSpacing: 10,
    rowSpacing: 5,
  })

  Menu.attach(Widget.Button({
    className: "off",
    label: " ",
    tooltipText: "Shutdown The System",
    cursor: "pointer",
    onClicked: () => Utils.execAsync("shutdown now"),
  }), 1, 1, 1, 1)

  Menu.attach(Widget.Button({
    className: "restart",
    label: " ",
    tooltipText: "Restart The System",
    cursor: "pointer",
    onClicked: () => Utils.execAsync("reboot"),
  }), 2, 1, 1, 1)

  Menu.attach(Widget.Button({
    className: "logout",
    label: " ",
    tooltipText: "Logout To Greetd",
    cursor: "pointer",
    onClicked: () => hyprland.messageAsync("dispatch exit"),
  }), 3, 1, 1, 1)

  return Widget.Window({
    monitor: 0,
    name: "quick-menu",
    anchor: ["top", "right"],
    layer: "overlay",
    margins: [2, 5],
    child: Menu,
  })
}
