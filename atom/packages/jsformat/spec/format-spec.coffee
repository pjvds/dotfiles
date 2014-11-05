{WorkspaceView} = require 'atom'
require 'fs'

format = require '../lib/format'

describe "JSFormat package tests", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView()
    atom.workspace = atom.workspaceView.getModel()

  # JSFormat tests here

  describe "when the textbuffer is being formatted", ->
    beforeEach ->
      atom.workspaceView.attachToDom()

    it "can format the whole buffer with the use of the command", ->
      # general format test

      waitsForPromise ->
        atom.workspace.open('specfiles/index.js')

      runs ->
        @fileText = atom.workspace.getActiveTextEditor().getText()
        atom.workspaceView.getActiveView().trigger 'jsformat:format'

      runs ->
        # just check that some whitespace and other goodies got added
        expect(atom.workspace.getActiveTextEditor().getText()).not.toMatch(@fileText)

    it "can format a selection of the whole buffer with the use of the command", ->
      # general selected text format test

      waitsForPromise ->
        atom.workspace.open('specfiles/index.js')

      runs ->
        # select text until end of first require
        atom.workspace.getActiveTextEditor().setSelectedBufferRange([[0, 0], [14, 7]])
        @fileText = atom.workspace.getActiveTextEditor().getSelectedText()
        @restOfFileText = atom.workspace.getActiveTextEditor().getTextInBufferRange([[15, 0], [31, 0]])
        atom.workspaceView.getActiveView().trigger 'jsformat:format'

      runs ->
        # check that some whitespace and other goodies got added
        expect(atom.workspace.getActiveTextEditor().getSelectedText()).not.toMatch(@fileText)
        # check that the rest of the file wasn't touched
        expect(atom.workspace.getActiveTextEditor().getTextInBufferRange([[15, 0], [31, 0]])).not.toMatch(@restOfFileText)


    it "can format the whole buffer if Format on save is turned on", ->
      # format_on_save test

      waitsForPromise ->
        atom.workspace.open('specfiles/index.js')

      runs ->
        fileText = atom.workspace.getActiveTextEditor().getText()
        atom.config.set('jsformat.format_on_save', true)
        atom.workspace.getActiveTextEditor().save()

        # just check that some whitespace and other goodies got added
        expect(atom.workspace.getActiveTextEditor().getText()).not.toMatch(fileText)
        atom.config.set('jsformat.format_on_save', false)

    it "can subscribe and unsubscribe to editors when format_on_save is enabled and editors are opened and closed", ->
      # format_on_save test

      waitsForPromise ->
        spyOn(format, 'subscribeToEvents').andCallThrough()
        atom.workspace.open('specfiles/index.js')

      waitsForPromise ->
        atom.packages.activatePackage('jsformat')

      runs ->
        atom.config.set('jsformat.format_on_save', true)
        console.log(format.editorSaveSubscriptions)
        console.log(format.editorCloseSubscriptions)
        atom.workspace.getActiveTextEditor().destroy()

        atom.workspace.open('file.js')
        console.log(format.editorSaveSubscriptions)
        console.log(format.editorCloseSubscriptions)
        # atom.workspace.getActiveTextEditor().destroy()
        # expect(format.editorSaveSubscriptions)

        # expect()
        # TODO add a check here to see that the subscriptions were disposed and deleted from the objects

    it "can subscribe and unsubscribe to events when format_on_save is changed", ->
      # format_on_save test

      waitsForPromise ->
        spyOn(format, 'subscribeToEvents').andCallThrough()
        atom.workspace.open('specfiles/index.js')

      waitsForPromise ->
        atom.packages.activatePackage('jsformat')

      runs ->
        # check that subscribeToEvents has run after toggling format_on_save
        expect(format.subscribeToEvents.callCount).toEqual(1)
        atom.config.set('jsformat.format_on_save', false)

      # waitsFor ->
        expect(format.subscribeToEvents.callCount).toEqual(2)
        atom.config.set('jsformat.format_on_save', true)
      # , "Waiting for subscribeToEvents to run", 250

      # waitsFor ->
        expect(format.subscribeToEvents.callCount).toEqual(3)
      # , "Wait for subscribeToEvents to run", 250

    it "displays a notification for unsupported languages", ->
      # NotSupportedNotificationView test

      waitsForPromise ->
        atom.packages.activatePackage('jsformat')

      waitsForPromise ->
        spyOn(format, 'displayUnsupportedLanguageNotification').andCallThrough()
        atom.workspace.open('xyz.coffee')

      runs ->
        atom.workspaceView.getActiveView().trigger('jsformat:format')

        expect(format.displayUnsupportedLanguageNotification).toHaveBeenCalled()
        expect(format.displayUnsupportedLanguageNotification.callCount).toEqual(1)
