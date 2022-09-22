<img src=".github/assets/banner.png">

A esoteric interpreted language made in Nim based on a 3x3 grid of zeros and ones.

![Code Size](https://img.shields.io/github/languages/code-size/MrEnder0/Grid9?style=for-the-badge)

[![Nightly Release](https://github.com/MrEnder0/Grid9/actions/workflows/nightly.yml/badge.svg)](https://github.com/MrEnder0/Grid9/actions/workflows/nightly.yml)

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/MrEnder0/Grid9)

## Installation

### Binaries

Download the latest release from the releases page and run the installer.
Note: Seems that currently any version 2022-012 or newer will require nim to be installed on the system for Windows.

### Source

#### Windows

Make sure nim and git are installed then run the following commands.

```cmd
nimble install docopt -y
git clone https://github.com/MrEnder0/Grid9.git
cd Grid9
nim c -d:release main.nim
```

#### Linux

```bash
sudo apt-get update
sudo apt-get install git
sudo apt-get install nim
nimble install docopt -y
git clone https://github.com/MrEnder0/Grid9.git
cd Grid9
nim c -d:release main
```

## Future plans

Note in between updates there may be other smaller changes. Also none of these are in any particular order.

### High priority

- Allow while nesting
- Add more checks to the advanced parse option

### Low priority

- Add code blocks to the documentation.
- Create github action to test code on push.
