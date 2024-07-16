const { query } = await Service.import("applications")
const WINDOW_NAME = "app-launcher"

const AppItem = app => Widget.Button({
  className: "app-item",
  onClicked: () => {
    App.closeWindow(WINDOW_NAME)
    app.launch()
  },
  attribute: { app },
  child: Widget.Box({
    children: [
      Widget.Icon({
        className: "icon",
        icon: app.iconName || "",
        size: 30,
      }),
      Widget.Label({
        className: "title",
        label: app.name,
        xalign: 0,
        hexpand: true,
        truncate: "end",
      }),
    ],
  }),
})

const Applauncher = () => {
  let applications = query("").map(AppItem)

  const list = Widget.Box({
    className: "list",
    spacing: 8,
    vertical: true,
    children: applications,
  })

  function repopulate() {
    applications = query("").map(AppItem)
    list.children = applications
  }

  const entry = Widget.Entry({
    hexpand: true,
    onAccept: () => {
      const results = applications.filter((item) => item.visible);
      if (results[0]) {
        App.toggleWindow(WINDOW_NAME)
        results[0].attribute.app.launch()
      }
    },

    onChange: ({ text }) => applications.forEach(item => {
      item.visible = item.attribute.app.match(text ?? "")
    }),
  })

  return Widget.Box({
    vertical: true,
    className: "app-launcher",
    children: [
      Widget.Box({
        className: "search-bar",
        hexpand: true,
        children: [
          Widget.Label({
            className: "icon",
            label: " ",
          }),
          entry,
        ],
      }),
      Widget.Scrollable({
        className: "apps",
        hscroll: "never",
        vexpand: true,
        child: list,
      }),
    ],
    setup: self => self.hook(App, (_, windowName, visible) => {
      if (windowName !== WINDOW_NAME)
        return

      if (visible) {
        repopulate()
        entry.text = ""
        entry.grab_focus()
      }
    }),
  })
}

export default Widget.Window({
  name: WINDOW_NAME,
  setup: self => self.keybind("Escape", () => {
    App.closeWindow(WINDOW_NAME)
  }).keybind(["CONTROL"], "a", () => {
    self.child.children[0].children[1].grab_focus()
  }),
  anchor: ["top", "left"],
  visible: false,
  margin: [20, 20],
  keymode: "exclusive",
  child: Applauncher(),
})
