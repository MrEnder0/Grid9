<img src="docs/banner.png">

# <p align="center">Grid9</p>
A esoteric interpreted language made in Nim based on a 3x3 grid of zeros and ones.

![](https://img.shields.io/github/languages/code-size/MrEnder0/Grid9?style=for-the-badge)
![](https://img.shields.io/github/issues-raw/MrEnder0/Grid9?style=for-the-badge "Bugs")
![](https://img.shields.io/github/issues-pr-raw/MrEnder0/Grid9?style=for-the-badge "PRs")

## Future plans:
Note in between updates there may be other smaller changes. Also none of these are in any particular order.

### High priority
 - Make windows not false positive the installer
 - Add logging system for debugging errors and script information.
 - Use booleans instead of strings for the grid array for better memory ussage and performance.
 - Allow while nesting

### Low priority
 - Create a cmhtl for local documentation
 - Make a update command for the cli tool
 - Add logging system for debugging errors and script information.
 - Clean up bad code and comment on more complex parts for readability.

## Syntax Example:
Here is a example of a conditional statement.

```grid9
i0=1f7p}
```

This checks if cell 0 = 1 and then if so it will flip cell 7 and print the glyth value.
