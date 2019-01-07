# <img class="logo" src="images/python-in-coffeescript.svg" alt="Logo: Python snake in CoffeeScript cup" height="200"> CoffeeScript for Python Programmers

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
* Self-resizing [arrays](#python-list--coffeescript-array) and
  [dictionaries](#python-dict--coffeescript-object) are powerful native types.
* [Numbers](#numbers),
  [strings](#strings),
  [regular expressions](#regular-expressions),
  [slicing](#slicing-and-range),
  [comparisons with chaining, `and`/`or`/`not`](#comparison-operators),
  [`if`](#ifthenelse-and-switch),
  [`while`](#while-loops),
  [`for...in`](#for-loops),
  [list comprehensions](#comprehensions),
  [generator functions and `yield`](#generator-functions),
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
  * [There is just one `Number` type](#numbers)
    corresponding to Python's `float`.
    There are no (big) integers, complex numbers, or rationals.
  * [String interpolation](#strings),
    [regular expressions](#regular-expressions), and
    [the equivalent of `range`](#slicing-and-range)
    have built-in syntax (instead of relying on methods/libraries/functions).
  * There are two slicing operators depending on whether you want to include
    the final index or not.
  * [All comparisons are shallow](#comparison-operators);
    no built-in deep comparison support.
    Truthiness is similarly shallow; e.g., `[]` is considered true.
  * [`unless`](#ifthenelse-and-switch) alternative to `if not`;
    [`switch`](#ifthenelse-and-switch) alternative to long `if`/`then`/`else`
    chains; and [`if` can come at the end of a line](#ifthenelse-and-switch);
  * Multiline `if`s and `for` loops are expressions instead of statements,
    so single statements span multiple lines with full indentation support.
    (`for` loops helpfully accumulate the list of final values.)
  * [Three types of `for` loops](#for-loops),
    including cleaner syntax for Python's `for key, value in enumerate(...)`.
  * Exceptional behavior generally doesn't raise exceptions like it does in
    Python.  For example, `d[key]` returns `undefined` when `key not in d`
    (instead of raising `KeyError`); `1/0` returns `Infinity` (instead of
    `ZeroDivisionError`); and function calls with incorrect number of
    arguments work fine (with missing arguments set to `undefined` and
    extra arguments discarded, instead of raising `TypeError`).
  * No [dictionary comprehensions](https://www.python.org/dev/peps/pep-0274/).
  * No operator overloading via ``__special_methods__`.  No metaclasses.

# Quick Reference Guide

At a high level, if you remove all the colons at the end of lines from Python
code, you end up with equivalent CoffeeScript code.  There are many smaller
differences, though, stemming in particular from different built-in types
(a consequence of JavaScript).  This section aims to document these
differences by way of side-by-side examples.

## print

The analog of Python's `print` is CoffeeScript's
[`console.log`](https://developer.mozilla.org/en-US/docs/Web/API/Console/log).
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

CoffeeScript also supports
[**block comments**](https://coffeescript.org/#comments)
(similar to triple-quoted strings in Python),
which you should be careful not to trigger by accident:

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

## Strings

[CoffeeScript string notion](https://coffeescript.org/#strings) is very similar
syntax to Python, except in how triple-quoted strings deal with indentation.
In addition, strings enclosed with `"..."` have built-in string interpolation.
(If you want something like Python's `%` operator, try the
[sprintf-js](https://www.npmjs.com/package/sprintf-js) package.)

The resulting [JavaScript `String` type](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String)
has many similar methods to Python `str`, though often with different names.

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
s = '''\
hello
world'''
# 'hello\nworld'

s = '''
hello
world
'''
# '\nhello\nworld\n'
```

</td><td markdown="1">

```coffeescript
s = '''
  hello
  world
'''
# 'hello\nworld' -- common indentation removed
s = '''

  hello
  world

'''
# '\nhello\nworld\n'
```

</td></tr>
<tr><td markdown="1">

```python
'\033'   # 3-digit octal
'\x1b'   # 2-digit hex
'\u001b" # 4-digit hex
```

</td><td markdown="1">

```coffeescript
'\033'   # 3-digit octal
'\x1b'   # 2-digit hex
'\u001b" # 4-digit hex
```

</td></tr>
<tr><td markdown="1">

```python
'\a' # bell
'\b' # backspace
'\f' # formfeed
'\n' # linefeed
'\r' # carriage return
'\t' # tab
'\v' # vertical tab
```

</td><td markdown="1">

```coffeescript
'\007' # bell
'\b' # backspace
'\f' # formfeed
'\n' # linefeed
'\r' # carriage return
'\t' # tab
'\v' # vertical tab
```

</td></tr>
<tr><td markdown="1">

```python
'y' in s
'y' not in s
s.startswith('y')
s.endswith('?')
s.find('hi')
s.find('hi', start)
s.rfind('hi')
s.rfind('hi', start)
s.find('hi') >= 0
s.replace('hi', 'bye')
s.replace('hi', 'bye', 1)
s.lower()
s.upper()
s.strip()
s.lstrip()
s.rstrip()
s.split()
s.split(',')
s.split(',', 2)
', '.join(array)
```

</td><td markdown="1">

```coffeescript
'y' in s
'y' not in s
s.startsWith('y')
s.endsWith('?')
s.indexOf 'hi' # also supports RegExp
s.indexOf 'hi', start
s.lastIndexOf 'hi' # also supports RegExp
s.lastIndexOf 'hi', start
s.includes 'hi'
s.replace 'hi', 'bye'
s.replace 'hi', 'bye', 1
s.toLowerCase()
s.toUpperCase()
s.trim()      # no argument allowed
s.trimStart() # no argument allowed
s.trimEnd()   # no argument allowed
s.split()
s.split(',')
s.split(',', 2)
array.join(', ')
```

</td></tr>
<tr><td markdown="1">

```python
s1 + s2 + s3
```

</td><td markdown="1">

```coffeescript
s1 + s2 + s3
#or
s1.concat s2, s3
```

</td></tr>
<tr><td markdown="1">

```python
s * 5
```

</td><td markdown="1">

```coffeescript
s.repeat 5
```

</td></tr>
<tr><td markdown="1">

```python
len(s)
```

</td><td markdown="1">

```coffeescript
s.length
```

</td></tr>
<tr><td markdown="1">

```python
ord(s)
chr(27)
```

</td><td markdown="1">

```coffeescript
s.charCodeAt 0
String.fromCharCode 27
```

</td></tr>
<tr><td markdown="1">

```python
str(x)
```

</td><td markdown="1">

```coffeescript
x.toString()
```

</td></tr>
</table>

See also [string slicing](#slicing-and-range).

## Numbers

JavaScript has just one
[`Number` type](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number)
corresponding to Python's `float` (IEEE double precision).
There are no built-in integers, big integers, complex numbers, or rationals.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
6.0001
7.0
7e9
```

</td><td markdown="1">

```coffeescript
6.0001
7
7e9
```

</td></tr>
<tr><td markdown="1">

```python
0b11111111
0o377
255
0xff
```

</td><td markdown="1">

```coffeescript
0b11111111
0377
255
0xff
```

</td></tr>
<tr><td markdown="1">

```python
int('ff', 16)
```

</td><td markdown="1">

```coffeescript
parseInt 'ff', 16
```

</td></tr>
<tr><td markdown="1">

```python
float('7e9')
```

</td><td markdown="1">

```coffeescript
parseFloat '7e9'
```

</td></tr>
<tr><td markdown="1">

```python
str(n)
bin(n)
oct(n)
hex(n)
```

</td><td markdown="1">

```coffeescript
n.toString()
n.toString(2)
n.toString(8)
n.toString(16)
```

</td></tr>
<tr><td markdown="1">

```python
str(n)
bin(n)
oct(n)
hex(n)
```

</td><td markdown="1">

```coffeescript
n.toString()
n.toString(2)
n.toString(8)
n.toString(16)
```

</td></tr>
<tr><td markdown="1">

```python
(-b + (b**2 - 4*a*c)**0.5) / (2*a)
```

</td><td markdown="1">

```coffeescript
(-b + (b**2 - 4*a*c)**0.5) / (2*a)
```

</td></tr>
<tr><td markdown="1">

```python
x // y # integer division
x % y  # mod in [0, y)
```

</td><td markdown="1">

```coffeescript
x // y # integer division
x %% y # mod in [0, y)
```

</td></tr>
<tr><td markdown="1">

```python
(~a | b) & (c ^ d) << n
```

</td><td markdown="1">

```coffeescript
(~a | b) & (c ^ d) << n
```

</td></tr>
<tr><td markdown="1">

```python
math.e
math.pi
math.tau
math.inf
math.nan
```

</td><td markdown="1">

```coffeescript
Math.E
Math.PI
2*Math.PI
Infinity
NaN
```

</td></tr>
<tr><td markdown="1">

```python
round(x)
math.trunc(x)
math.floor(x)
math.ceil(x)
math.sqrt(x)
abs(x)
math.log(x)
math.log(x, base)
math.log1p(x)
math.log2(x)
math.log10(x)
Math.exp(x)
Math.expm1(x)
math.degrees(x)
math.radians(x)
math.cos(x)
math.sin(x)
math.tan(x)
math.acos(x)
math.asin(x)
math.atan(x)
math.atan2(y, x)
math.hypot(x, y)
```

</td><td markdown="1">

```coffeescript
Math.round x
Math.trunc x
Math.floor x
Math.ceil x
Math.sqrt x
Math.abs x
Math.log x
(Math.log x) / Math.log base
Math.log1p x
Math.log2 x
Math.log10 x
Math.exp x
Math.expm1 x
x * 180 / Math.PI
x * Math.PI / 180
Math.cos x
Math.sin x
Math.tan x
Math.acos x
Math.asin x
Math.atan x
Math.atan2 y, x
Math.hypot x, y # or more args
```

</td></tr>
</table>

## Functions

[CoffeeScript functions](https://coffeescript.org/#functions)
automatically return the last expression (if they are
not aborted with an explicit `return`), making the final `return` optional.
All arguments default to `undefined` unless otherwise specified.
Defaults are evaluated during the function call (unlike Python which evalutes
them at function definition time).

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
def rectangle(x, y = None):
  if y is None:
    y = x
  return x * y
```

</td><td markdown="1">

```coffeescript
rectangle = (x, y = x) -> x * y
```

</td></tr>
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
<tr><td markdown="1">

```python
def callback(x):
  print('x is', x)
  return f(x)
compute('go', callback)
```

</td><td markdown="1">

```coffeescript
compute 'go', (x) ->
  console.log 'x is', x
  f(x)
```

</td></tr>
</table>

In CoffeeScript (like Perl and Ruby), [the parentheses in function calls
are allowed but optional](https://coffeescript.org/#language);
when omitted, they implicitly extend to the end of the line.
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
</table>

CoffeeScript allows calling a function with a variable number of arguments,
and getting back all remaining arguments, with
[splats (`...`)](https://coffeescript.org/#splats):

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

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

## Variable scoping

CoffeeScript has no variable declarations like Python's
[`global`](https://docs.python.org/3/reference/simple_stmts.html#the-global-statement)
and
[`nonlocal`](https://docs.python.org/3/reference/simple_stmts.html#the-nonlocal-statement).
[CoffeeScript's only behavior](https://coffeescript.org/#lexical-scope)
is the equivalent of Python's `nonlocal`:
a variable is local to a function if it is assigned in that function
**and it is not assigned in any higher scope**.
An exception is that function arguments are always local to the function,
with together with CoffeeScript's `do` makes it simple to explicitly request
Python's default behavior.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
def f(x):
  def next():
    nonlocal x
    x += 1
    return x
  return [next(), next()]
```

</td><td markdown="1">

```coffeescript
f = (x) ->
  next = ->
    x += 1  # implicitly return x
  [next(), next()]
```

</td></tr>
<tr><td markdown="1">

```python
def f(x):
  def g(x):
    return -x
  return g(x+1)
```

</td><td markdown="1">

```coffeescript
f = (x) ->
  g = (x) -> -x
  g x+1
```

</td></tr>
<tr><td markdown="1">

```python
def delay(bits):
  out = []
  for bit in bits:
    def g(): # bit stored in closure
      return bit
    out.append(g)
  return out
```

</td><td markdown="1">

```coffeescript
delay = (bits) ->
  for bit in bits
    do (bit) -> # force locally scoped bit
      -> bit
```

</td></tr>
<tr><td markdown="1">

```python
def recurse(x, stack = []):
  for item in x:
    stack.append(item)
    recurse(item)
    stack.pop()
recurse(root)
```

</td><td markdown="1">

```coffeescript
stack = []
recurse = (x) ->
  for item in x
    stack.push item
    recurse item
    stack.pop()
recurse root
```

</td></tr>
</table>

## if/then/else and switch

[CoffeeScript `if`s](https://coffeescript.org/#conditionals)
are similar to Python's, except that `elif` is spelled `else if`.
In addition, CoffeeScript offers `unless` as a more intuitive `if not`,
and allows a one-line suffixed `if` (and `unless`).

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
if error:
  return
```

</td><td markdown="1">

```coffeescript
if error
  return
#or
return if error
```

</td></tr>
<tr><td markdown="1">

```python
if not ok:
  continue
```

</td><td markdown="1">

```coffeescript
unless ok
  continue
#or
continue unless ok
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

## while loops

[CoffeeScript `while` loops](https://coffeescript.org/#loops)
are roughly identical to Python's.
Like `unless`, `until` is shorthand for `while not`.
In addition, `loop` is shorthand for `while true`.
Like `if` and `unless`, `while` and `until` have a one-line suffix form.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
while this or that:
  ...
```

</td><td markdown="1">

```coffeescript
while this or that
  ...
```

</td></tr>
<tr><td markdown="1">

```python
while items:
  items.pop()
```

</td><td markdown="1">

```coffeescript
items.pop() while items.length
```

</td></tr>
<tr><td markdown="1">

```python
while not done:
  ...
```

</td><td markdown="1">

```coffeescript
until done
  ...
```

</td></tr>
<tr><td markdown="1">

```python
while True:
  ...
```

</td><td markdown="1">

```coffeescript
loop
  ...
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

## Comparison operators

Most Python comparison/Boolean operators have
[the same name in CoffeeScript](https://coffeescript.org/#operators)
(in addition to offering C-style names).
CoffeeScript also supports
[chained comparisons](https://coffeescript.org/#comparisons)
just like Python.
One key difference is that `==` and `!=` are shallow comparisons, not deep,
and `[]` and `{}` are considered `true` in CoffeeScript.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
True
False
```

</td><td markdown="1">

```coffeescript
true
false
```

</td></tr>
<tr><td markdown="1">

```python
1+2 == 3  # True
1 < 2 < 3 # True
```

</td><td markdown="1">

```coffeescript
1+2 == 3  # true
1 < 2 < 3 # true
```

</td></tr>
<tr><td markdown="1">

```python
x == 5 and not (y < 5 or done)
```

</td><td markdown="1">

```coffeescript
x == 5 and not (y < 5 or done)
```

</td></tr>
<tr><td markdown="1">

```python
b = bool(object)
```

</td><td markdown="1">

```coffeescript
b = new Boolean object
#or
b = not not object
#or
b = !!object
```

</td></tr>
<tr><td markdown="1">

```python
if items: # check for nonempty list
  process(items)
```

</td><td markdown="1">

```coffeescript
if items.length: # check for nonempty list
  process(items)
```

</td></tr>
<tr><td markdown="1">

```python
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

## Python list / CoffeeScript Array

[CoffeeScript arrays](https://coffeescript.org/#objects-and-arrays) include
notation similar to Python `list`s, as well as an indentation-based notion
that avoids the need for commas.

The resulting [JavaScript `Array` type](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)
has many similar methods to Python `list`, though often with different names.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

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
3 in x
3 not in x
```

</td><td markdown="1">

```coffeescript
3 in x
3 not in x
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
last = x.pop()
first = x.pop(0)
```

</td><td markdown="1">

```coffeescript
last = x.pop()
first = x.shift()
```

</td></tr>
<tr><td markdown="1">

```python
x.reverse()
```

</td><td markdown="1">

```coffeescript
x.reverse()
```

</td></tr>
<tr><td markdown="1">

```python
x.sort(key = lambda item: str(item))
```

</td><td markdown="1">

```coffeescript
x.sort() # sort by string value
```

</td></tr>
<tr><td markdown="1">

```python
min(x)
max(x)
min(a, b)
max(a, b)
```

</td><td markdown="1">

```coffeescript
Math.min ...x
Math.max ...x
Math.min a, b
Math.max a, b
```

</td></tr>
<tr><td markdown="1">

```python
try:
  i = x.index(a)
except ValueError:
  i = -1
```

</td><td markdown="1">

```coffeescript
i = x.indexOf a
```

</td></tr>
<tr><td markdown="1">

```python
try:
  i = x.index(a, 5)
except ValueError:
  i = -1
```

</td><td markdown="1">

```coffeescript
i = x.indexOf a, 5
```

</td></tr>
<tr><td markdown="1">

```python
x + y + z
```

</td><td markdown="1">

```coffeescript
x.concat y, z
```

</td></tr>
</table>

See also [array slicing](#slicing-and-range).

CoffeeScript has no analog to Python's `tuple` type, but the same effect of
"an unchangable list" can be obtained via `Object.freeze`:

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>
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

Python has two key/value mechanisms: `hasattr`/`getattr`/`setattr`
for object attributes and `__contains__`/`__getitem__`/`__setitem__`
for dictionaries.  CoffeeScript has no such asymmetry, making regular
`Object`s a fine substitute for dictionaries.

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
d.get(key)
```

</td><td markdown="1">

```coffeescript
d[key]
```

</td></tr>
<tr><td markdown="1">

```python
d.get('hello')
```

</td><td markdown="1">

```coffeescript
d.hello
#or
d['hello']
```

</td></tr>
<tr><td markdown="1">

```python
d.set('hello', 'bye')
```

</td><td markdown="1">

```coffeescript
d.hello = 'bye'
#or
d['hello'] = 'bye'
```

</td></tr>
<tr><td markdown="1">

```python
del d[key]
```

</td><td markdown="1">

```coffeescript
delete d[key]
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
# Safer version, in case Object has added properties:
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
list(d.keys())
list(d.values())
list(d.items())
```

</td><td markdown="1">

```coffeescript
Object.keys d
Object.values d
Object.entries d
```

</td></tr>
<tr><td markdown="1">

```python
len(d)
```

</td><td markdown="1">

```coffeescript
Object.keys(d).length
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

## Python dict / CoffeeScript Map

While [CoffeeScript objects are a fine substitute for dictionaries](#python-dict--coffeescript-object),
they have
[a few limitations](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map#Objects_and_maps_compared),
most notably, that all keys in objects must be strings.
(You can use e.g. numbers as keys, but they get mapped to strings.)
The built-in `Map` type solves this problem, acting more like Python `dict`s,
but their syntax is uglier.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
d = {1: 2, 'hello': 'world'}
```

</td><td markdown="1">

```coffeescript
d = new Map [
  [1, 2]
  ['hello', 'world']
]
```

</td></tr>
<tr><td markdown="1">

```python
len(d)
```

</td><td markdown="1">

```coffeescript
d.size
```

</td></tr>
<tr><td markdown="1">

```python
d.get(key)
```

</td><td markdown="1">

```coffeescript
d.get key
```

</td></tr>
<tr><td markdown="1">

```python
d[key] = value
```

</td><td markdown="1">

```coffeescript
d.set key, value
```

</td></tr>
<tr><td markdown="1">

```python
del d[key]
```

</td><td markdown="1">

```coffeescript
d.delete key
```

</td></tr>
<tr><td markdown="1">

```python
key in d
```

</td><td markdown="1">

```coffeescript
d.has key
```

</td></tr>
<tr><td markdown="1">

```python
for key, value in d.items():
```

</td><td markdown="1">

```coffeescript
for [key, value] from d
```

</td></tr>
<tr><td markdown="1">

```python
d.keys()
d.values()
d.items()
```

</td><td markdown="1">

```coffeescript
d.keys()
d.values()
d.entries()
```

</td></tr>
<tr><td markdown="1">

```python
d.setdefault(key, value)
```

</td><td markdown="1">

```coffeescript
d.set key, value unless d.has key
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
5 in x
x.add(5)
x.discard(7)
```

</td><td markdown="1">

```coffeescript
# x is a set
x.has 5
x.add 5
x.delete 7

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
# x is a Set
if x.size
  console.log x.size, 'elements'
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
# x is a Set
for item from x
  console.log item
```

</td></tr>
<tr><td markdown="1">

```python
iter(x)
```

</td><td markdown="1">

```coffeescript
x.values()
```

</td></tr>
</table>

## Comprehensions

[CoffeeScript array comprehensions](https://coffeescript.org/#loops)
are similar to Python's list comprehensions, but written with parentheses
instead of brackets and with `when` instead of `if`.
Unlike Python, they are just a one-line inverted form of a regular `for` loop
(symmetric to the [one-line inverted `if`](#ifthenelse-and-switch)),
and can also be written in the non-inverted multiline form.

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
#or
y = list(filter(condition, map(f, x)))
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

CoffeeScript lacks dictionary/object comprehensions.

## Generator Functions

[CoffeeScript generator functions](https://coffeescript.org/#generators)
are roughly identical to Python's, except that
looping over generators requires `for...from` instead of `for...in`.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
def positive_ints():
  n = 0
  while True:
    n += 1
    yield n
```

</td><td markdown="1">

```coffeescript
positive_ints = ->
  n = 0
  loop
    n += 1
    yield n
```

</td></tr>
<tr><td markdown="1">

```python
for i in positive_ints():
```

</td><td markdown="1">

```coffeescript
for i from positive_ints()
```

</td></tr>
</table>

## Slicing and range

[CoffeeScript slicing](https://coffeescript.org/#slices) features two
notations for the range from `i` to `j`: `i...j` excludes `j` like
Python's `i:j`, while `i..j` includes `j`.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
list(range(7, 10))
# [7, 8, 9]
```

</td><td markdown="1">

```coffeescript
[7...10]
#or
[7..9]
```

</td></tr>
<tr><td markdown="1">

```python
for i in range(9999):
  # list not generated
  # (in Python 3)
```

</td><td markdown="1">

```coffeescript
for i in [0...9999]
  # list not generated
```

</td></tr>
<tr><td markdown="1">

```python
# x is str or list
x[7:10] # 7, 8, 9
```

</td><td markdown="1">

```coffeescript
# x is String or Array
x[7...10] # 7, 8, 9
#or
x[7..9]   # 7, 8, 9
```

</td></tr>
<tr><td markdown="1">

```python
# x is list
x[7:10] = ['a', 'b']
x.insert(0, 'c')
x.insert(7, 'd')
del x[7]
del x[7:10]
x.clear()
y = x.copy()
```

</td><td markdown="1">

```coffeescript
# x is Array
x[7...10] = ['a', 'b']
x.unshift 'c'
x[7...7] = ['d']
x[7...7] = []
x[7...10] = []
x[..] = []
y = x[..]
```

</td></tr>
<tr><td markdown="1">

```python
# x is str or list
x[:] # shallow copy
```

</td><td markdown="1">

```coffeescript
# x is String or Array
x[..] # shallow copy
```

</td></tr>
<tr><td markdown="1">

```python
# x is str or list
x[:-1]
```

</td><td markdown="1">

```coffeescript
# x is String or Array
x[...-1]
```

</td></tr>
</table>

Note that negative numbers behave like Python in slices,
but negative numbers behave differently when simply getting an item:
`x[-1]` is equivalent to `x['-1']` and will typically return `undefined`;
to access the last element, use `x[x.length-1]`.

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

CoffeeScript defines an
[existential `?` operator](https://coffeescript.org/#existential-operator),
both a unary form to test for `undefined` or `null`, and a binary form
to provide alternate (default) values in case of `undefined` or `null`:

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

CoffeeScript also defines
[many conditional operators](https://coffeescript.org/#existential-operator)
that apply the operator only when the left-hand side isn't
`undefined` or `null` (and otherwise leaves it alone):

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
<tr><td markdown="1">

```python
d[key] if d is not None else d
```

</td><td markdown="1">

```coffeescript
d?[key]
```

</td></tr>
<tr><td markdown="1">

```python
if callback is not None:
  callback(value)
```

</td><td markdown="1">

```coffeescript
callback?(value)
#or
callback? value
```

</td></tr>
<tr><td markdown="1">

```python
if x is not None and hasattr(x, 'set') and x.set is not None:
  x.set(5)
```

</td><td markdown="1">

```coffeescript
x?.set?(5)
#or
x?.set? 5
```

</td></tr>
</table>

## Regular expressions

CoffeeScript has built-in Perl-like `/.../` syntax for regular expressions,
and a triple-slash version `///...///` for multiline regular expressions
that ignores whitespace.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
r = re.compile(r'^Hello (\w+)',
      re.IGNORECASE | re.MULTILINE)
```

</td><td markdown="1">

```coffeescript
r = /^Hello (\w+)/im
```

</td></tr>
<tr><td markdown="1">

```python
r = re.compile(r'[(\[]*(\d+)/(\d+)/(\d+)[)\]]*')
```

</td><td markdown="1">

```coffeescript
r = /[(\[]*(\d+)\/(\d+)\/(\d+)[)\]]*/
#or
r = ///
  [(\[]*        # leading brackets
  (\d+) \/ (\d+) \/ (\d+)  # y/m/d
  [)\]]*        # closing brackets
///
```

</td></tr>
<tr><td markdown="1">

```python
def bracket(word):
  return re.compile(r'^[(\[]*' + word + r'[)\]]*')
```

</td><td markdown="1">

```coffeescript
bracket = (word) ->
  new RegExp "^[(\\[]*#{word}[)\\]]*"
#or
bracket = (word) ->
  /// ^[(\\[]* #{word} [)\\]]* ///
```

</td></tr>
<tr><td markdown="1">

```python
match = r.search(string)
match.group(0) # whole match
match.group(1) # first group
match.start()  # start index
match.string   # input string
```

</td><td markdown="1">

```coffeescript
match = r.exec string
match[0]     # whole match
match[1]     # first group
match.index  # start index
match.input  # input string
```

</td></tr>
<tr><td markdown="1">

```python
if r.search(string):
```

</td><td markdown="1">

```coffeescript
if r.test string
```

</td></tr>
<tr><td markdown="1">

```python
for match in re.finditer(r'(pattern)', string):
  match.group(0) # whole match
  match.group(1) # first group
  match.start()  # start index
  match.string   # input string
```

</td><td markdown="1">

```coffeescript
while (match = /(pattern)/g.exec string)?
  match[0]     # whole match
  match[1]     # first group
  match.index  # start index
  match.input  # input string
```

</td></tr>
<tr><td markdown="1">

```python
out = re.sub(r'pattern', repl, string)
```

</td><td markdown="1">

```coffeescript
out = string.replace /pattern/g, repl
```

</td></tr>
<tr><td markdown="1">

```python
out = re.sub(r'pattern', repl, string, 1)
```

</td><td markdown="1">

```coffeescript
out = string.replace /pattern/, repl
```

</td></tr>
<tr><td markdown="1">

```python
out = re.sub(r'(pattern)', r'$(\1) \&', string)
```

</td><td markdown="1">

```coffeescript
out = string.replace /(pattern)/g, '$$($1) $&'
```

</td></tr>
<tr><td markdown="1">

```python
def replacer(match):
  all = match.group(0)
  group1 = match.group(1)
  index = match.start()
  string = match.string
  ...
out = re.sub(r'(pattern)', r'$(\1) \&', replacer)
```

</td><td markdown="1">

```coffeescript
out = string.replace /(pattern)/g,
  (all, group1, index, string) ->
    # (unneeded arguments can be omitted)
    ...
```

</td></tr>
<tr><td markdown="1">

```python
out = re.sub(r'(pattern)', r'$(\1) \&', string)
```

</td><td markdown="1">

```coffeescript
out = string.replace /(pattern)/g, '$$($1) $&'
```

</td></tr>
<tr><td markdown="1">

```python
out = re.split(r'\s*,\s*', string)
```

</td><td markdown="1">

```coffeescript
out = string.split /\s*,\s*/
```

</td></tr>
<tr><td markdown="1">

```python
out = re.split(r'\s*,\s*', string, limit)
```

</td><td markdown="1">

```coffeescript
out = string.split /\s*,\s*/, limit
```

</td></tr>
</table>

[Regular expression syntax and usage](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions)
is roughly the same, with some exceptions:

* CoffeeScript doesn't support `(?P<...>...)`, `(?<=...)`, `(?<!...)`,
  `(?#...)`, `(?(...)...|...)`, `\A`, or `\Z` in regular expressions.
* In CoffeeScript, `/` needs to be escaped as `\/` within `/.../`.
  Also, spaces right next to the surrounding `/`s can confuse the parser,
  so you may need to write them as `[ ]` (for example).
* CoffeeScript doesn't support flags `re.ASCII`, `re.DEBUG`, `re.LOCALE`,
  or `re.DOTALL`.  (`///...///` is the analog of `re.VERBOSE`.)
  You can simulate an `re.DOTALL`-style `.` with `[^]`.
* CoffeeScript's `\d` matches just `[0-9]`, and `\w` matches just `[a-zA-Z_]`,
  instead of the Unicode notions matched by Python.
  However, `\s` matches all Unicode space characters like Python.
* CoffeeScript replacement patterns need to use `$...` instead of `\...`
  (and `$50` instead of `\g<50>`), and thus need to have `$` escaped as `$$`.
  Additional replacement features are ``` $` ```, which expands to the portion
  of the string before the match, and ``` $' ```, which expands to the portion
  of the string after the match.

## Classes

[CoffeeScript classes](https://coffeescript.org/#classes) behave similar
to Python classes, but are internally implemented with prototypes, so do
not support multiple inheritence.  CoffeeScript provides `@` as a helpful
alias for `this` (the analog of `self` in Python), and `@foo` as an alias
for `@.foo`.

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

### `->` vs. `=>`

Within methods, use `=>` in place of `->` to construct a function with
the same value of `this` (`@`) as the method creating it.

<table>
<thead><tr><th>Python</th><th>CoffeeScript</th></tr></thead>

<tr><td markdown="1">

```python
class Accumulator:
  def __init__(self):
    self.value = 0
  def adder(self):
    def add(x):
      self.value += x
    return add
```

</td><td markdown="1">

```coffeescript
class Accumulator:
  constructor: ->
    @value = 0
  adder: ->
    (x) => @value += x
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

# Package Management (on Node)

The analog of [PyPI](https://pypi.org/) (Python Package Index)
is [NPM](http://npmjs.org/) (Node Package Manager).
The analog of command-line tool [`pip`](https://pypi.org/project/pip/)
is [`npm`](https://docs.npmjs.com/cli/npm).

Unlike PyPI, NPM packages are usually installed locally to each project,
which makes it easy for different projects to use different versions of the
same package.  To get started, run
```sh
npm init
```
This will ask questions for the creation of a stub `package.json` file.

Then you can install packages local to your project using `npm install`.
For example, to install the
[`underscore` package](https://www.npmjs.com/package/underscore)
(written by the same author as CoffeeScript), run
```sh
npm install underscore
```
This will install the package in `node_packages/underscore`,
and change `package.json` to note which version you depend on.

You can use a package installed in this way via
```coffeescript
_ = require 'underscore'
```

It's also easy to create your own packages and publish them for others to use.

# About

This document is by [Erik Demaine](http://erikdemaine.org).
The top image is based on the
[CoffeeScript logo](https://github.com/jashkenas/coffeescript/tree/master/documentation/site)
and
[this free Python clipart](https://www.svgimages.com/cute-python-clipart.html).
