{Subscriber} = require 'emissary'

class TabHistory
  constructor: (@paneView) ->
    Subscriber.extend @
    @pane = @paneView.model
    @mainModifierKeyCode = 17
    @items = []
    @isSwitching = false

  log: () ->
    # console.log { @isSwitching }
    # console.log @items.map((item) -> item.getTitle())

  isActivePane: -> atom.workspace.activePane == @pane

  activate: ->
    @subscribe @paneView, 'keyup', @onKeyUp.bind(@)

    @subscribe @paneView, 'pane:active-item-changed', @onActiveItemChanged.bind(@)
    @subscribe @paneView, 'pane:item-added', @onItemAdded.bind(@)
    @subscribe @paneView, 'pane:item-removed', @onItemRemoved.bind(@)

    atom.workspaceView.command "tab-history:previous", @previous.bind(@)
    atom.workspaceView.command "tab-history:next", @next.bind(@)

    @items = @pane.items.slice().reverse()
    @pushActiveItem()

  deactivate: ->
    @unsubscribe()
    @items = []

  onKeyUp: (event) ->
    if @isSwitching and event.keyCode == @mainModifierKeyCode
      @pushActiveItem()
      @isSwitching = false
    return

  onItemAdded: (event, item) ->
    return unless (item in @pane.items)
    @isSwitching = false
    @pushActiveItem()

  onActiveItemChanged: (event, item) ->
    return unless (item in @pane.items)
    return if @isSwitching
    @pushActiveItem()

  pushActiveItem: ->
    return if !@pane.activeItem
    @removePane(@pane.activeItem)
    @items.push(@pane.activeItem)
    @log()

  removePane: (paneItem) ->
    index = @items.indexOf paneItem
    return if index == -1
    @items.splice(index, 1)

  onItemRemoved: (event, item) ->
    @removePane(item)

  previous: (event) ->
    return unless @isActivePane()
    @isSwitching = true
    index = @items.indexOf @pane.activeItem
    if @items.length == 0
      @pane.activateNextItem()
      return
    @pane.activateItem(@items[(index + @items.length - 1) % @items.length])

  next: (event) ->
    return unless @isActivePane()
    @isSwitching = true
    index = @items.indexOf atom.workspace.activePaneItem
    if @items.length == 0
      @pane.activatePreviousItem()
      return
    @pane.activateItem(@items[(index + 1) % @items.length])

module.exports =
  activate: (state) ->
    @tabHistories = []
    @paneSubscription = atom.workspaceView.eachPaneView((paneView) =>
      tabHistory = new TabHistory(paneView)
      tabHistory.activate()
      @tabHistories.push(tabHistory)
      onPaneViewRemoved = (event, removedPaneView) =>
        return if paneView != removedPaneView
        tabHistory.deactivate()
        @tabHistories.splice(@tabHistories.indexOf(tabHistory), 1)
      atom.workspaceView.on('pane:removed', onPaneViewRemoved)
    )

  deactivate: ->
    @paneSubscription.off()
    for tabHistory in @tabHistories
      tabHistory.deactivate()
    @tabHistories = null
