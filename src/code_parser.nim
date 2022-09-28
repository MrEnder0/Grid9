import std/hashes, strformat, times, os, re

proc log_this(mode: string, message: string) : string {.discardable.} =
    when defined windows:
        let log_dir = r"C:\ProgramData\Grid9\logs\"
    else:
        let log_dir = "/usr/share/Grid9/logs/"

    let time = now().format("yyyy-MM-dd HH:mm:ss")
    let log_file = open(log_dir & now().format("yyyy-MM-dd") & ".log", fmAppend)
    log_file.writeLine(fmt"{time} - {mode} - {message}")

    log_file.close()

proc parse*(path: string, advancedParse: bool, dontCache: bool) : string =
    let code = open(path)

    when defined windows:
        let parser_cache_dir = r"C:\ProgramData\Grid9\parser_cache\"
    else:
        let parser_cache_dir = "/usr/share/Grid9/parser_cache/"

    let file_hash = hash(path)
    var parsed_code: string
    var line: string

    if advancedParse != true and dontCache != true and os.fileExists(parser_cache_dir & $file_hash & ".g9") and readFile(path) & "\n" == readFile(parser_cache_dir & $file_hash & "_pre.g9"):
        echo "Using Cached Code\n"
        parsed_code = open(parser_cache_dir & $file_hash & ".g9").read_line()
        return parsed_code
    else:
        while code.read_line(line):
            parsed_code = parsed_code & line
        
            #Strips whitespace and all capital letters for comments
            parsed_code = replace(parsed_code, re("[A-Z!?*()\n\t ]+"), "")  

        if advancedParse == true:
            echo "Doing advanced parse\n"
            var c_index = 0
            var ifDepth = 0
            var whileDepth = 0
            var is_exited = false
            while c_index < len(parsed_code):
                case $parsed_code[c_index]
                of $'q':
                    if parsed_code[c_index + 1] == 's':
                        discard
                    elif parsed_code[c_index + 1] == 'c':
                        discard
                    else:
                        log_this("ERROR", "Invalid operation for queue command.")
                        echo "ERROR: Invalid operation for queue command."
                of $'i':ifDepth+=1
                of $'w':whileDepth+=1
                of $'}':ifDepth-=1
                of $']':
                    whileDepth-=1
                    if is_exited == true:
                        is_exited = false
                of $'b':
                    if not match($parsed_code[c_index + 1], re"0-9",):
                        log_this("ERROR", "Invalid number")
                        echo "ERROR: Invalid number"
                of $'x':
                    is_exited = true
                
                if ifDepth < 0:
                    log_this("ERROR", "If depth is less than 0")
                    echo "ERROR: If depth is less than 0"
                if whileDepth < 0:
                    log_this("ERROR", "While depth is less than 0")
                    echo "ERROR: While depth is less than 0"

                c_index += 1

            if ifDepth > 0:
                log_this("WARNING", "If depth is greater than 0.")
                echo "WARNING: If depth is greater than 0 would you like to try to automatically fix? (y/n)"
                let responce = readLine(stdin)
                if $responce == $'y':
                    var fixTimes = 0
                    while fixTimes < ifDepth:
                        parsed_code = parsed_code & $'}'
                        fixTimes += 1
                    discard fixTimes
                discard responce
            if whileDepth > 0:
                log_this("WARNING", "While depth is greater than 0.")
                echo "WARNING: While depth is greater than 0 would you like to try to automatically fix? (y/n)"
                let responce = readLine(stdin)
                if $responce == $'y':
                    var fixTimes = 0
                    while fixTimes < whileDepth:
                        parsed_code = parsed_code & $']'
                        fixTimes += 1
                    discard fixTimes
                discard responce
            if is_exited == true:
                log_this("WARNING", "Attemped to exit a while loop while not currently being in one.")
                echo "WARNING: Exited while loop without a while loop would you like to try to automatically fix? (y/n)"
                let responce = readLine(stdin)
                if $responce == $'y':
                    parsed_code = parsed_code & $']'
                discard responce

        code.close()
        
        let parsed_code_file = open(parser_cache_dir & $file_hash & ".g9", fmWrite)
        let unparsed_code_file = open(parser_cache_dir & $file_hash & "_pre.g9", fmWrite)
        parsed_code_file.writeLine(parsed_code)
        unparsed_code_file.writeLine(readFile(path))
        return parsed_code
