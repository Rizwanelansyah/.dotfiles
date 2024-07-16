const notifications = await Service.import("notifications")
const altTimeOut = 5000

function NotificationIcon({ app_entry, app_icon, image }) {
  if (image) {
    return Widget.Icon({
      className: "icon",
      icon: image,
    })
  }

  let icon = null
  if (Utils.lookUpIcon(app_icon))
    icon = app_icon

  if (app_entry && Utils.lookUpIcon(app_entry))
    icon = app_entry

  return Widget.Box({
    hexpand: true,
    vexpand: true,
    child: icon ? Widget.Icon({
      className: "icon",
      icon,
    }) : Widget.Label({
      className: "nerd-icon",
      label: " ",
    }),
  })
}

function Notification(n) {
  const Content = Widget.Box({
    children: [
      NotificationIcon(n),
      Widget.Box({
        className: "content",
        vertical: true,
        spacing: 4,
        children: [
          Widget.Label({
            maxWidthChars: 30,
            truncate: "end",
            className: "title",
            xalign: 0,
            label: n.summary,
          }),
          Widget.Label({
            maxWidthChars: 30,
            className: "body",
            wrap: true,
            xalign: 0,
            label: n.body,
          }),
        ],
      })
    ],
  })

  const Actions = Widget.Box({
    className: "actions",
    hexpand: true,
    spacing: 4,
    children: n.actions.map(({ id, label }) => Widget.Button({
      label,
      hexpand: true,
      onClicked: () => {
        n.invoke(id)
        n.dismiss()
        n.close()
      },
    })),
  })

  return Widget.Box({
    className: "notification",
    vertical: true,
    attribute: n,
    spacing: 5,
    children: [
      Widget.EventBox({
        child: Content,
        onPrimaryClick: () => {
          n.dismiss()
        }
      }),
      Actions,
    ],
    setup: self => {
      Utils.timeout(altTimeOut, () => {
        self.destroy()
      })
    }
  })
}

const list = Widget.Box({
  vertical: true,
  children: notifications.popups.map(Notification),
})

function onNotified(_, id) {
  const n = notifications.getNotification(id)
  if (n && !notifications.dnd) {
    list.children = [Notification(n), ...list.children]
  }
}

function onDismissed(_, id) {
  list.children.find(n => n.attribute.id === id)?.destroy()
}

list.hook(notifications, onNotified, "notified")
  .hook(notifications, onDismissed, "dismissed")

export default Widget.Window({
  monitor: 0,
  name: "notification",
  class_name: "notification-popups",
  anchor: ["top", "bottom", "right"],
  child: Widget.Box({
    css: "min-width: 2px; min-height: 2px;",
    class_name: "notifications",
    vertical: true,
    child: list,
  }),
})
