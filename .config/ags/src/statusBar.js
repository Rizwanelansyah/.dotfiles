const hyprland = await Service.import("hyprland")
const battery = await Service.import("battery")
const apps = await Service.import("applications")

const kiloToGiga = (kilo, trail = 1) => Math.floor(kilo / (1_000_000 / (Math.pow(10, trail)))) / Math.pow(10, trail)

const StatusPart = (pack, ...childs) => Widget.Box({
  spacing: 4,
  className: pack,
  hpack: pack,
  vertical: false,
  children: childs,
})

const infoDisplay = (name, icon, child, expandedDefault = true, setup = (self) => {}) => Widget.Box({
  className: `${name} info-display`,
  attribute: expandedDefault,
  spacing: expandedDefault ? 5 : 0,
  vpack: "center",
  cursor: "pointer",
  children: [],
  setup: self => {
    const toggle = () => {
      self.attribute = !self.attribute
      self.children[1].revealChild = self.attribute
      if (self.attribute) {
        self.spacing = 5
      } else {
        self.spacing = 0
      }
    }
    self.children = [
      Widget.Button({
        className: 'icon',
        label: icon,
        onClicked: toggle,
        cursor: "pointer",
      }),
      Widget.Revealer({
        revealChild: self.attribute,
        transition: 'slide_right',
        child: Widget.Button({
          className: 'content',
          child,
          onClicked: toggle,
          cursor: "pointer",
        })
      }),
    ]
    setup(self)
  }
})

const rewriteWorkspaceNr = (nr) => {
  const wp = hyprland.workspaces[nr-1]
  let txt = ([
    " ", "󰖟 ", " ", "󰟃 "
  ][nr-1] || nr).toString()
  if (wp === undefined || wp === null) {
    return txt
  }
  if (wp.id.toString() !== wp.name && wp.name !== "special:magic") {
    txt += ` ${wp.name}`
  }
  return txt
}

export default async () => {
  const Os = Widget.Label({
    className: "os-logo",
    label: "󰣇",
  })

  const Workspaces = Widget.EventBox({
    child: Widget.Box({
      className: "workspaces",
      spacing: 4,
      valign: "center",
      children: [
        Widget.Button({
          attribute: 0,
          className: "workspace special",
          label: ` `,
          onClicked: () => hyprland.messageAsync(`dispatch togglespecialworkspace magic`),
        }),
        ...Array.from({ length: 10 }, (_, i) => i + 1).map(i => Widget.Button({
          attribute: i,
          className: "workspace",
          label: `${rewriteWorkspaceNr(i)}`,
          onClicked: () => hyprland.messageAsync(`dispatch workspace ${i}`),
        }))
      ],

      setup: self => self.hook(hyprland, () => self.children.forEach(btn => {
        if (hyprland.active.workspace.id == btn.attribute) {
          btn.toggleClassName("active", true)
        } else {
          btn.toggleClassName("active", false)
        }
        btn.visible = hyprland.workspaces.some(ws => ws.id === btn.attribute)
        if (btn.visible) {
          btn.label = `${rewriteWorkspaceNr(btn.attribute)}`
        }
        if (btn.attribute == 0 ) {
          btn.visible = hyprland.workspaces.some(ws => {
            const isMagic = ws.name == "special:magic"
            if (isMagic) {
              btn.label = ` ${ws.windows > 1 ? ws.windows : ""}`
            }
            return isMagic
          })
        }
      })),
    }),
  })

  const WindowTitle = Widget.Box({
    className: "window-title",
    spacing: 6,
    children: [
      Widget.Icon({
        className: "icon",
        icon: (() => {
          const className = hyprland.active.client.class
          const app = apps.query(className)[0]
          if (!app) {
            return ""
          } else {
            return app.iconName
          }
        })(),
        size: 20,
      }),
      Widget.Label({
        maxWidthChars: 40,
        className: 'title',
        justification: 'left',
        truncate: 'end',
        label: hyprland.active.client.title,
      }),
    ],
    visible: hyprland.active.client.bind("address").as(addr => !!addr),
    setup: self => self.hook(hyprland, () => {
      const className = hyprland.active.client.class
      let app = apps.query(className)[0]
      if (!app || className == "") {
        self.children[0].icon = ""
        self.children[0].visible = false
      } else {
        self.children[0].visible = true
        self.children[0].icon = app.iconName
      }
      self.children[1].label = hyprland.active.client.title
    }),
  })

  const dateTime = Variable('')
  Utils.interval(1000, async () => {
    dateTime.value = await Utils.execAsync("date +'%H:%M:%S-%A %B %Y'")
  })

  const TimeInfo = infoDisplay("time", " ", Widget.Label({ label: dateTime.bind().as(dt => dt.split("-")[0]) }))
  const DateInfo = infoDisplay("date", " ", Widget.Label({ label: dateTime.bind().as(dt => dt.split("-")[1]) }))

  const memory = Variable({ free: 0, used: 0, total: 0 })
  Utils.interval(1000, async () => {
    const [total, _, free] = Utils.exec("bash -c \"head -n 3 /proc/meminfo | awk '{print $2;}'\"").split("\n")
    memory.value = {
      total,
      free,
      used: total - free,
    }
  })

  const Memory = infoDisplay("memory", " ", Widget.Label({ label: memory.bind().as(mem => `${kiloToGiga(mem.used)}/${kiloToGiga(mem.total)}G`) }), true, self => {
    self.hook(memory, () => {
      self.tooltipText = `Memory:\nTotal: ${kiloToGiga(memory.value.total, 3)}GB\nUsed: ${kiloToGiga(memory.value.used, 3)}GB\nFree: ${kiloToGiga(memory.value.free, 3)}GB`
    })
  })

  const Battery = Widget.Box({
    className: "battery",
    spacing: 5,
    children: [
      Widget.Label({
        className: "percentage",
        label: battery.bind('percent').as(p => `${p}%`),
      }),
      Widget.Overlay({
        child: Widget.LevelBar({
          className: "bar",
          vpack: "center",
          widthRequest: 28,
          heightRequest: 15,
          value: battery.bind("percent").as(p => p / 100),
        }),
        overlays: [
          Widget.Label({
            className: "icon",
            label: "",
          }),
        ],
        setup: self => self.hook(battery, () => {
          self.child.value = battery.percent / 100

          if (battery.percent > 40) {
            self.toggleClassName("warning", false)
            self.toggleClassName("danger", false)
            self.overlays[0].label = ""
          } else if (battery.percent > 20) {
            self.toggleClassName("warning", true)
            self.toggleClassName("danger", false)
            self.overlays[0].label = " "
          } else {
            self.toggleClassName("warning", false)
            self.toggleClassName("danger", true)
            self.overlays[0].label = " "
          }
          self.toggleClassName("charging", battery.charging)
          if (battery.charging) {
            self.overlays[0].label = ""
          }
          self.tooltipText = ""
          if (battery.charging) {
            self.tooltipText = `${battery.timeRemaining}s Remaining To Fully Charged\n`
          } else if (battery.percent < 30) {
            self.tooltipText = `This Machine Life Is ${battery.timeRemaining}s Remaining\n`
          }
          self.tooltipText = (self.tooltipText || "") + `Percentage: ${battery.percent}%\nEnergy: ${battery.energy}W of ${battery.energyFull}W\nEnergy Rate: ${battery.energyRate}W`
        })
      })
    ],
  })

  const Power = Widget.Button({
    className: "power-button",
    vpack: "center",
    cursor: "pointer",
    label: " ",
    onPrimaryClick: (_, event) => {
      App.toggleWindow("quick-menu")
    },
  })

  const Left = StatusPart("start", Os, Workspaces, WindowTitle)
  const Center = StatusPart("center", TimeInfo, DateInfo)
  const Right = StatusPart("end", Memory, Battery, Power)

  return Widget.Window({
    monitor: 0,
    name: `status-bar`,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    layer: "background",
    child: Widget.CenterBox({
      className: "status-bar",
      startWidget: Left,
      centerWidget: Center,
      endWidget: Right,
    }),
  }).hook(App, (self, windowName, visible) => {
      if (windowName == self.name && !visible) {
        App.closeWindow("quick-menu")
      }
    })
}
