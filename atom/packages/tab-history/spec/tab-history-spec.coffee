TabHistory = require '../lib/tab-history'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "TabHistory", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('tabHistory')

  # describe "when the tab-history:toggle event is triggered", ->
  #   it "attaches and then detaches the view", ->
  #     expect(atom.workspaceView.find('.tab-history')).not.toExist()
  #
  #     # This is an activation event, triggering it will cause the package to be
  #     # activated.
  #     atom.workspaceView.trigger 'tab-history:toggle'
  #
  #     waitsForPromise ->
  #       activationPromise
  #
  #     runs ->
  #       expect(atom.workspaceView.find('.tab-history')).toExist()
  #       atom.workspaceView.trigger 'tab-history:toggle'
  #       expect(atom.workspaceView.find('.tab-history')).not.toExist()
