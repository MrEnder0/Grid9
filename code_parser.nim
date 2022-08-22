import std/strutils

proc parse*(path: string) : string =
    echo path
    let code = open(path)
    var parsed_code: string
    var line: string

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

    return parsed_code
