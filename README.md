# CoffeeScript for Python programmers

[CoffeeScript](http://coffeescript.org) is a programming language whose syntax
is clearly designed to match much of [Python](http://www.python.org)
(with additional inspirations from Perl, ECMAScript, etc.).
But most documentation for CoffeeScript assumes knowledge of JavaScript,
which CoffeeScript compiles to.

This guide attempts to teach CoffeeScript to someone fluent in just Python,
showing the slight tweaks needed to convert Python code into CoffeeScript code.

However, this guide is still a work-in-progress, and is not yet complete.

## Why CoffeeScript instead of Python?

The languages are similar, so why not stick to Python?  The main reason is
that CoffeeScript compiles to JavaScript, resulting in several advantages:

1. It can **run in any web browser**, making it easy to distribute your
   software for people to play with: just embed it in a web page, and anyone
   can run it on their desktop computer or smartphone.
   (This feature is also especially important for web development.)
2. When running in a browser, you gain access to many **powerful GUI features**
   in the browser, notably HTML/CSS (e.g. buttons), SVG, WebGL, and Canvas.
   This makes it really easy to do complex graphics, both 2D and 3D.
3. It is much **faster**: Node runs typical CoffeeScript 2-5x faster than the
   equivalent Python (though this gap narrows if you use PyPy).
   This performance boost is thanks to extensive optimization, such as
   just-in-time compilation, because of the intense interest in web applications.

## Quick Reference Guide

> Should we have both "minimalist" and more-paren styles of CoffeeScript?
> Note that [IPython's autocall magic](http://ipython.readthedocs.io/en/stable/interactive/magics.html#magic-autocall)
> simulates the minimalist style in Python!

### print

The analog of Python's `print` is CoffeeScript's `console.log`.
Like Python 3, it is just a regular function.

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

```python
# Python 2
print "Hello world", 1+2
# Python 3
print("Hello world", 1+2)
#or
print ("Hello world", 1+2)
```

<td>

```coffeescript
console.log "Hello world", 1+2
#or
console.log('Hello world', 1+2)
#INVALID: no space allowed between function and argument paren
#console.log ('Hello world', 1+2)
```

</table>

### Strings

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  "Hello {}, your age is {}".format(name, age)
  'Hello {}, your age is {}'.format(name, age)
  "Hello {}, your age is {}".format(name,
    thisYear - birthYear)
  ```

<td>

  ```coffeescript
  "Hello #{name}, your age is #{age}"
  #INVALID: 'Hello #{name}, your age is #{age}'
  #  #{...} is allowed only in ""s, not ''s
  "Hello #{name}, your age is #{thisYear - birthYear}"
  ```

<tr><td>

  ```python
  x = '''\
  hello
  world'''
  # 'hello\nworld'

  x = '''
  hello
  world
  '''
  # '\nhello\nworld\n'

  ```

<td>

  ```coffeescript
  x = '''
    hello
    world
  '''
  # 'hello\nworld' -- common indentation removed
  x = '''

    hello
    world

  '''
  # '\nhello\nworld\n'
  ```

</table>

If you want something like Python's `%` operator, try the
[sprintf-js](https://www.npmjs.com/package/sprintf-js) package.

### Comments

Python and [CoffeeScript comments](https://coffeescript.org/#comments)
are generally the same:

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  # This line is a comment
  x = 5  # set x to five
  ```

<td>

  ```coffeescript
  # This line is a comment
  x = 5  # set x to five
  ```

</table>

CoffeeScript also offers **block comments** (similar to triple-quoted strings
in Python), which you should also be careful not to trigger by accident:

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  # Some comments
  # Some more comments
  # Even more comments
  ```

<td>

  ```coffeescript
  ###
  Some comments
  Some more comments
  Even more comments
  ###
  ```

<tr><td>

  ```python
  ### This line is a comment
  ```

<td>

  ```coffeescript
  ## This line is a comment
  ```

</table>

### Functions

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  def f(x, add = 1):
    y = x + add
    return y*y
  ```

<td>

  ```coffeescript
  f = (x, add = 1) ->
    y = x + add
    y*y
  ```

<tr><td>

  ```python
  f(5)
  #or
  f (5)
  
  f(5, 10)
  #or
  f (5, 10)
  ```

<td>

  ```coffeescript
  f(5)
  #or
  f 5
  # f (5) is technically valid but only by luck
  f(5, 10)
  #or
  f 5, 10
  # f (5, 10) is INVALID: no space allowed between function and argument paren
  ```

<tr><td>

  ```python
  f(add = 2, x = 10)
  ```

<td>

  ```coffeescript
  f(10, 2)
  # no keyword arguments in function calls
  ```

<tr><td>

  ```python
  x = [1, 2, 3]
  print(*x)
  #or
  apply(print, x)
  ```

<td>
  
  ```coffeescript
  x = [1, 2, 3]
  console.log ...x
  #or
  console.log.apply console, x
  ```

<tr><td>

  ```python
  def add(first, *rest):
    for arg in rest:
      first += rest
    return first
  ```

<td>
  
  ```coffeescript
  add = (first, ...rest) ->
    for arg in rest
      first += arg
    first
  ```

</table>

### if/then/else and switch

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

```python
if x:
  y = 1
else:
  y = 2
```

<td>

```coffeescript
if x
  y = 1
else
  y = 2
```

<tr><td>

```python
y = 1 if x else 2
```

<td>

```coffeescript
y = if x then 1 else 2
#or
y =
  if x
    1
  else
    2
```

<tr><td>

```python
if x:
  y = 1
elif z:
  y = 2
else:
  y = 3
```

<td>

```coffeescript
if x
  y = 1
else if z
  y = 2
else
  y = 3
```

<tr><td>

```python
y = 1 if x else (2 if z else 3)
```

<td>

```coffeescript
y =
  if x
    1
  else if z
    2
  else
    3
```

</table>

Unlike Python, CoffeeScript offers a
[`switch` expression](https://coffeescript.org/#switch)
as an alternative to `if`/`then`/`else`.
`switch` is especially concise when branching on the same value.

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

```python
if x:
  y = 1
elif z:
  y = 2
else:
  y = 3
```

<td>

```coffeescript
switch
  when x
    y = 1
  when z
    y = 2
  else
    y = 3
```

<tr><td>

```python
y = 1 if x else (2 if z else 3)
```

<td>

```coffeescript
y =
  switch
    when x
      1
    when z
      2
    else
      3
```

<tr><td>

  ```python
  if x == 0:
    print('zero')
  elif x == 1 or x == 2 or x == 3:
    print('small')
  elif x in ['hello', 'world']:
    print('hi')
  else:
    print('unknown')
  ```

<td>

  ```coffeescript
  switch x
    when 0
      console.log 'zero'
    when 1, 2, 3
      console.log 'small'
    when 'hello', 'world'
      console.log 'hi'
    else
      console.log 'unknown'
  ```

</table>

### Comparison operators

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  1+2 == 3  # True
  1 < 2 < 3 # True
  x = [1, 2, 3]
  y = [1, 2, 3]
  # pointer comparison
  x is x    # True
  x is y    # False
  # deep comparison
  x == x    # True
  x == y    # True
  ```

<td>

  ```coffeescript
  1+2 == 3  # true
  1 < 2 < 3 # true
  x = [1, 2, 3]
  y = [1, 2, 3]
  # pointer comparison
  x == x    # true
  x == y    # false
  # deep comparison
  _.isEqual x, x  # true
  _.isEqual x, y  # false
  ```

</table>

### for loops

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

```python
for x in [1, 2, 3]:
  y += x
```

<td>

```coffeescript
for x in [1, 2, 3]
  y += x
```

<tr><td>

```python
for i, x in enumerate([1, 2, 3]):
  y += x * i
```

<td>

```coffeescript
for x, i in [1, 2, 3]
  y += x * i
```

<tr><td>

```python
out = []
for x in [1, 2, 3]:
  out.append(x * x)
#or
out = [x * x for x in [1, 2, 3]]
```

<td>

```coffeescript
out =
  for x in [1, 2, 3]
    x * x
#or
out = (x * x for x in [1, 2, 3])
```

<tr><td>

```python
for x in range(10):
  y += x
```

<td>

```coffeescript
for x in [...10]
  y += x
```

<tr><td>

```python
for x in range(5, 10):
  y += x
```

<td>

```coffeescript
for x in [5...10]
  y += x
```

</table>

### Python list / CoffeeScript Array

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>
  
  ```python
  x = []
  x.append(5)
  x.append(10)
  ```

<td>
  
  ```coffeescript
  x = []
  x.push 5, 10
  ```

<tr><td>

  ```python
  x = [1, 2, 3]
  ```

<td>

  ```coffeescript
  x = [1, 2, 3]
  #or
  x = [
    1
    2
    3
  ]
  ```
  
<tr><td>

  ```python
  len(x)
  ```

<td>

  ```coffeescript
  x.length
  ```

<tr><td>

  ```python
  x = [1, 2, 3]
  y = [4, 5, 6]
  x.extend(y)
  ```

<td>

  ```coffeescript
  x = [1, 2, 3]
  y = [4, 5, 6]
  x.push ...y
  ```
  
<tr><td>

  ```python
  x = (1, 2)
  ```

<td>

  ```coffeescript
  x = Object.freeze [1, 2]
  ```
  
</table>

### Python dict / CoffeeScript Object

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  d = {1: 2, 3: 4}
  ```

<td>

  ```coffeescript
  d = {1: 2, 3: 4}
  #or
  d =
    1: 2
    3: 4
  ```

<tr><td>

  ```python
  key in d
  ```

<td>

  ```coffeescript
  key of d
  ```

<tr><td>

  ```python
  for key in d:
    f(key)
  ```

<td>

  ```coffeescript
  for key of d
    f key
  #or
  for own key of d
    f key
  ```

<tr><td>

  ```python
  for key, value in d.items():
  ```

<td>

  ```coffeescript
  for key, value of d
  ```

<tr><td>

  ```python
  d.setdefault(key, value)
  ```

<td>

  ```coffeescript
  d[key] ?= value
  ```

<tr><td>

  ```python
  d.setdefault(key, []).append(value)
  ```

<td>

  ```coffeescript
  (d[key] ?= value).push value
  ```

</table>

### Python set / CoffeeScript Set

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  x = set()
  ```

<td>

  ```coffeescript
  x = new Set
  ```

<tr><td>

  ```python
  x = {1, 2, 3}
  ```

<td>

  ```coffeescript
  x = new Set [1, 2, 3]
  ```

<tr><td>

  ```python
  # x is a set
  if x:
    print len(x), 'elements'
  else:
    print 'empty'
  ```

<td>

  ```coffeescript
  # x is a set
  if x.size()
    console.log x.size(), 'elements'
  else
    console.log 'empty'
  ```

<tr><td>

  ```python
  # x is a set
  for item in x:
    print item
  ```

<td>

  ```coffeescript
  # x is a set
  for item from x
    console.log item
  ```

</table>

### Null values

Python has one "null" value, `None`.
CoffeeScript has two, `undefined` and `null`.
Essentially, `undefined` is the default initial value for all variables
(a notion absent from Python), while `null` is an explicit null value.

<table>
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  x = None
  ```

<td>
  
  ```coffeescript
  # x is automatically undefined
  # explicit setting:
  x = undefined
  # alternate None-like value:
  x = null
  ```

</table>

CoffeeScript defines a unary `?` operator to test for `undefined` or `null`.

<table>
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  if x is not None:
    ...
  ```

<td>
  
  ```coffeescript
  if x?
    ...
  #equivalent to:
  if x != undefined and x != null
    ...
  ```

</table>

CoffeeScript also defines a binary `?` operator to provide alternate (default)
values in case of `undefined` or `null`:

<table>
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  y = 5 if x is None else x
  ```

<td>
  
  ```coffeescript
  y = x ? 5
  ```

</table>

CoffeeScript also defines a conditional assignment operator, `?=`,
to assign to a value only when the left-hand sign isn't `undefined` or `null`:

<table>
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  try:
    x
  except UnboundLocalError:
    x = 5
  ```

<td>
  
  ```coffeescript
  x ?= 5
  ```

<tr><td>

  ```python
  # d is a dictionary
  d.setdefault(key, value)
  ```

<td>
  
  ```coffeescript
  # d is an object
  d[key] ?= value
  ```

</table>

### Comprehensions

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  y = [f(i) for i in x]
  #or
  y = list(map(f, x))
  ```

<td>

  ```coffeescript
  y = (f i for i in x)
  #or
  y =
    for i in x
      f i
  #or
  y = x.map f
  ```

<tr><td>

  ```python
  y = [f(i) for i in x if condition(i)]
  ```

<td>

  ```coffeescript
  y = (f i for i in x when condition i)
  #or
  y =
    for i in x when condition i
      f(i)
  #or
  y =
    for i in x
      continue unless condition i
      f(i)
  ```

<tr><td>

  ```python
  z = [[f(i,j) for j in y] for i in x]
  ```

<td>

  ```coffeescript
  y = (f i, j for j in y for i in x)
  #or
  y = ((f i, j for j in y) for i in x)
  #or
  y =
    for i in x
      for j in y
        f i, j
  ```

<tr><td>

  ```python
  z = [f(i,j) for i in x for j in y]
  ```

<td>

  ```coffeescript
  y = [].concat ...(f i, j for j in y for i in x)
  #or
  y = [].concat ...(
    for i in x
      for j in y
        f i, j
  )
  ```

</table>

### Classes

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  class Point:
    def __init__(self, x, y):
      self.x = x
      self.y = y
    def translate(self, dx, dy):
      self.x += dx
      self.y += dy
    def __str__(self):
      return "({}, {})" % (self.x, self.y)
  ```

<td>

  ```coffeescript
  class Point
    constructor: (@x, @y) ->
    translate: (dx, dy) ->
      @x += dx
      @y += dy
      null  # otherwise, would return @y
    toString: ->
      "(#{@x}, #{@y})"
  ```

<tr><td>

  ```python
  p = Point(1, 2)
  p.translate(3, 4)
  print(p)
  ```

<td>

  ```coffeescript
  p = new Point 1, 2
  p.translate 3, 4
  console.log "#{p}"
  #or
  console.log p.toString()
  # Note: console.log p will not call toString()
  ```

<tr><td>

  ```python
  trans = p.translate
  trans(5, 6)
  ```

<td>

  ```coffeescript
  trans = p.translate
  # Note: trans 5, 6 will use this = null
  trans.call p, 5, 6
  #or
  trans = (...args) -> p.translate ...args
  trans 5, 6
  ```

<tr><td>

  ```python
  class PPoint extends Point
    dim = 2
    @classmethod
    def parse(Class, string):
      return Class(*[float(word)
        for word in string.split(",")])
  ```

<td>

  ```coffeescript
  class PPoint extends Point
    @dim: 2
    @parse: (string) ->
      # @ = this is the class in an @method
      new @ ...(parseFloat word
        for word in string.split ","])
  ```

<tr><td>

  ```python
  print(PPoint.dim)
  PPoint.slope = lambda self: self.y / self.x
  ```

<td>

  ```coffeescript
  console.log PPoint::dim
  PPoint::slope = -> @y / @x
  ```

</table>

## Installation / Getting Started

To install CoffeeScript on your machine, first
[install NodeJS](https://nodejs.org/en/download/).
(LTS = Long Term Support is a good choice.)
Or [install NodeJS with a package manager](https://nodejs.org/en/download/package-manager/).
This will install (at least) two commands, `node` and `npm`.

Then run the following command:
```sh
npm install --global coffeescript
```

You should then have a command `coffee` that runs the interactive interpreter
(similar to `python`).  You can also compile a CoffeeScript file
`filename.coffee` into a JavaScript file `filename.js` via
```sh
coffee -c filename.coffee
```
