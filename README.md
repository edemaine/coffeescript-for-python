# CoffeeScript for Python programmers

## Quick Reference Guide

> Should we have both "minimalist" and more-paren styles of CoffeeScript?
> Note that [IPython's autocall magic](http://ipython.readthedocs.io/en/stable/interactive/magics.html#magic-autocall)
> simulates the minimalist style in Python!

<table style="background-color: #f6f8fa;">
<tr><th> Python <th> CoffeeScript

<tr><td>

(2)
```python
print "Hello world"
```
<br>

(3)
```python
print("Hello world")
```

<td>

```coffeescript
console.log "Hello world"
console.log('Hello world')
```

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
