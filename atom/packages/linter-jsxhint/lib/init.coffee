path = require 'path'

module.exports =
  configDefaults:
    #jsxhintExecutablePath: path.join __dirname, '..', 'node_modules', 'jsxhint'
    jsxhintExecutablePath: path.join __dirname, '..', 'node_modules', '.bin'

  activate: ->
    console.log 'activate linter-jsxhint'
