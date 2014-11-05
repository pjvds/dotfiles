{XRegExp} = require 'xregexp'
linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
{log, warn} = require "#{linterPath}/lib/utils"


class LinterHLint extends Linter
  @syntax: 'source.haskell' # fits all *.hs-files

  linterName: 'hlint'

  regex: '^[^:]*:(?<line>\\d+):(?<col>\\d+):\\s+\
          ((?<error>Error)|(?<warning>Warning)):\\s*\
          (?<message>.*)'
  regexFlags: 'gms'

  constructor: (editor) ->
    super(editor)
    atom.config.observe 'linter-hlint.hlintExecutablePath', =>
      @executablePath = atom.config.get 'linter-hlint.hlintExecutablePath'

  processMessage: (message, callback) ->
    if message == "No Suggestions"
      return []
    messages = []
    regex = XRegExp @regex, @regexFlags
    for msg in message.split(/\n\n/)
      XRegExp.forEach msg, regex, (match, i) =>
        messages.push(@createMessage(match))
      , this
    callback messages


  createMessage:(match) ->
    super(match)

module.exports = LinterHLint
