# CoffeeScript for Python programmers

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
  
</table>

### Python dict / CoffeeScript Object

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  X = {1: 2, 3: 4}
  ```

<td>

  ```coffeescript
  x = {1: 2, 3: 4}
  #or
  x =
    1: 2
    3: 4
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

### Comparison operators

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

  ```python
  1+2 == 3  # True
  1 < 2 < 3 # True
  x = [1, 2, 3]
  y = [1, 2, 3]
  x is x    # True
  x is y    # False
  x == x    # True
  x == y    # True
  ```

<td>
  
  ```coffeescript
  1+2 == 3  # true
  1 < 2 < 3 # true
  x = [1, 2, 3]
  y = [1, 2, 3]
  x == x    # true
  x == y    # false
  _.isEqual x, x  # true
  _.isEqual x, y  # false
  ```

</table>

## Installation / Getting Started

### Windows
### MacOS
### Linux
