from glyths import nil

import strformat, strutils, tables, random, times

iterator `...`*[T](a: T, b: T): T =
    var res: T = T(a)
    while res <= b:
        yield res
        inc res

proc logThis(mode: string, message: string) : string {.discardable.} =
    when defined windows:
        const logDir = r"C:\ProgramData\Grid9\logs\"
    else:
        const logDir = "/usr/share/Grid9/logs/"
    let
        time = now().format("yyyy-MM-dd HH:mm:ss")
        logFile = open(logDir & now().format("yyyy-MM-dd") & ".log", fmAppend)
    logFile.writeLine(fmt"{time} - {mode} - {message}")
    log_file.close()

proc interpret*(parsed_code: string, echoGridMod: bool, noLog: bool) : string {.discardable.} =

    if noLog: logThis("INFO", "Interpreting script")

    #initate all the varibles
    var
        mem_grid: Table[string, int]
        mem_queue: string = ""
        if_nest_depth: int = 0
        while_pos = newSeq[int]()
        while_pos_end = newSeq[int]()
        if_pos_end: int
        c_index: int = 0
        
    randomize()

    #generate a 3x3 memory grid
    for i in 0...8:
        mem_grid[$i] = 0

    try:
        while c_index < len(parsed_code):
            case $parsed_code[c_index]
            of $'f':
                try:
                    if mem_grid[$parsed_code[c_index + 1]] == 0:
                        mem_grid[$parsed_code[c_index + 1]] = 1
                        if echoGridMod == true:echo $mem_grid
                    else:
                        mem_grid[$parsed_code[c_index + 1]] = 0
                        if echoGridMod == true:echo $mem_grid
                except:
                    if noLog: logThis("ERROR", "Invalid syntax for flip command")

            #set command
            of $'s':
                try:
                    if $parsed_code[c_index + 2] == $'r':
                        mem_grid[$parsed_code[c_index + 1]] = rand(1)
                        if echoGridMod == true:echo $mem_grid
                    else:
                        mem_grid[$parsed_code[c_index + 1]] = parseint($parsed_code[c_index + 2])
                        if echoGridMod == true:echo $mem_grid
                except:
                    if noLog: logThis("ERROR", "Invalid syntax for set command")

            #set all command
            of $'a':
                try:
                    if $parsed_code[c_index + 1] == $'r':
                        for i in 0...8:
                            mem_grid[$i] = rand(1)
                        if echoGridMod == true:echo $mem_grid
                    else:
                        for i in 0...8:
                            mem_grid[$i] = parseint($parsed_code[c_index + 1])
                        if echoGridMod == true:echo $mem_grid
                except:
                    if noLog: logThis("ERROR", "Invalid syntax for set all command")

            #queue command
            of $'q':
                try:
                    if parsed_code[c_index + 1] == 's':
                        mem_queue = mem_queue & glyths.get_glyth($mem_grid["0"] & $mem_grid["1"] & $mem_grid["2"] & $mem_grid["3"] & $mem_grid["4"] & $mem_grid["5"] & $mem_grid["6"] & $mem_grid["7"] & $mem_grid["8"])
                    elif parsed_code[c_index + 1] == 'c':
                        mem_queue = ""
                    c_index += 1
                except:
                    if noLog: logThis("ERROR", "Invalid queue command")

            #print command
            of $'p':
                if mem_queue != "":
                    echo mem_queue
                    mem_queue = ""
                else:
                    echo glyths.get_glyth($mem_grid["0"] & $mem_grid["1"] & $mem_grid["2"] & $mem_grid["3"] & $mem_grid["4"] & $mem_grid["5"] & $mem_grid["6"] & $mem_grid["7"] & $mem_grid["8"])

            #grid command
            of $'g':
                case parsed_code[c_index + 1]
                of 'g':
                    let gived_input = readLine(stdin)
                    if len(gived_input) == 9:
                        for i in 0...8:
                            mem_grid[$i] = parseint($gived_input[i])
                    else:
                        if noLog: logThis("ERROR", "Input for grid give command was not 9 numbers long")
                else:
                    if noLog: logThis("ERROR", "Invalid syntax for grid command")

            #if command
            of $'i':
                try:
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
                except:
                    if noLog: logThis("ERROR", "Invalid if statement")

            #while command
            of $'w':
                #checks if the current c_index is in while_pos already skip it
                if c_index+1 in while_pos:
                    discard
                else:
                    try:
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
                    except:
                        if noLog: logThis("ERROR", "Invalid while statement")

            #exit command
            of $'x':
                while_pos_end.add(c_index + 1)
                while parsed_code[while_pos_end[0]] != ']':
                    while_pos_end.add(c_index + 1)
                c_index = if_pos_end

            #back command
            of $'b':
                try:
                    c_index -= parseint($parsed_code[c_index + 1])
                except:
                    if noLog: logThis("ERROR", "Invalid back command")

            #terminate command
            of $'t':
                {.linearScanEnd.}
                if noLog: logThis("INFO", "Script terminated by user")
                break

            #Go to start of while loop
            if c_index == len(parsed_code)-1 or parsed_code[c_index] == ']':
                if while_pos == @[]:
                    return
                else:
                    c_index = while_pos[0]

            c_index += 1

    except:
        if noLog: logThis("ERROR", "Unknown error in script on line " & $c_index)
        return