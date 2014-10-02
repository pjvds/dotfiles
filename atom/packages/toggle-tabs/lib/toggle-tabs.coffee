tabsVisible = true
module.exports =
  configDefaults:
    hiddenByDefault: false

  activate: ->
    atom.workspaceView.ready ->
      atom.workspaceView.find('.tab-bar').toggle(
        !atom.config.get('toggle-tabs.hiddenByDefault')
      )

    atom.workspaceView.command "toggle-tabs:toggle", => @toggle()

    atom.config.observe 'toggle-tabs.hiddenByDefault', =>

      if atom.config.get('toggle-tabs.hiddenByDefault')
        atom.workspaceView.find('.tab-bar').hide(150)
      else
        atom.workspaceView.find('.tab-bar').show(150)

  toggle: ->
    atom.workspaceView.find('.tab-bar').slideToggle(150)
