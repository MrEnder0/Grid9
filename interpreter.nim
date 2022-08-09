import std/strformat
import tables

iterator `...`*[T](a: T, b: T): T =
    var res: T = T(a)
    while res <= b:
        yield res
        inc res

proc interpret*(parsed_code: string) : string {.discardable.} =
    var mem_grid: Table[string, string]

    #generate memory grid
    for i in 0...9:
        mem_grid[fmt"{i}"] = "0"

    for index in 0...len(parsed_code):
        echo parsed_code[index]
