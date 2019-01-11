fs = require 'fs'
path = require 'path'

dir = path.join __dirname, '..'
ext = '.md'

selfClosing =
  img: true

files = (file for file in fs.readdirSync dir when file.endsWith ext)
for file in files
  md = fs.readFileSync (path.join dir, file), encoding: 'utf8'

  do (md) ->
    test "HTML tag closure in #{file}", ->
      stack = []
      context = []
      line = 1
      r = /<(\/?)(\w+)[^<>]*>|```[^]*?```|`[^`]+`|\n/g
      while match = r.exec md
        newlines = match[0].match(/\n/g)
        line += newlines.length if newlines?
        tag = match[2]
        continue unless tag?
        close = match[1].length > 0
        continue if selfClosing[tag]
        if close
          expect(stack.length, "#{line}:</#{tag}> when no open tags").toBeGreaterThan 0
          if stack.length
            expect(tag, "#{context[context.length-1]}:<#{stack[stack.length-1]}> closed by #{line}:</#{tag}>")
            .toEqual stack.pop()
            context.pop()
        else
          stack.push tag
          context.push line
      expect(stack.length, "Unclosed tags #{stack.join ', '} on lines #{context.join ', '}").toEqual 0
