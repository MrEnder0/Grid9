from glyphs import nil

import std/terminal, strformat, strutils, tables, random, times, os

iterator `...`*[T](a: T, b: T): T =
    var res: T = T(a)
    while res <= b:
        yield res
        inc res

proc logThis(mode: string, message: string, verbosity: int) : string {.discardable.} =
    when defined windows:
        const logDir = r"C:\ProgramData\Grid9\logs\"
    else:
        const logDir = "/usr/share/Grid9/logs/"
    let
        time = now().format("yyyy-MM-dd HH:mm:ss")
        logFile = open(logDir & now().format("yyyy-MM-dd") & ".log", fmAppend)
    case mode
    of "INFO":
        if verbosity >= 2:
            stdout.styledWriteLine(fgCyan, mode, fgWhite, " ", message)
            logFile.writeLine(fmt"{time} - {mode} - {message}")
    of "WARNING":
        if verbosity >= 1:
            stdout.styledWriteLine(fgYellow, mode, fgWhite, " ", message)
            logFile.writeLine(fmt"{time} - {mode} - {message}")
    of "ERROR":
        if verbosity >= 0:
            stdout.styledWriteLine(fgRed, mode, fgWhite, " ", message)
            logFile.writeLine(fmt"{time} - {mode} - {message}")
    logFile.close()

proc interpret*(parsed_code: string, echoGridMod: bool, noLog: bool, verbosity: int) : string {.discardable.} =

    if not noLog: logThis("INFO", "Interpreting script", verbosity)

    #initate all the varibles
    var
        mem_grid: Table[string, int]
        mem_queue: string = ""
        saved_grid : Table[string, int]
        if_nest_depth: int = 0
        while_pos = newSeq[int]()
        while_pos_end: int = 0
        if_pos_end: int
        c_index: int = 0
        
    randomize()

    #generate a 3x3 memory grid
    for i in 0...8:
        mem_grid[$i] = 0

    #generate 9 empty grid saves
    for i in 0...8:
        saved_grid[$i] = 000000000

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
                    if not noLog: logThis("ERROR", "Invalid syntax for flip command", verbosity)

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
                    if not noLog: logThis("ERROR", "Invalid syntax for set command", verbosity)

            #set all command
            of $'a':
                try:
                    if $parsed_code[c_index + 1] == $'r':
                        for i in 0...8:
                            mem_grid[$i] = rand(1)
                        if echoGridMod == true:echo $mem_grid
                    if $parsed_code[c_index + 1] == $'f':
                        for i in 0...8:
                            if mem_grid[$i] == 0:
                                mem_grid[$i] = 1
                            else:
                                mem_grid[$i] = 0
                        if echoGridMod == true:echo $mem_grid
                    else:
                        for i in 0...8:
                            mem_grid[$i] = parseint($parsed_code[c_index + 1])
                        if echoGridMod == true:echo $mem_grid
                except:
                    if not noLog: logThis("ERROR", "Invalid syntax for set all command", verbosity)

            #queue command
            of $'q':
                try:
                    if parsed_code[c_index + 1] == 's':
                        mem_queue = mem_queue & glyphs.get_glyph($mem_grid["0"] & $mem_grid["1"] & $mem_grid["2"] & $mem_grid["3"] & $mem_grid["4"] & $mem_grid["5"] & $mem_grid["6"] & $mem_grid["7"] & $mem_grid["8"])
                    elif parsed_code[c_index + 1] == 'c':
                        mem_queue = ""
                    else:
                        if not noLog: logThis("ERROR", "Invalid option for queue command", verbosity)
                    c_index += 1
                except:
                    if not noLog: logThis("ERROR", "Issue with queue command", verbosity)

            #print command
            of $'p':
                if mem_queue != "":
                    echo mem_queue
                    mem_queue = ""
                else:
                    echo glyphs.get_glyph($mem_grid["0"] & $mem_grid["1"] & $mem_grid["2"] & $mem_grid["3"] & $mem_grid["4"] & $mem_grid["5"] & $mem_grid["6"] & $mem_grid["7"] & $mem_grid["8"])

            #grid command
            of $'g':
                case parsed_code[c_index + 1]
                of 'g':
                    try:
                        let givedInput = readLine(stdin)
                        if len(gived_input) == 9:
                            for i in 0...8:
                                mem_grid[$i] = parseint($givedInput[i])
                        else:
                            if not noLog: logThis("ERROR", "Input for grid give command was not 9 numbers long", verbosity)
                        discard givedInput
                    except:
                        if not noLog: logThis("ERROR", "Invalid syntax for grid give command", verbosity)
                of 's':
                    try:
                        let save = $2 & $mem_grid["0"] & $mem_grid["1"] & $mem_grid["2"] & $mem_grid["3"] & $mem_grid["4"] & $mem_grid["5"] & $mem_grid["6"] & $mem_grid["7"] & $mem_grid["8"]
                        saved_grid[$parsed_code[c_index + 2]] = parseint(save)
                        c_index += 2
                        discard save
                    except:
                        if not noLog: logThis("ERROR", "Invalid syntax for grid save command", verbosity)
                of 'l':
                    try:
                        let load = $saved_grid[$parsed_code[c_index + 2]]
                        for i in 1...8:
                            mem_grid[$i] = parseint($load[i+1])
                        if echoGridMod == true:echo $mem_grid
                        c_index += 2
                        discard load
                    except:
                        if not noLog: logThis("ERROR", "Invalid syntax for grid load command", verbosity)
                of 'm':
                    try:
                        let mask = $saved_grid[$parsed_code[c_index + 2]]
                        for i in 1...8:
                            if mask[i+1] == '1':
                                mem_grid[$i] = 1
                        if echoGridMod == true:echo $mem_grid
                        c_index += 2
                        discard mask
                    except:
                        if not noLog: logThis("ERROR", "Invalid syntax for grid mask command", verbosity)
                of 'x':
                    try:
                        let xorGrid =
                            if $parsed_code[c_index + 2] == $'c':
                                $mem_grid["0"] & $mem_grid["1"] & $mem_grid["2"] & $mem_grid["3"] & $mem_grid["4"] & $mem_grid["5"] & $mem_grid["6"] & $mem_grid["7"] & $mem_grid["8"]
                            else:
                                $saved_grid[$parsed_code[c_index + 2]]
                        for i in 0...8:
                            if mem_grid[$i] == 1:
                                mem_grid[$i] = 0
                            else:
                                mem_grid[$i] = 1
                        if echoGridMod == true:echo $mem_grid
                        c_index += 2
                        discard xorGrid
                    except:
                        if not noLog: logThis("ERROR", "Invalid syntax for grid xor command", verbosity)
                else:
                    if not noLog: logThis("ERROR", "Invalid syntax for grid command", verbosity)

            #if command
            of $'i':
                try:
                    case parsed_code[c_index + 2]
                    of '=':
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

                    of '!':
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
                        if not noLog: logThis("ERROR", "Invalid operator for if statement", verbosity)
                except:
                    if not noLog: logThis("ERROR", "Invalid if statement", verbosity)

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
                        if not noLog: logThis("ERROR", "Invalid while statement", verbosity)

            #exit command
            of $'x':
                while_pos_end = c_index
                try:
                    while parsed_code[while_pos_end] != ']':
                        while_pos_end += 1
                    c_index = while_pos_end
                    discard while_pos_end
                except:
                    if not noLog: logThis("ERROR", "No end could be found for the exit statement", verbosity)
            #back command
            of $'b':
                try:
                    c_index -= parseint($parsed_code[c_index + 1])
                except:
                    if not noLog: logThis("ERROR", "Invalid back command", verbosity)

            #delay command
            of $'d':
                try:
                    sleep(parseint($parsed_code[c_index + 1])*1000)
                except:
                    if not noLog: logThis("ERROR", "Invalid delay command", verbosity)

            #terminate command
            of $'t':
                {.linearScanEnd.}
                if not noLog: logThis("INFO", "Script terminated by user", verbosity)
                break

            #Go to start of while loop
            if c_index == len(parsed_code)-1 or parsed_code[c_index] == ']':
                if while_pos == @[]:
                    return
                elif while_pos.len > 0:
                    c_index = while_pos[0]
                else:
                    discard

            c_index += 1

    except:
        if not noLog:
            logThis("ERROR", "Unknown error in script with the character " & parsed_code[c_index] & " at index " & $c_index, verbosity)
        return