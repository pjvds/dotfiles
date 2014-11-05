linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
findFile = require "#{linterPath}/lib/util"

class LinterJsxhint extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.js.jsx']

  linterName: 'jsxhint'

  # A regex pattern used to extract information from the executable's output.
  regex:
    '((?<fail>ERROR: .+)|' +
    '.+?: line (?<line>[0-9]+), col (?<col>[0-9]+), ' +
    '(?<message>.+) ' +
    # capture error, warning and code
    '\\(((?<error>E)|(?<warning>W))(?<code>[0-9]+)\\)'+
    ')'

  isNodeExecutable: yes

  constructor: (editor) ->
    super(editor)

    atom.config.observe 'linter-jsxhint.jsxhintExecutablePath', @formatShellCmd

    @formatShellCmd()

  formatShellCmd: =>
    jsxhintExecutablePath = atom.config.get 'linter-jsxhint.jsxhintExecutablePath'
    @cmd = ['jsxhint', '--verbose', '--extract=auto']
    config = findFile @cwd, ['.jshintrc']
    if config
      @cmd = @cmd.concat ['-c', config]
    @executablePath = "#{jsxhintExecutablePath}"

  formatMessage: (match) ->
    type = if match.error
      "E"
    else if match.warning
      "W"
    else
      warn "Regex does not match lint output", match
      ""

    "#{match.message} (#{type}#{match.code})"

  destroy: ->
    atom.config.unobserve 'linter-jsxhint.jsxhintExecutablePath'

module.exports = LinterJsxhint
