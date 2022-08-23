import std/strutils
import std/hashes
import os

proc parse*(path: string) : string =
    let code = open(path)

    let file_hash = hash(code)
    let file_path: string = r"C:\ProgramData\C" & $file_hash & ".g9"
    var parsed_code: string
    var line: string

    if os.fileExists($file_path):
        echo "Using Cached File\n"
        parsed_code = open(file_path).read_line()
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

        let parsed_code_file = open(file_path, fmWrite)
        parsed_code_file.writeLine(parsed_code)
        return parsed_code
