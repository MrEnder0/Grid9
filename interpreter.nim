import std/strformat
import strutils
import tables

iterator `...`*[T](a: T, b: T): T =
    var res: T = T(a)
    while res <= b:
        yield res
        inc res

proc interpret*(parsed_code: string) : string {.discardable.} =
    var mem_grid: Table[string, string]
    var c_index: int = 0

    #generate memory grid
    for i in 0...9:
        mem_grid[fmt"{i}"] = "0"

    while c_index + 1 < len(parsed_code):
        if parsed_code[c_index] == 'f':
            if len(parsed_code) > c_index + 1:
                if parseint(mem_grid[fmt"{parsed_code[c_index + 1]}"]) == 0:
                    mem_grid[fmt"{parsed_code[c_index + 1]}"] = "1"
                else:
                    mem_grid[fmt"{parsed_code[c_index + 1]}"] = "0"

        c_index += 1
        #print mem_grid for debugging
        echo mem_grid["0"] & mem_grid["1"] & mem_grid["2"] & mem_grid["3"] & mem_grid["4"] & mem_grid["5"] & mem_grid["6"] & mem_grid["7"] & mem_grid["8"] & mem_grid["9"]
