# CoffeeScript for Python programmers

## Quick Reference Guide

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

## Installation / Getting Started

### Windows
### MacOS
### Linux
