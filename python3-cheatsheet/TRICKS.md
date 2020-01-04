# Tricks

## Reverse list
```
for i in reversed([1, 2, 3]):
    print(i)                    # 3, 2, 1
```

## Enumerate iterable object
```
for key, val in enumerate(["Hello", "World", "!"]):
    print("key {}, val {}".format(key,val))
```

## Trick for creating enums:
```
class Color:
    Red, Green, Blue = range(2)

print(Color.Red)    # prints 0
```