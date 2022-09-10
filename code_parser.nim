import std/strutils
import std/hashes
import os
import re

proc parse*(path: string) : string =
    let code = open(path)

    when defined windows:
        let parser_cache_dir = r"C:\ProgramData\Grid9\parser_cache\"
    else:
        let parser_cache_dir = "/usr/share/Grid9/parser_cache/"

    let file_hash = hash(path)
    var parsed_code: string
    var line: string

    if os.fileExists(parser_cache_dir & $file_hash & ".g9") and readFile(path) & "\n" ==  readFile(parser_cache_dir & $file_hash & "_pre.g9"):
        echo "Using Cached Code"
        parsed_code = open(parser_cache_dir & $file_hash & ".g9").read_line()
        return parsed_code
    else:
        while code.read_line(line):
            parsed_code = parsed_code & line
        
            #Strips whitespace and all capital letters for comments
            parsed_code = replace(parsed_code, re("[A-Z!?*()\n ]+"), "")

        let parsed_code_file = open(parser_cache_dir & $file_hash & ".g9", fmWrite)
        let unparsed_code_file = open(parser_cache_dir & $file_hash & "_pre.g9", fmWrite)
        parsed_code_file.writeLine(parsed_code)
        unparsed_code_file.writeLine(readFile(path))
        return parsed_code
