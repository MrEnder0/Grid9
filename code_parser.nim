import std/strutils

proc parse*(path: string) : string =
    let code = open(path)
    var parsed_code: string
    var line: string

    while code.read_line(line):
        parsed_code = parsed_code & line
        parsed_code = parsed_code.replace(" ", "")
        parsed_code = parsed_code.replace("\n", "")

    return parsed_code
