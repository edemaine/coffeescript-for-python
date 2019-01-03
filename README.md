# CoffeeScript for Python Programmers

> See [https://edemaine.github.io/coffeescript-for-python/](https://edemaine.github.io/coffeescript-for-python/) for a better-formatted version of this document.
{: .github-only}

[CoffeeScript](http://coffeescript.org) is a programming language whose syntax
is clearly designed to match much of [Python](http://www.python.org)
(with additional inspirations from Perl, ECMAScript, Ruby, etc.).
But most documentation for learning CoffeeScript assumes knowledge of
JavaScript (which CoffeeScript compiles to), which is far messier.

This guide attempts to **teach CoffeeScript to someone fluent in just Python**
(such as the typical MIT sophomore), showing the slight tweaks needed to
convert Python code into CoffeeScript code.  The goal is to make it easy
for someone to learn CoffeeScript as a second language after Python,
without first learning JavaScript, thereby enabling a Python
programmer to also make cool web applications (for example).

This guide is still a work-in-progress, and is not yet complete.
Feel free to
[submit an issue](https://github.com/edemaine/coffeescript-for-python/issues)
for anything you find lacking or confusing.

# Why CoffeeScript instead of Python?

Both Python and CoffeeScript are great languages.  The main reason to prefer
CoffeeScript is that it compiles to JavaScript, resulting in several advantages:

1. It can **run in any web browser**, making it easy to distribute your
   software for people to play with: just embed it in a web page, and anyone
   can run it on their desktop computer or smartphone.
   (This feature is also especially important for web development.)
   It can also run stand-alone/from a command line (like Python) via
   [Node](https://nodejs.org/en/), which is now the basis for many web servers
   as part of a complete "web application".
2. When running in a browser, you gain access to many **powerful GUI features**
   in the browser, notably HTML/CSS (e.g., buttons),
   [SVG](https://developer.mozilla.org/en-US/docs/Web/SVG)
   (vector 2D graphics),
   [Canvas](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API)
   (raster 2D graphics), and
   [WebGL](https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API)
   (3D graphics).
   This makes it really easy to do complex interactive graphics.
3. It is much **faster**: Node runs typical CoffeeScript 2-5x faster than the
   equivalent Python (though this gap narrows if you use PyPy).
   This performance boost is thanks to extensive optimization, such as
   just-in-time compilation, because of the intense interest in web applications.

# Major Similarities and Differences

Both Python and CoffeeScript share many features:

* Code block nesting is based on indentation.
* Variables don't need to be declared; you just assign a value.
* Everything is an object and has a type, but you don't need to declare
  the types of variables.
* Imperative programming plus strong functional programming support.
* Self-resizing arrays and dictionaries are powerful native types.
* Strings, regular expressions, slicing,
  comparisons with chaining, `and`/`or`/`not`,
  `if`, `for...in`, list comprehensions, generators via `yield`,
  `async`/`await`, exceptions, and many other features are all very similar.

They also have some major differences (some better for Python and some
better for CoffeeScript):

* CoffeeScript requires less punctuation, and relies even more on indentation:
  * no colons to start code blocks,
  * [optional braces around dictionary literals](#python-dict--coffeescript-object),
  * [optional quotes around dictionary keys](#python-dict--coffeescript-object),
  * [optional commas between list items](#python-list--coffeescript-array), and
  * [optional parentheses in function calls](#functions).
* Variables have [different scope](#variable-scoping): every variable in
  CoffeeScript is as if it was declared `nonlocal` in Python.  This makes it
  easier to access variables in enclosing scopes, but also easier to make a
  mistake from re-using variables.
* The typing systems differ: CoffeeScript uses [prototype object
  orientation](https://en.wikipedia.org/wiki/Prototype-based_programming),
  while Python uses [multiple-inheritance object
  orientation](https://en.wikipedia.org/wiki/Multiple_inheritance).
  The main practical difference is that multiple inheritance is not supported
  by CoffeeScript.  In principle, it's also easier to create "classes" in
  CoffeeScript because every object can act as a class.
* `lambda`-style inline functions can be multiple lines in CoffeeScript,
  making mixed imperative/functional programming even easier.
  On the other hand, CoffeeScript functions do not support keyword arguments.
* The built-in types differ substantially, e.g., their method names differ.
  But for the most part, there is a one-to-one mapping.
* CoffeeScript has more helpful syntax for a lot of important features,
  but also misses a few features:
  * [String interpolation](#strings),
    regular expressions, and
    the equivalent of `range`
    have built-in syntax (instead of relying on methods/libraries/functions).
  * There are two slicing operators depending on whether you want to include
    the final index or not.
  * [All comparisons are shallow](#comparison-operators);
    no built-in deep comparison support.
    Truthiness is similarly shallow; e.g., `[]` is considered true.
  * [`switch`](#ifthenelse-and-switch) alternative to long
    `if`/`then`/`else` chains.
  * Multiline `if`s and `for` loops are expressions instead of statements,
    so single statements span multiple lines with full indentation support.
    (`for` loops helpfully accumulate the list of final values.)
  * [Three types of `for` loops](#for-loops),
    including cleaner syntax for Python's `for key, value in enumerate(...)`.
  * No [dictionary comprehensions](https://www.python.org/dev/peps/pep-0274/)
  * No operator overloading via ``__special_methods__`.  No metaclasses.

# Quick Reference Guide

At a high level, if you remove all the colons at the end of lines from Python
code, you end up with equivalent CoffeeScript code.  There are many smaller
differences, though, stemming in particular from different built-in types
(a consequence of JavaScript).  This section aims to document these
differences by way of side-by-side examples.

> Should we have both "minimalist" and more-paren styles of CoffeeScript?
> Note that [IPython's autocall magic](http://ipython.readthedocs.io/en/stable/interactive/magics.html#magic-autocall)
> simulates the minimalist style in Python!

## print

The analog of Python's `print` is CoffeeScript's `console.log`.
Like Python 3, it is just a regular function.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
# Python 2
print "Hello world", 1+2
# Python 3
print("Hello world", 1+2)
#or
print ("Hello world", 1+2)
```

</td><td markdown="1">

```coffeescript
console.log "Hello world", 1+2
#or
console.log('Hello world', 1+2)
#INVALID: no space allowed between function and argument paren
#console.log ('Hello world', 1+2)
```

</td></tr>
</table>

## Strings

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
"Hello {}, your age is {}".format(name, age)
'Hello {}, your age is {}'.format(name, age)
"Hello {}, your age is {}".format(name,
  thisYear - birthYear)
```

</td><td markdown="1">

```coffeescript
"Hello #{name}, your age is #{age}"
#INVALID: 'Hello #{name}, your age is #{age}'
#  #{...} is allowed only in ""s, not ''s
"Hello #{name}, your age is #{thisYear - birthYear}"
```

</td></tr>
<tr><td markdown="1">

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

</td><td markdown="1">

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

</td></tr>
</table>

If you want something like Python's `%` operator, try the
[sprintf-js](https://www.npmjs.com/package/sprintf-js) package.

## Comments

Python and [CoffeeScript comments](https://coffeescript.org/#comments)
are generally the same:

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
# This line is a comment
x = 5  # set x to five
```

</td><td markdown="1">

```coffeescript
# This line is a comment
x = 5  # set x to five
```

</td></tr>
</table>

CoffeeScript also offers **block comments** (similar to triple-quoted strings
in Python), which you should also be careful not to trigger by accident:

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
# Some comments
# Some more comments
# Even more comments
```

</td><td markdown="1">

```coffeescript
###
Some comments
Some more comments
Even more comments
###
```

</td></tr>
<tr><td markdown="1">

```python
### This line is a comment
```

</td><td markdown="1">

```coffeescript
## This line is a comment
```

</td></tr>
</table>

## Functions

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
def f(x, add = 1):
  y = x + add
  return y*y
```

</td><td markdown="1">

```coffeescript
f = (x, add = 1) ->
  y = x + add
  y*y
```

</td></tr>
<tr><td markdown="1">

```python
add1 = lambda x: x+1
add = lambda x, y=1: x+y
zero = lambda: 0
```

</td><td markdown="1">

```coffeescript
add1 = (x) -> x+1
add = (x, y=1) -> x+y
zero = -> 0
```

</td></tr>
</table>

In CoffeeScript (like Perl and Ruby), the parentheses in function calls are
allowed but optional; when omitted, they implicitly extend to the end of the
line.
(Similar behavior is possible in [IPython](https://ipython.org/) via the
[`%autocall` magic](https://ipython.readthedocs.io/en/stable/interactive/magics.html#magic-autocall).)
Parentheses are still required for zero-argument function calls and when
an argument list ends before the end of the line.
In CoffeeScript (unlike Python), there can be no space between the function
name and the parentheses.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
f(5)
#or
f (5)

f(5, 10)
#or
f (5, 10)
```

</td><td markdown="1">

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

</td></tr>
<tr><td markdown="1">

```python
add(5, add1(add1(zero())))
```

</td><td markdown="1">

```coffeescript
add 5, add1 add1 zero()
```

</td></tr>
<tr><td markdown="1">

```python
add(add1(1), 2)
```

</td><td markdown="1">

```coffeescript
add add1(1), 2
#or
add (add1 1), 2
```

</td></tr>
</table>

CoffeeScript functions do not support keyword arguments.
The typical workaround is to use an
[object](#python-dict--coffeescript-object) for an argument.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
f(add = 2, x = 10)
```

</td><td markdown="1">

```coffeescript
f(10, 2)
# no keyword arguments in function calls
```

</td></tr>
<tr><td markdown="1">

```python
def g(x, **options):
  f(x, **options)
```

</td><td markdown="1">

```coffeescript
g = (x, options) ->
  f(x, options.add)
```

</td></tr>
<tr><td markdown="1">

```python
x = [1, 2, 3]
print(*x)
#or
apply(print, x)
```

</td><td markdown="1">

```coffeescript
x = [1, 2, 3]
console.log ...x
#or
console.log.apply console, x
```

</td></tr>
<tr><td markdown="1">

```python
def add(first, *rest):
  for arg in rest:
    first += rest
  return first
```

</td><td markdown="1">

```coffeescript
add = (first, ...rest) ->
  for arg in rest
    first += arg
  first
```

</td></tr>
</table>

## Variable Scoping

## if/then/else and switch

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
if x:
  y = 1
else:
  y = 2
```

</td><td markdown="1">

```coffeescript
if x
  y = 1
else
  y = 2
```

</td></tr>
<tr><td markdown="1">

```python
y = 1 if x else 2
```

</td><td markdown="1">

```coffeescript
y = if x then 1 else 2
#or
y =
  if x
    1
  else
    2
```

</td></tr>
<tr><td markdown="1">

```python
if x:
  y = 1
elif z:
  y = 2
else:
  y = 3
```

</td><td markdown="1">

```coffeescript
if x
  y = 1
else if z
  y = 2
else
  y = 3
```

</td></tr>
<tr><td markdown="1">

```python
y = 1 if x else (2 if z else 3)
```

</td><td markdown="1">

```coffeescript
y =
  if x
    1
  else if z
    2
  else
    3
```

</td></tr>
</table>

Unlike Python, CoffeeScript offers a
[`switch` expression](https://coffeescript.org/#switch)
as an alternative to `if`/`then`/`else`.
`switch` is especially concise when branching on the same value.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
if x:
  y = 1
elif z:
  y = 2
else:
  y = 3
```

</td><td markdown="1">

```coffeescript
switch
  when x
    y = 1
  when z
    y = 2
  else
    y = 3
```

</td></tr>
<tr><td markdown="1">

```python
y = 1 if x else (2 if z else 3)
```

</td><td markdown="1">

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

</td></tr>
<tr><td markdown="1">

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

</td><td markdown="1">

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

</td></tr>
</table>

## Comparison operators

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

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

</td><td markdown="1">

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

</td></tr>
</table>

## for loops

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
for x in [1, 2, 3]:
  y += x
```

</td><td markdown="1">

```coffeescript
for x in [1, 2, 3]
  y += x
```

</td></tr>
<tr><td markdown="1">

```python
for i, x in enumerate([1, 2, 3]):
  y += x * i
```

</td><td markdown="1">

```coffeescript
for x, i in [1, 2, 3]
  y += x * i
```

</td></tr>
<tr><td markdown="1">

```python
out = []
for x in [1, 2, 3]:
  out.append(x * x)
#or
out = [x * x for x in [1, 2, 3]]
```

</td><td markdown="1">

```coffeescript
out =
  for x in [1, 2, 3]
    x * x
#or
out = (x * x for x in [1, 2, 3])
```

</td></tr>
<tr><td markdown="1">

```python
for x in range(10):
  y += x
```

</td><td markdown="1">

```coffeescript
for x in [...10]
  y += x
```

</td></tr>
<tr><td markdown="1">

```python
for x in range(5, 10):
  y += x
```

</td><td markdown="1">

```coffeescript
for x in [5...10]
  y += x
```

</td></tr>
</table>

## Python list / CoffeeScript Array

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">
  
```python
x = []
x.append(5)
x.append(10)
```

</td><td markdown="1">

```coffeescript
x = []
x.push 5, 10
```

</td></tr>
<tr><td markdown="1">

```python
x = [1, 2, 3]
```

</td><td markdown="1">

```coffeescript
x = [1, 2, 3]
#or
x = [
  1
  2
  3
]
```

</td></tr>
<tr><td markdown="1">

```python
len(x)
```

</td><td markdown="1">

```coffeescript
x.length
```

</td></tr>
<tr><td markdown="1">

```python
x = [1, 2, 3]
y = [4, 5, 6]
x.extend(y)
```

</td><td markdown="1">

```coffeescript
x = [1, 2, 3]
y = [4, 5, 6]
x.push ...y
```

</td></tr>
<tr><td markdown="1">

```python
x = (1, 2)
```

</td><td markdown="1">

```coffeescript
x = Object.freeze [1, 2]
```
  
</td></tr>
</table>

## Python dict / CoffeeScript Object

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
d = {1: 2, 'hello': 'world'}
```

</td><td markdown="1">

```coffeescript
d = {1: 2, hello: 'world'}
#or
d =
  1: 2
  hello: 'world'
```

</td></tr>
<tr><td markdown="1">

```python
key in d
```

</td><td markdown="1">

```coffeescript
key of d
```

</td></tr>
<tr><td markdown="1">

```python
for key in d:
  f(key)
```

</td><td markdown="1">

```coffeescript
for key of d
  f key
#or
for own key of d
  f key
```

</td></tr>
<tr><td markdown="1">

```python
for key, value in d.items():
```

</td><td markdown="1">

```coffeescript
for key, value of d
```

</td></tr>
<tr><td markdown="1">

```python
d.setdefault(key, value)
```

</td><td markdown="1">

```coffeescript
d[key] ?= value
```

</td></tr>
<tr><td markdown="1">

```python
d.setdefault(key, []).append(value)
```

</td><td markdown="1">

```coffeescript
(d[key] ?= []).push value
```

</td></tr>
</table>

## Python set / CoffeeScript Set

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
x = set()
```

</td><td markdown="1">

```coffeescript
x = new Set
```

</td></tr>
<tr><td markdown="1">

```python
x = {1, 2, 3}
```

</td><td markdown="1">

```coffeescript
x = new Set [1, 2, 3]
```

</td></tr>
<tr><td markdown="1">

```python
# x is a set
if x:
  print len(x), 'elements'
else:
  print 'empty'
```

</td><td markdown="1">

```coffeescript
# x is a set
if x.size()
  console.log x.size(), 'elements'
else
  console.log 'empty'
```

</td></tr>
<tr><td markdown="1">

```python
# x is a set
for item in x:
  print item
```

</td><td markdown="1">

```coffeescript
# x is a set
for item from x
  console.log item
```

</td></tr>
</table>

## Null values

Python has one "null" value, `None`.
CoffeeScript has two, `undefined` and `null`.
Essentially, `undefined` is the default initial value for all variables
(a notion absent from Python), while `null` is an explicit null value.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
x = None
```

</td><td markdown="1">

```coffeescript
# x is automatically undefined
# explicit setting:
x = undefined
# alternate None-like value:
x = null
```

</td></tr>
</table>

CoffeeScript defines a unary `?` operator to test for `undefined` or `null`.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
if x is not None:
  ...
```

</td><td markdown="1">

```coffeescript
if x?
  ...
#equivalent to:
if x != undefined and x != null
  ...
```

</td></tr>
</table>

CoffeeScript also defines a binary `?` operator to provide alternate (default)
values in case of `undefined` or `null`:

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
y = 5 if x is None else x
```

</td><td markdown="1">

```coffeescript
y = x ? 5
```

</td></tr>
</table>

CoffeeScript also defines a conditional assignment operator, `?=`,
to assign to a value only when the left-hand sign isn't `undefined` or `null`:

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
try:
  x
except UnboundLocalError:
  x = 5
```

</td><td markdown="1">

```coffeescript
x ?= 5
```

</td></tr>
<tr><td markdown="1">

```python
# d is a dictionary
d.setdefault(key, value)
```

</td><td markdown="1">

```coffeescript
# d is an object
d[key] ?= value
```

</td></tr>
</table>

## Comprehensions

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
y = [f(i) for i in x]
#or
y = list(map(f, x))
```

</td><td markdown="1">

```coffeescript
y = (f i for i in x)
#or
y =
  for i in x
    f i
#or
y = x.map f
```

</td></tr>
<tr><td markdown="1">

```python
y = [f(i) for i in x if condition(i)]
```

</td><td markdown="1">

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

</td></tr>
<tr><td markdown="1">

```python
z = [[f(i,j) for j in y] for i in x]
```

</td><td markdown="1">

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

</td></tr>
<tr><td markdown="1">

```python
z = [f(i,j) for i in x for j in y]
```

</td><td markdown="1">

```coffeescript
y = [].concat ...(f i, j for j in y for i in x)
#or
y = [].concat ...(
  for i in x
    for j in y
      f i, j
)
```

</td></tr>
</table>

## Classes

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

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

</td><td markdown="1">

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

</td></tr>
<tr><td markdown="1">

```python
p = Point(1, 2)
p.translate(3, 4)
print(p)
```

</td><td markdown="1">

```coffeescript
p = new Point 1, 2
p.translate 3, 4
console.log "#{p}"
#or
console.log p.toString()
# Note: console.log p will not call toString()
```

</td></tr>
<tr><td markdown="1">

```python
trans = p.translate
trans(5, 6)
```

</td><td markdown="1">

```coffeescript
trans = p.translate
# Note: trans 5, 6 will use this = null
trans.call p, 5, 6
#or
trans = (...args) -> p.translate ...args
trans 5, 6
```

</td></tr>
<tr><td markdown="1">

```python
class PPoint extends Point
  dim = 2
  @classmethod
  def parse(Class, string):
    return Class(*[float(word)
      for word in string.split(",")])
```

</td><td markdown="1">

```coffeescript
class PPoint extends Point
  @dim: 2
  @parse: (string) ->
    # @ = this is the class in an @method
    new @ ...(parseFloat word
      for word in string.split ","])
```

</td></tr>
<tr><td markdown="1">

```python
print(PPoint.dim)
PPoint.slope = lambda self: self.y / self.x
```

</td><td markdown="1">

```coffeescript
console.log PPoint::dim
PPoint::slope = -> @y / @x
```

</td></tr>
</table>

# Installation / Getting Started

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
