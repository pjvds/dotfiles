module.exports =
	activate: (state) ->
		atom.workspaceView.command "space-tab:convert-to-tabs", => @convertToTabs()
		atom.workspaceView.command "space-tab:convert-to-spaces", => @convertToSpaces()

	convertToTabs: ->
		editor = atom.workspace.activePaneItem
		spaceCount = editor.getTabLength()
		re = new RegExp "^(( {" + spaceCount + "})+)", 'g'
		textArray = editor.getText().split '\n'

		newTextArray = for line in textArray
			line = line.replace re, (_, spaces) ->
				len = spaces.length / spaceCount
				result = ''
				while result.length < len
					result += '\t'

				result

		result = newTextArray.join '\n'

		editor.setText result

	convertToSpaces: ->
		editor = atom.workspace.activePaneItem
		spaceCount = editor.getTabLength()
		re = new RegExp "^((\t)+)", 'g'
		textArray = editor.getText().split '\n'

		newTextArray = for line in textArray
			line = line.replace re, (_, tabs) ->
				len = tabs.length * spaceCount
				result = ''
				while result.length < len
					result += new Array(spaceCount + 1).join(' ')

				result

		result = newTextArray.join '\n'

		editor.setText result
