{WorkspaceView} = require 'atom'
ToggleTabs = require '../lib/toggle-tabs'

describe "ToggleTabs", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    @tabBar = atom.workspaceView.find('.tab-bar')

  describe 'when the toggle-tabs:toggle event is triggered', ->
    it 'toggles the visibility of the tabBar', ->
      expect(@tabBar).toBeVisible
      atom.workspaceView.trigger 'toggle-tabs:toggle'
      expect(@tabBar).toBeHidden
      atom.workspaceView.trigger 'toggle-tabs:toggle'
      expect(@tabBar).toBeVisible

  # describe 'the hideTabsByDefault config option', ->
  #   it 'shows and hides the tabs by default based on the option value', ->
