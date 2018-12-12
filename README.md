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

1. It is much **faster**: Node 9 runs typical JavaScript 2-5x faster than the
   equivalent Python (though the gap is much smaller using PyPy).
   This performance boost is thanks to extensive optimization, such as
   just-in-time compilation, because of the intense interest in web applications.
2. It can **run in any web browser**, making it easy to distribute your software
   for people to play with: just embed it in a web page.  This is also
   especially important for web development.
3. When running in a browser, you gain access to many **powerful GUI features**
   in the browser, notably HTML/CSS (e.g. buttons), SVG, WebGL, and Canvas.
   This makes it really easy to do complex graphics, both 2D and 3D.

## Quick Reference Guide

> Should we have both "minimalist" and more-paren styles of CoffeeScript?
> Note that [IPython's autocall magic](http://ipython.readthedocs.io/en/stable/interactive/magics.html#magic-autocall)
> simulates the minimalist style in Python!

### print

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  # Python 2
  print "Hello world", 1+2
  # Python 3
  print("Hello world", 1+2)
  ```

<td>

  ```coffeescript
  console.log "Hello world", 1+2
  #or
  console.log('Hello world', 1+2)
  #INVALID:
  #console.log ('Hello world', 1+2)
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
  ```

<td>

  ```coffeescript
  f(5)
  #or
  f 5
  # Note: f (5) is invalid
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

CoffeeScript defines a `?` operator to test for `undefined` or `null`.

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

## Installation / Getting Started

### Windows
### MacOS
### Linux
