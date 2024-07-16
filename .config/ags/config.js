import StatusBar from './src/statusBar.js'
import QuickMenu from './src/quickMenu.js'
import AppLauncher from './src/appLauncher.js'

const scss = `${App.configDir}/src/style/style.scss`
const css = `${App.configDir}/out/style.css`
Utils.exec(`sass ${scss} ${css}`)

await App.config({
  style: css,
  windows: [
    StatusBar,
    QuickMenu,
    AppLauncher,
  ]
})
