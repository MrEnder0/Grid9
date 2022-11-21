import std/terminal, std/md5, strformat, times, os, re

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

proc parse*(path: string, advancedParse: bool, dontCache: bool, noLog: bool, verbosity: int) : string =
    if not noLog: logThis("INFO", "Parsing script", verbosity)

    #Sets parser cache dir depending on OS
    when defined windows:
        const parserCacheDir = r"C:\ProgramData\Grid9\parser_cache\"
        if verbosity > 1:
            echo "Using Windows parser cache directory"
    else:
        const parserCacheDir = "/usr/share/Grid9/parser_cache/"
        if verbosity > 1:
            echo "Using Linux parser cache directory"

    let code = open(path)
    let fileHash = getMD5(path)
    var
        parsedCode: string
        line: string

    if advancedParse != true and dontCache != true and os.fileExists(parserCacheDir & $fileHash & ".g9") and readFile(path) & "\n" == readFile(parserCacheDir & $fileHash & "_pre.g9"):
        if verbosity >= 1:
            stdout.styledWriteLine(fgCyan, "INFO", fgWhite, " Using Cached Code\n")
        parsedCode = open(parserCacheDir & $fileHash & ".g9").read_line()
        return parsedCode
    else:
        while code.read_line(line):
            parsedCode = parsedCode & line
        
            #Strips whitespace, capital letters, parenthesis, and asterisks as comments
            parsedCode = replace(parsedCode, re("[A-Z*()\n\t ]+"), "")  

        if advancedParse == true:
            if verbosity >= 1:
                stdout.styledWriteLine(fgCyan, "INFO", fgWhite, " Doing advanced parse\n")

            var
                cIndex = 0
                ifDepth = 0
                whileDepth = 0
                isExited = false
            while cIndex < len(parsedCode):
                case $parsedCode[cIndex]
                of $'q':
                    if parsedCode[cIndex + 1] == 's':
                        discard
                    elif parsedCode[cIndex + 1] == 'c':
                        discard
                    else:
                        if not noLog: logThis("ERROR", "Invalid operation for queue command", verbosity)
                of $'i':ifDepth+=1
                of $'w':whileDepth+=1
                of $'}':ifDepth-=1
                of $']':
                    whileDepth-=1
                    if isExited == true:
                        isExited = false
                of $'b':
                    try:
                        if not match($parsedCode[cIndex + 1], re"0-9",):
                            if not noLog: logThis("ERROR", "Invalid value for back command", verbosity)
                    except:
                        if not noLog: logThis("ERROR", "No provided value for back command", verbosity)
                of $'x':
                    try:
                        if $parsedCode[cIndex - 1] != $'g':
                            isExited = true
                        else:
                            if $parsedCode[cIndex - 2] == $'g':
                                isExited = true
                    except:
                        isExited = true
                
                if ifDepth < 0:
                    if not noLog: logThis("ERROR", "If depth is less than 0", verbosity)
                if whileDepth < 0:
                    if not noLog: logThis("ERROR", "While depth is less than 0", verbosity)
                cIndex += 1

            if ifDepth > 0:
                if not noLog: logThis("WARNING", "If depth is greater than 0 would you like to automatically fix (y,n)", verbosity)
                let responce = readLine(stdin)
                if $responce == $'y':
                    var fixTimes = 0
                    while fixTimes < ifDepth:
                        parsedCode = parsedCode & $'}'
                        fixTimes += 1
                    discard fixTimes
                discard responce
            if whileDepth > 0:
                if not noLog: logThis("WARNING", "While depth is greater than 0 would you like to automatically fix (y,n)", verbosity)
                let responce = readLine(stdin)
                if $responce == $'y':
                    var fixTimes = 0
                    while fixTimes < whileDepth:
                        parsedCode = parsedCode & $']'
                        fixTimes += 1
                    discard fixTimes
                discard responce
            if isExited == true:
                if not noLog: logThis("WARNING", "Attemped to exit a while loop while not currently being in one would you like to automatically fix (y,n)", verbosity)
                let responce = readLine(stdin)
                if $responce == $'y':
                    parsedCode = parsedCode & $']'
                discard responce

        code.close()
        
        let
            parsedCodeFile = open(parserCacheDir & $fileHash & ".g9", fmWrite)
            unparsedCodeFile = open(parserCacheDir & $fileHash & "_pre.g9", fmWrite)
            
        parsedCodeFile.writeLine(parsedCode)
        unparsedCodeFile.writeLine(readFile(path))
        parsedCodeFile.close()
        unparsedCodeFile.close()
        return parsedCode
