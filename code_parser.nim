import std/strutils
import std/hashes
import os

proc parse*(path: string) : string =
    let code = open(path)

    #Create the file structure for info if it doesn't exist
    if not dirExists(r"C:\ProgramData\Grid9"):
        createDir(r"C:\ProgramData\Grid9")
        if not dirExists(r"C:\ProgramData\Grid9\parser_cache"):
            createDir(r"C:\ProgramData\Grid9\parser_cache")
        if not dirExists(r"C:\ProgramData\Grid9\logs"):
            createDir(r"C:\ProgramData\Grid9\logs")

    let file_hash = hash(path)
    var parsed_code: string
    var line: string

    if os.fileExists(r"C:\ProgramData\Grid9\parser_cache\" & $file_hash & ".g9") and readFile(path) & "\n" ==  readFile(r"C:\ProgramData\Grid9\parser_cache\" & $file_hash & "_pre.g9"):
        echo "Using Cached Code\n"
        parsed_code = open(r"C:\ProgramData\Grid9\parser_cache\" & $file_hash & ".g9").read_line()
        return parsed_code
    else:
        while code.read_line(line):
            parsed_code = parsed_code & line
        
            #Strips whitespace and all capital letters for comments
            parsed_code = parsed_code.replace(" ", "")
            parsed_code = parsed_code.replace("\n", "")
            parsed_code = parsed_code.replace("A", "")
            parsed_code = parsed_code.replace("B", "")
            parsed_code = parsed_code.replace("C", "")
            parsed_code = parsed_code.replace("D", "")
            parsed_code = parsed_code.replace("E", "")
            parsed_code = parsed_code.replace("F", "")
            parsed_code = parsed_code.replace("G", "")
            parsed_code = parsed_code.replace("H", "")
            parsed_code = parsed_code.replace("I", "")
            parsed_code = parsed_code.replace("J", "")
            parsed_code = parsed_code.replace("K", "")
            parsed_code = parsed_code.replace("L", "")
            parsed_code = parsed_code.replace("M", "")
            parsed_code = parsed_code.replace("N", "")
            parsed_code = parsed_code.replace("O", "")
            parsed_code = parsed_code.replace("P", "")
            parsed_code = parsed_code.replace("Q", "")
            parsed_code = parsed_code.replace("R", "")
            parsed_code = parsed_code.replace("S", "")
            parsed_code = parsed_code.replace("T", "")
            parsed_code = parsed_code.replace("U", "")
            parsed_code = parsed_code.replace("V", "")
            parsed_code = parsed_code.replace("W", "")
            parsed_code = parsed_code.replace("X", "")
            parsed_code = parsed_code.replace("Y", "")
            parsed_code = parsed_code.replace("Z", "")
            parsed_code = parsed_code.replace("(", "")
            parsed_code = parsed_code.replace(")", "")
            parsed_code = parsed_code.replace("*", "")
            parsed_code = parsed_code.replace("-", "")

        let parsed_code_file = open(r"C:\ProgramData\Grid9\parser_cache\" & $file_hash & ".g9", fmWrite)
        let unparsed_code_file = open(r"C:\ProgramData\Grid9\parser_cache\" & $file_hash & "_pre.g9", fmWrite)
        parsed_code_file.writeLine(parsed_code)
        unparsed_code_file.writeLine(readFile(path))
        return parsed_code
