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
indent = (x) ->
  x.replace /^|\n/g, '$&  '

files = (file for file in fs.readdirSync dir when file.endsWith ext)
for file in files
  md = fs.readFileSync (path.join dir, file), encoding: 'utf8'

  describe "CoffeeScript examples in #{file}", ->
    pattern = /```coffee[^]*?```/g
    while match = pattern.exec md
      cs = detick match[0]
      .replace /(\n\s*)\.\.\.(\s*\n)/g, '$1codeBlock$2'

      ## CoffeeScript doesn't like bare "x ?= ..." without x being otherwise
      ## declared.
      if (match = /(\w+)\s*\?=/.exec cs) and not /(\w+)\s*=/.test cs
        cs = "#{match[1]} = undefined\n" + cs

      do (cs) ->
        test "Compiles: #{oneLine cs}", ->
          expect(CoffeeScript.compile cs)
          .toBeTruthy()
    undefined

  describe "Python examples in #{file}", ->
    pattern = /```py[^]*?```/g
    while match = pattern.exec md
      py = detick match[0]
      .replace /\.\.\./g, 'pass'

      do (py) ->
        version = if /print [^(]/.test py then 2 else 3
        describe "Compiles: #{oneLine py}", ->
          lines = py.split '\n'
          lines.push [''] # to force wrap-up
          group = []
          quotes = false
          quoteRe = /'''|"""/g
          for line, i in lines
            ## Always wrap-up on last line; otherwise continue when within
            ## quotes, on any indented line, and on except/finally/else/elif.
            if i < lines.length-1 and \
               (quotes or /^( |except|finally|else|elif)/.test line)
              group.push line
            else
              if group.length
                code = group.join('\n') + '\n'

                ## Handle abstract code blocks that need surrounding loop/def
                if /break|continue/.test(code) and not /for|while/.test code
                  code = 'while True:\n' + indent code
                if /return/.test(code) and not /def/.test code
                  code = 'def function():\n' + indent code

                arg = (code + '\n')
                .replace /[\\']/g, "\\$&"
                .replace /\n/g, "\\n"
                do (code, arg) ->
                  test "Compiles: #{oneLine code}", ->
                    python = child_process.spawnSync "python#{version}", [
                      '-c'
                      """
                        import codeop
                        if None is codeop.compile_command('#{arg}'):
                          raise RuntimeError('incomplete code')
                      """
                    ],
                      stdio: [null, null, 'pipe']
                    if python.error?
                      throw python.error
                    stderr = python.stderr.toString 'utf8'
                    #console.log "'#{arg}'" if stderr
                    expect(stderr).toBe('')
              group = []
              group.push line if line
            ## In either case, we pushed line to group (or line == '').
            ## Check for any quotes which will keep us in a group longer.
            while quoteRe.exec line
              quotes = not quotes
          undefined
    undefined
