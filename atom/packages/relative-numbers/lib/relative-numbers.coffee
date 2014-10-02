{$} = require 'atom'

module.exports =
  configDefaults:
    displayTrueLineNumberOnCurrentLine: false

  activate: (state) ->
    atom.workspaceView.eachEditorView (editorView) =>
      currentLineNumber = editorView.getEditor().getCursorScreenRow()
      totalLines = editorView.getEditor().getLineCount()
      @_recalculateLineNumbers(currentLineNumber, totalLines)

      events = [ 'core:move-up', 'vim-mode:move-up', 'core:move-down', 'vim-mode:move-down' ]
      editorView.on events.join(' '), =>
        atom.workspaceView.eachEditorView (editorView) =>
          currentLineNumber = editorView.getEditor().getCursorScreenRow()
          totalLines = editorView.getEditor().getLineCount()
          @_recalculateLineNumbers(currentLineNumber, totalLines)

  _recalculateLineNumbers: (currentLineNumber, totalLines) ->
    currentRow = @_getRowElementByLineNumber(currentLineNumber)

    if atom.config.get("relative-numbers.displayTrueLineNumberOnCurrentLine")
      trueLineNumber = currentLineNumber + 1
      @_setNewRowNumber(currentRow, trueLineNumber)
    else
      @_setNewRowNumber(currentRow, 0)

    @_recalculateBeforeCurrentRow(currentLineNumber)
    @_recalculateAfterCurrentRow(currentLineNumber, totalLines)

  _getRowElementByLineNumber: (lineNumber) ->
    $('.line-number[data-screen-row="' + lineNumber + '"]')

  _setNewRowNumber: (rowElement, newNumber) ->
    $(rowElement).html("&nbsp;#{newNumber}<div class=\"icon-right\"></div>")

  _recalculateBeforeCurrentRow: (currentLineNumber) ->
    counter = 1
    start = currentLineNumber - 1
    for i in [start...-1]
      row = @_getRowElementByLineNumber(i)
      @_setNewRowNumber(row, counter++)

  _recalculateAfterCurrentRow: (currentLineNumber, totalLines) ->
    counter = 1
    start = currentLineNumber + 1
    for i in [start...totalLines]
      row = @_getRowElementByLineNumber(i)
      @_setNewRowNumber(row, counter++)
