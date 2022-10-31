import std/hashes, strformat, times, os, re

proc logThis(mode: string, message: string) : string {.discardable.} =
    when defined windows:
        const logDir = r"C:\ProgramData\Grid9\logs\"
    else:
        const logDir = "/usr/share/Grid9/logs/"
    let
        time = now().format("yyyy-MM-dd HH:mm:ss")
        logFile = open(logDir & now().format("yyyy-MM-dd") & ".log", fmAppend)
    logFile.writeLine(fmt"{time} - {mode} - {message}")
    logFile.close()

proc parse*(path: string, advancedParse: bool, dontCache: bool, noLog: bool) : string =
    let code = open(path)

    when defined windows:
        const parserCacheDir = r"C:\ProgramData\Grid9\parser_cache\"
    else:
        const parserCacheDir = "/usr/share/Grid9/parser_cache/"

    let fileHash = hash(path)
    var
        parsedCode: string
        line: string

    if advancedParse != true and dontCache != true and os.fileExists(parserCacheDir & $fileHash & ".g9") and readFile(path) & "\n" == readFile(parserCacheDir & $fileHash & "_pre.g9"):
        echo "Using Cached Code\n"
        parsedCode = open(parserCacheDir & $fileHash & ".g9").read_line()
        return parsedCode
    else:
        while code.read_line(line):
            parsedCode = parsedCode & line
        
            #Strips whitespace, capital letters, parenthesis, and asterisks as comments
            parsedCode = replace(parsedCode, re("[A-Z*()\n\t ]+"), "")  

        if advancedParse == true:
            echo "Doing advanced parse\n"
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
                        if not noLog: logThis("ERROR", "Invalid operation for queue command")
                        echo "ERROR: Invalid operation for queue command"
                of $'i':ifDepth+=1
                of $'w':whileDepth+=1
                of $'}':ifDepth-=1
                of $']':
                    whileDepth-=1
                    if isExited == true:
                        isExited = false
                of $'b':
                    if not match($parsedCode[cIndex + 1], re"0-9",):
                        if not noLog: logThis("ERROR", "Invalid number for back command")
                        echo "ERROR: Invalid number for back command"
                of $'x':
                    isExited = true
                
                if ifDepth < 0:
                    if not noLog: logThis("ERROR", "If depth is less than 0")
                    echo "ERROR: If depth is less than 0"
                if whileDepth < 0:
                    if not noLog: logThis("ERROR", "While depth is less than 0")
                    echo "ERROR: While depth is less than 0"

                cIndex += 1

            if ifDepth > 0:
                if not noLog: logThis("WARNING", "If depth is greater than 0")
                echo "WARNING: If depth is greater than 0 would you like to try to automatically fix? (y/n)"
                let responce = readLine(stdin)
                if $responce == $'y':
                    var fixTimes = 0
                    while fixTimes < ifDepth:
                        parsedCode = parsedCode & $'}'
                        fixTimes += 1
                    discard fixTimes
                discard responce
            if whileDepth > 0:
                if not noLog: logThis("WARNING", "While depth is greater than 0")
                echo "WARNING: While depth is greater than 0 would you like to try to automatically fix? (y/n)"
                let responce = readLine(stdin)
                if $responce == $'y':
                    var fixTimes = 0
                    while fixTimes < whileDepth:
                        parsedCode = parsedCode & $']'
                        fixTimes += 1
                    discard fixTimes
                discard responce
            if isExited == true:
                if not noLog: logThis("WARNING", "Attemped to exit a while loop while not currently being in one")
                echo "WARNING: Exited while loop without a while loop would you like to try to automatically fix? (y/n)"
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
