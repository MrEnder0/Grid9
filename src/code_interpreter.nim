from glyths import nil

import strformat, strutils, tables, random, times

iterator `...`*[T](a: T, b: T): T =
    var res: T = T(a)
    while res <= b:
        yield res
        inc res

proc log_this(mode: string, message: string) : string {.discardable.} =
    when defined windows:
        let log_dir = r"C:\ProgramData\Grid9\logs\"
    else:
        let log_dir = "/usr/share/Grid9/logs/"

    let time = now().format("yyyy-MM-dd HH:mm:ss")
    let log_file = open(log_dir & now().format("yyyy-MM-dd") & ".log", fmAppend)
    log_file.writeLine(fmt"{time} - {mode} - {message}")

    log_file.close()

proc interpret*(parsed_code: string, echoGridMod: bool, noLog: bool) : string {.discardable.} =

    if noLog: log_this("INFO", "Interpreting script")

    #initate all the varibles
    var mem_grid: Table[string, int]
    var mem_queue: string = ""
    var if_nest_depth: int = 0
    var while_pos = newSeq[int]()
    var while_pos_end = newSeq[int]()
    var if_pos_end: int
    var c_index: int = 0
    randomize()

    #generate a 3x3 memory grid
    for i in 0...8:
        mem_grid[$i] = 0

    try:
        while c_index < len(parsed_code):
            case $parsed_code[c_index]
            of $'f':
                if len(parsed_code) > c_index + 1:
                    if mem_grid[$parsed_code[c_index + 1]] == 0:
                        mem_grid[$parsed_code[c_index + 1]] = 1
                        if echoGridMod == true:echo $mem_grid
                    else:
                        mem_grid[$parsed_code[c_index + 1]] = 0
                        if echoGridMod == true:echo $mem_grid
                else:
                    if noLog: log_this("ERROR", "Invalid syntax for flip command")

            #set command
            of $'s':
                if len(parsed_code) > c_index + 2:
                    if $parsed_code[c_index + 2] == $'r':
                        mem_grid[$parsed_code[c_index + 1]] = rand(1)
                        if echoGridMod == true:echo $mem_grid
                    else:
                        mem_grid[$parsed_code[c_index + 1]] = parseint($parsed_code[c_index + 2])
                        if echoGridMod == true:echo $mem_grid
                else:
                    if noLog: log_this("ERROR", "Invalid syntax for set command")

            #set all command
            of $'a':
                if len(parsed_code) > c_index + 1:
                    if $parsed_code[c_index + 1] == $'r':
                        for i in 0...8:
                            mem_grid[$i] = rand(1)
                        if echoGridMod == true:echo $mem_grid
                    else:
                        for i in 0...8:
                            mem_grid[$i] = parseint($parsed_code[c_index + 1])
                        if echoGridMod == true:echo $mem_grid
                else:
                    if noLog: log_this("ERROR", "Invalid syntax for set all command")

            #queue command
            of $'q':
                if len(parsed_code) > c_index + 1:
                    if parsed_code[c_index + 1] == 's':
                        mem_queue = mem_queue & glyths.get_glyth($mem_grid["0"] & $mem_grid["1"] & $mem_grid["2"] & $mem_grid["3"] & $mem_grid["4"] & $mem_grid["5"] & $mem_grid["6"] & $mem_grid["7"] & $mem_grid["8"])
                    elif parsed_code[c_index + 1] == 'c':
                        mem_queue = ""
                    c_index += 1
                else:
                    if noLog: log_this("ERROR", "Invalid queue command")

            #print command
            of $'p':
                if mem_queue != "":
                    echo mem_queue
                    mem_queue = ""
                else:
                    echo glyths.get_glyth($mem_grid["0"] & $mem_grid["1"] & $mem_grid["2"] & $mem_grid["3"] & $mem_grid["4"] & $mem_grid["5"] & $mem_grid["6"] & $mem_grid["7"] & $mem_grid["8"])

            #give command
            of $'g':
                let gived_input = readLine(stdin)
                if len(gived_input) == 9:
                    for i in 0...8:
                        mem_grid[$i] = parseint($gived_input[i])
                else:
                    if noLog: log_this("ERROR", "Input for give command was not 9 numbers long")

            #if command
            of $'i':
                if len(parsed_code) > c_index + 3:
                    if parsed_code[c_index + 2] == '=':

                        if parsed_code[c_index + 3] == '0':
                            if mem_grid[$parsed_code[c_index + 1]] == 0:
                                discard
                            else:
                                #skips to end of if
                                if_nest_depth = 1
                                if_pos_end = c_index + 1
                                while parsed_code[if_pos_end] != '}':
                                    if parsed_code[if_pos_end] == 'i':
                                        if_nest_depth += 1
                                    elif parsed_code[if_pos_end] == '}':
                                        if_nest_depth -= 1
                                        if if_nest_depth == 0:
                                            c_index = if_pos_end
                                    if_pos_end += 1
                                c_index = if_pos_end

                        if parsed_code[c_index + 3] == '1':
                            if mem_grid[$parsed_code[c_index + 1]] == 1:
                                discard
                            else:
                                #skips to end of if
                                if_nest_depth = 1
                                if_pos_end = c_index + 1
                                while parsed_code[if_pos_end] != '}':
                                    if parsed_code[if_pos_end] == 'i':
                                        if_nest_depth += 1
                                    elif parsed_code[if_pos_end] == '}':
                                        if_nest_depth -= 1
                                        if if_nest_depth == 0:
                                            c_index = if_pos_end
                                    if_pos_end += 1
                                c_index = if_pos_end

                    elif parsed_code[c_index + 2] == '!':
                        if mem_grid[$parsed_code[c_index + 1]] != mem_grid[$parsed_code[c_index + 3]]:
                            discard
                        else:
                            #skips to end of if
                            if_nest_depth = 1
                            if_pos_end = c_index + 1
                            while parsed_code[if_pos_end] != '}':
                                if parsed_code[if_pos_end] == 'i':
                                    if_nest_depth += 1
                                elif parsed_code[if_pos_end] == '}':
                                    if_nest_depth -= 1
                                    if if_nest_depth == 0:
                                        c_index = if_pos_end
                                if_pos_end += 1
                            c_index = if_pos_end
                else:
                    if noLog: log_this("ERROR", "Invalid if statement")

            #while command
            of $'w':
                #checks if the current c_index is in while_pos already skip it
                if c_index+1 in while_pos:
                    discard
                else:
                    if len(parsed_code) > c_index + 3:
                        if parsed_code[c_index + 2] == '=':
                            if parsed_code[c_index + 3] == '0':
                                if mem_grid[$parsed_code[c_index + 1]] == 0:
                                    while_pos.add(c_index + 1)
                                else:
                                    while_pos.delete(0)
                            if parsed_code[c_index + 3] == '1':
                                if mem_grid[$parsed_code[c_index + 1]] == 1:
                                    while_pos.add(c_index + 1)
                                else:
                                    while_pos.delete(0)
                        elif parsed_code[c_index + 2] == '!':
                            if mem_grid[$parsed_code[c_index + 1]] != mem_grid[$parsed_code[c_index + 3]]:
                                while_pos.add(c_index + 1)
                            else:
                                while_pos.delete(0)
                    else:
                        if noLog: log_this("ERROR", "Invalid while statement")

            #exit command
            of $'x':
                while_pos_end.add(c_index + 1)
                while parsed_code[while_pos_end[0]] != ']':
                    while_pos_end.add(c_index + 1)
                c_index = if_pos_end

            #back command
            of $'b':
                if len(parsed_code) > c_index + 1:
                    c_index -= parseint($parsed_code[c_index + 1])
                else:
                    if noLog: log_this("ERROR", "Invalid back command")

            #terminate command
            of $'t':
                {.linearScanEnd.}
                if noLog: log_this("INFO", "Script terminated by user")
                break

            #Go to start of while loop
            if c_index == len(parsed_code)-1 or parsed_code[c_index] == ']':
                if while_pos == @[]:
                    return
                else:
                    c_index = while_pos[0]

            c_index += 1

    except:
        if noLog: log_this("ERROR", "Unknown error in script on line " & $c_index)
        return