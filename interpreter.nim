from glyths import nil
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
    var while_pos: int = -1
    var c_index: int = 0

    #generate memory grid
    for i in 0...8:
        mem_grid[fmt"{i}"] = "0"

    while c_index + 1 < len(parsed_code):
        #flip command
        if parsed_code[c_index] == 'f':
            if len(parsed_code) > c_index + 1:
                if parseint(mem_grid[fmt"{parsed_code[c_index + 1]}"]) == 0:
                    mem_grid[fmt"{parsed_code[c_index + 1]}"] = "1"
                else:
                    mem_grid[fmt"{parsed_code[c_index + 1]}"] = "0"
        #set command
        elif parsed_code[c_index] == 's':
            if len(parsed_code) > c_index + 2:
                mem_grid[fmt"{parsed_code[c_index + 1]}"] = fmt"{parsed_code[c_index + 2]}"

        #set all command
        elif parsed_code[c_index] == 'a':
            if len(parsed_code) > c_index + 1:
                for i in 0...8:
                    mem_grid[fmt"{i}"] = fmt"{parsed_code[c_index + 1]}"
        
        #print command
        elif parsed_code[c_index] == 'p':
            echo glyths.get_glyth(mem_grid["0"] & mem_grid["1"] & mem_grid["2"] & mem_grid["3"] & mem_grid["4"] & mem_grid["5"] & mem_grid["6"] & mem_grid["7"] & mem_grid["8"])

        #terminate command
        elif parsed_code[c_index] == 't':
            break

        #while command
        elif parsed_code[c_index] == 'w':
            if len(parsed_code) > c_index + 3:
                if parsed_code[c_index + 3] == '0':
                    if parseint(mem_grid[fmt"{parsed_code[c_index + 1]}"]) == 0:
                        while_pos = c_index + 1
                    else:
                        return
                if parsed_code[c_index + 3] == '1':
                    if parseint(mem_grid[fmt"{parsed_code[c_index + 1]}"]) == 1:
                        while_pos = c_index + 1
                    else:
                        return
    
        #Go to start of while loop
        if c_index == len(parsed_code)-1:
            if while_pos == -1:
                return
            else:
                c_index = while_pos
        
        c_index += 1

    echo "Final mem: " & mem_grid["0"] & mem_grid["1"] & mem_grid["2"] & mem_grid["3"] & mem_grid["4"] & mem_grid["5"] & mem_grid["6"] & mem_grid["7"] & mem_grid["8"]
