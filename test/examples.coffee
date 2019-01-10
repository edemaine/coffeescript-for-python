fs = require 'fs'
path = require 'path'
child_process = require 'child_process'
CoffeeScript = require 'coffeescript'

dir = path.join __dirname, '..'
ext = '.md'

detick = (x) ->
  x.replace /^```.*\n/, ''
  .replace /[ ]*```$/, ''
oneLine = (x) ->
  x.replace /\n/g, '\\n'

files = (file for file in fs.readdirSync dir when file.endsWith ext)
for file in files
  md = fs.readFileSync (path.join dir, file), encoding: 'utf8'

  describe "CoffeeScript examples in #{file}", ->
    pattern = /```coffee[^]*?```/g
    while match = pattern.exec md
      cs = detick match[0]
      .replace /(\n\s*)\.\.\.(\s*\n)/g, '$1codeBlock$2'

      do (cs) ->
        test "Compiles: #{oneLine cs}", ->
          expect(CoffeeScript.compile cs)
          .toBeTruthy()

  describe "Python examples in #{file}", ->
    pattern = /```py[^]*?```/g
    while match = pattern.exec md
      py = detick match[0]
      .replace /\.\.\./g, 'pass'

      do (py) ->
        version = if py.match /print [^(]/ then 2 else 3
        test "Compiles: #{oneLine py}", ->
          lines = []
          for line in py.split('\n').concat ['']
            if line.match /^( |except|finally|else|elif)/
              lines.push line
            else
              if lines.length
                arg = (lines.join('\n') + '\n\n')
                .replace /[\\']/g, "\\$&"
                .replace /\n/g, "\\n"
                python = child_process.spawnSync "python#{version}", [
                  '-c'
                  """
                    import codeop
                    if None is codeop.compile_command('#{arg}'):
                      raise RuntimeError('incomplete code')
                  """
                ],
                  stdio: [null, null, 'pipe']
                stderr = python.stderr.toString 'utf8'
                console.log "'#{arg}'" if stderr
                expect(stderr).toBe('')
              lines = []
              lines.push line if line
          undefined
