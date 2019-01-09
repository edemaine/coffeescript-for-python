fs = require 'fs'
path = require 'path'
CoffeeScript = require 'coffeescript'

dir = path.join __dirname, '..'
ext = '.md'

detick = (x) ->
  x.replace /^```.*\n/, ''
  .replace /[ ]*```$/, ''

files = (file for file in fs.readdirSync dir when file.endsWith ext)
for file in files
  md = fs.readFileSync (path.join dir, file), encoding: 'utf8'

  describe "CoffeeScript examples in #{file}", ->
    pattern = /```coffee[^]*?```/g
    while match = pattern.exec md
      cs = detick match[0]
      .replace /(\n\s*)\.\.\.(\s*\n)/g, '$1codeBlock$2'

      do (cs) ->
        test "Compiles: #{cs.replace '\n', '\\n'}", ->
          expect(CoffeeScript.compile cs)
          .toBeTruthy()

  describe "Python examples in #{file}", ->
    pattern = /```py[^]*?```/g
    while match = pattern.exec md
      py = detick match[0]
      .replace /\.\.\./g, 'pass'
      #console.log py
