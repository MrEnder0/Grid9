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
            #Removes back 0 (b0) because it does nothing
            parsedCode = replace(parsedCode, re("b0"), "")
            #Replaces f0-f8 in any order with flip all
            parsedCode = replace(parsedCode, re("(?:f(?!.*\1)[0-8]0){9}"), "fa")
            #Replaces s00-s80 in any order with all 0
            parsedCode = replace(parsedCode, re("(?:s(?!.*\1)[0-8]0){9}$"), "a0")
            #Replaces s01-s81 in any order with all 1
            parsedCode = replace(parsedCode, re("(?:s(?!.*\1)[0-8]1){9}$"), "a1")
            #Replaces f0-f8 in any order with flip all
            parsedCode = replace(parsedCode, re("(?:[f](?!.*\1)[0-8][f]){9}"), "fa")
            #Removes repeating flips of the same number that are together
            parsedCode = replace(parsedCode, re("/f([0-8])f\1/"), "")
            #Removes empty if statements
            parsedCode = replace(parsedCode, re("/i[0-8]([=!])[01]}$/"), "")
            #Removes empty while statements
            parsedCode = replace(parsedCode, re("/w[0-8]([=!])[01]]$/"), "")

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
                if not len(parsedCode) > cIndex+1:
                    if not noLog: logThis("ERROR", "No provided value for back command", verbosity)
            of $'d':
                if not len(parsedCode) > cIndex+1:
                    if not noLog: logThis("ERROR", "No provided value for delay command", verbosity)
            of $'x':
                try:
                    if $parsedCode[cIndex - 1] != $'g':
                        isExited = true
                    else:
                        if $parsedCode[cIndex - 2] == $'g':
                            isExited = true
                except:
                    isExited = true
            of $'t':
                if ifDepth == 0 and whileDepth == 0:
                    parsedCode = parsedCode[0..cIndex]
            
            if ifDepth < 0:
                if not noLog: logThis("WARNING", "If depth is less than 0", verbosity)
                if parsedCode[-1] == '}':
                    if not noLog: logThis("WARNING", "Possible fix would be removing the } at the end of your code, would you like to automatically fix (y,n)", verbosity)
                    let responce = readLine(stdin)
                    if $responce == $'y':
                        parsedCode = parsedCode[0..cIndex]
                    discard responce
            if whileDepth < 0:
                if not noLog: logThis("WARNING", "While depth is less than 0", verbosity)
                if parsedCode[-1] == ']':
                    if not noLog: logThis("WARNING", "Possible fix would be removing the ] at the end of your code, would you like to automatically fix (y,n)", verbosity)
                    let responce = readLine(stdin)
                    if $responce == $'y':
                        parsedCode = parsedCode[0..cIndex]
                    discard responce
            cIndex += 1

        if ifDepth > 0:
            if not noLog: logThis("WARNING", "If depth is greater than 0 would you like to automatically fix (y,n)", verbosity)
            if ifDepth > 1:
                if not noLog: logThis("WARNING", "If depth is greater than 1 which decreases the likelyhood this fix would help, it is recomended to manually fix.", verbosity)
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
            if whileDepth > 1:
                if not noLog: logThis("WARNING", "While depth is greater than 1 which decreases the likelyhood this fix would help, it is recomended to manually fix.", verbosity)
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
