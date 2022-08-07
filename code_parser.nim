import std/strformat

proc parse*(path: string) : string =
    return fmt"File is {path}"