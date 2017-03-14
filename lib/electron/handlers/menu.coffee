_     = require("lodash")
os    = require("os")
Menu  = require("electron").Menu
shell = require("electron").shell

onUpdatesClicked = ->
onLogOutClicked = ->

module.exports = {
  set: (options = {}) ->
    _.defaults(options, {
      withDevTools: false
    })

    ## these are set by modes/headed.coffee and need to be preserved
    ## if the menu is set again by launcher.coffee when the Electron
    ## browser is run
    if options.onUpdatesClicked
      onUpdatesClicked = options.onUpdatesClicked
    if options.onLogOutClicked
      onLogOutClicked = options.onLogOutClicked

    template = [
      {
        label: "File"
        submenu: [
          {
            label: "Changelog"
            click: ->
              shell.openExternal("https://on.cypress.io/changelog")
          }
          {
            label: "Check for Updates"
            click: onUpdatesClicked
          }
          {
            type: "separator"
          }
          {
            label: "Manage Account"
            click: ->
              shell.openExternal("https://on.cypress.io/dashboard")
          }
          {
            label: "Log Out"
            click: onLogOutClicked
          }
          {
            type: "separator"
          }
          {
            label: "Close Window"
            accelerator: "CmdOrCtrl+W"
            role: "close"
          }
        ]
      }
      {
        label: "Edit"
        submenu: [
          {
            label: "Undo"
            accelerator: "CmdOrCtrl+Z"
            role: "undo"
          }
          {
            label: "Redo"
            accelerator: "Shift+CmdOrCtrl+Z"
            role: "redo"
          }
          {
            type: "separator"
          }
          {
            label: "Cut"
            accelerator: "CmdOrCtrl+X"
            role: "cut"
          }
          {
            label: "Copy"
            accelerator: "CmdOrCtrl+C"
            role: "copy"
          }
          {
            label: "Paste"
            accelerator: "CmdOrCtrl+V"
            role: "paste"
          }
          {
            label: "Select All"
            accelerator: "CmdOrCtrl+A"
            role: "selectall"
          }
        ]
      }
      {
        label: "Window"
        role: "window"
        submenu: [
          {
            label: "Minimize"
            accelerator: "CmdOrCtrl+M"
            role: "minimize"
          }
        ]
      }
      {
        label: "Help"
        role: "help"
        submenu: [
          {
            label: "Report an Issue.."
            click: ->
              shell.openExternal("https://on.cypress.io/new-issue")
          }
          {
            label: "Cypress Documentation"
            click: ->
              shell.openExternal("https://on.cypress.io")
          }
          {
            label: "Cypress Chat"
            click: ->
              shell.openExternal("https://on.cypress.io/chat")
          }
        ]
      }
    ]

    if os.platform() is "darwin"
      name = "Cypress"
      template.unshift({
        label: name
        submenu: [
          {
            label: "About #{name}"
            role: "about"
          }
          {
            type: "separator"
          }
          {
            label: "Services"
            role: "services"
            submenu: []
          }
          {
            type: "separator"
          }
          {
            label: "Hide #{name}"
            accelerator: "Command+H"
            role: "hide"
          }
          {
            label: "Hide Others"
            accelerator: "Command+Shift+H"
            role: "hideothers"
          }
          {
            label: "Show All"
            role: "unhide"
          }
          {
            type: "separator"
          }
          {
            label: "Quit"
            accelerator: "Command+Q"
            #role: "quit" ## must upgrade to latest electron
            click: (item, focusedWindow) =>
              process.exit(0)
          }
        ]
      })

    if options.withDevTools
      template.push(
        {
          label: "Developer Tools"
          submenu: [
            {
              label: 'Reload'
              accelerator: 'CmdOrCtrl+R'
              click: (item, focusedWindow) =>
                focusedWindow.reload() if focusedWindow
            }
            {
              label: 'Toggle Developer Tools'
              accelerator: do ->
                if os.platform() is 'darwin'
                  'Alt+Command+I'
                else
                  'Ctrl+Shift+I'
              click: (item, focusedWindow) =>
                focusedWindow.toggleDevTools() if focusedWindow
            }
          ]
        }
      )

    menu = Menu.buildFromTemplate(template)

    Menu.setApplicationMenu(menu)
}
