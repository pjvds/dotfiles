{View} = require 'atom'
path = require 'path'

module.exports =
class NotSupportedNotificationView extends View
  constructor: (state, @message) ->
    this.message = @message
    super(state)

  @content: ->
    editor = atom.workspace.activePaneItem
    title = editor.getTitle()
    ext = path.extname title
    message = ext.length > 0 ? ext : title

    @div class: 'test overlay from-top', =>
      @div "Format: '#{message}' files not yet supported.", class: "message"
