from code_interpreter import nil
from yml_manager import nil
from code_parser import nil
from glyths import nil

import docopt, os, re
import std/browsers

when defined windows:
    const
        mainDir = r"C:\ProgramData\Grid9\"
        parserCacheDir = r"C:\ProgramData\Grid9\parser_cache\"
        logDir = r"C:\ProgramData\Grid9\logs\"
        exampleDir = r"C:\ProgramData\Grid9\examples\"
        docsDir = r"C:\ProgramData\Grid9\documentation\"
else:
    const
        mainDir = "/usr/share/Grid9/"
        parser_cacheDir = "/usr/share/Grid9/parser_cache/"
        logDir = "/usr/share/Grid9/logs/"
        exampleDir = "/usr/share/Grid9/examples/"
        docsDir = "/usr/share/Grid9/documentation/"

const doc = """
Usage:
    Grid9 (about | a)
    Grid9 (version | v)
    Grid9 (documentation | d)
    Grid9 (example | e) <name>
    Grid9 (interpret | i) <path> [options]
    Grid9 glyth_value_get <glyth>

Options:
    --advancedParse     Takes longer but can help fix bugs
    --dontCache         Makes parser not cache the parsed code
    --echoGridMod       Makes interpreter echo the grid every time it is modified
    --noLog             Makes interpreter not log errors, warnings, and info
"""

proc about() =
    echo "\nGrid9 is a esoteric programming language that is based on a 3x3 grid of memory cells where you make patterns glyths.\nThis language created by Mr.Ender in the Nim programming language.\n"

proc version() =
    echo "\n2022-016\n"

proc documentation() =
    try:
        browsers.openDefaultBrowser(docsDir & "index.html")
    except:
        echo "Error: Documentation not found, maybe you did not install the optional component."

proc example(name: string) =
    const errorMessage = "\nNo example found for your input try any of the following, 'example1', 'example2', 'example3', 'give_example', 'random_char_example', 'while_nesting', 'if_ladder'.\n"
    when defined windows:
        case $name
        of "example1":
            echo "\n**This example shows how to use basic language features such as the memory grid, queue and printing.**\n"
            try:
                echo readFile(exampleDir & "example1.g9") & "\n"
            except:
                echo "Error: example1.g9 not found, maybe you did not install the optional component."
        of "example2":
            echo "\n**This example shows how to use if statements and while statements.**\n"
            try:
                echo readFile(exampleDir & "example2.g9") & "\n"
            except:
                echo "Error: example2.g9 not found, maybe you did not install the optional component."
        of "example3":
            echo "\n**This example shows how to use the break and goto commands.**\n"
            try:
                echo readFile(exampleDir & "example3.g9") & "\n"
            except:
                echo "Error: example3.g9 not found, maybe you did not install the optional component."
        of "give_example":
            echo "\n**This example shows how to use the give command.**\n"
            try:
                echo readFile(exampleDir & "give_example.g9") & "\n"
            except:
                echo "Error: give_example.g9 not found, maybe you did not install the optional component."
        of "random_char_example":
            echo "\n**This example shows how to use the random argument for cell modification.**\n"
            try:
                echo readFile(exampleDir & "random_char_example.g9") & "\n"
            except:
                echo "Error: random_char_example.g9 not found, maybe you did not install the optional component."
        of "while_nesting":
            echo "\n**This example shows how to use while loops inside of while loops.**\n"
            try:
                echo readFile(exampleDir & "while_nesting.g9") & "\n"
            except:
                echo "Error: while_nesting.g9 not found, maybe you did not install the optional component."
        of "if_ladder":
            echo "\n**This example shows how to use a chain of ladders to climb a if chain.**\n"
            try:
                echo readFile(exampleDir & "if_ladder.g9") & "\n"
            except:
                echo "Error: if_ladder.g9 not found, maybe you did not install the optional component."
        of "inf_skyscraper":
            echo "\n**This example shows how to use the inf command to make a skyscraper.**\n"
            try:
                echo readFile(exampleDir & "inf_skyscraper.g9") & "\n"
            except:
                echo "Error: inf_skyscraper.g9 not found, maybe you did not install the optional component."
        else:
            echo errorMessage
    else:
        case $name
        of "example1":
            echo "\n**This example shows how to use basic language features such as the memory grid, queue and printing.**\n"
            try:
                echo readFile(exampleDir & "example1.g9") & "\n"
            except:
                echo "Error: example1.g9 not found, maybe you did not install the optional component."
        of "example2":
            echo "\n**This example shows how to use if statements and while statements.**\n"
            try:
                echo readFile(exampleDir & "example2.g9") & "\n"
            except:
                echo "Error: example2.g9 not found, maybe you did not install the optional component."
        of "example3":
            echo "\n**This example shows how to use the break and goto commands.**\n"
            try:
                echo readFile(exampleDir & "example3.g9") & "\n"
            except:
                echo "Error: example3.g9 not found, maybe you did not install the optional component."
        of "give_example":
            echo "\n**This example shows how to use the give command.**\n"
            try:
                echo readFile(exampleDir & "give_example.g9") & "\n"
            except:
                echo "Error: give_example.g9 not found, maybe you did not install the optional component."
        of "random_char_example":
            echo "\n**This example shows how to use the random argument for cell modification.**\n"
            try:
                echo readFile(exampleDir & "random_char_example.g9") & "\n"
            except:
                echo "Error: random_char_example.g9 not found, maybe you did not install the optional component."
        of "while_nesting":
            echo "\n**This example shows how to use while loops inside of while loops.**\n"
            try:
                echo readFile(exampleDir & "while_nesting.g9") & "\n"
            except:
                echo "Error: while_nesting.g9 not found, maybe you did not install the optional component."
        of "if_ladder":
            echo "\n**This example shows how to use a chain of ladders to climb a if chain.**\n"
            try:
                echo readFile(exampleDir & "if_ladder.g9") & "\n"
            except:
                echo "Error: if_ladder.g9 not found, maybe you did not install the optional component."
        of "inf_skyscraper":
            echo "\n**This example shows how to use the inf command to make a skyscraper.**\n"
            try:
                echo readFile(exampleDir & "inf_skyscraper.g9") & "\n"
            except:
                echo "Error: inf_skyscraper.g9 not found, maybe you did not install the optional component."
        else:
            echo errorMessage

proc interpret*(path: string, advancedParse: bool, dontCache: bool, echoGridMod: bool, noLog: bool) =

    #Check if file exists and allows for file extension to not be defined
    var path = path
    if os.fileExists(path):discard
    elif os.fileExists(path & ".g9"):path = path & ".g9"
    else:echo "\nError: File not found, maybe check your path.\n"

    #Read yaml file and parse it
    var advancedParse_y = advancedParse
    var dontCache_y = dontCache
    var echoGridMod_y = echoGridMod
    var noLog_y = noLog

    if os.fileExists(replace(path, re".g9", ".yaml")):
        let yml_path = replace(path, re".g9", ".yaml")
        let config_options = yml_manager.get_config(yml_path)
        if config_options[18] == 't':
            advancedParse_y = true
        else:
            advancedParse_y = false
        if config_options[32] == 't':
            dontCache_y = true
        else:
            dontCache_y = false
        if config_options[48] == 't':
            echoGridMod_y = true
        else:
            echoGridMod_y = false
        if config_options[58] == 't':
            noLog_y = true
        else:
            noLog_y = false
        
    elif os.fileExists(replace(path, re".g9", ".yml")):
        let yml_path = replace(path, re".g9", ".yml")
        let config_options = yml_manager.get_config(yml_path)
        if config_options[18] == 't':
            advancedParse_y = true
        else:
            advancedParse_y = false
        if config_options[32] == 't':
            dontCache_y = true
        else:
            dontCache_y = false
        if config_options[48] == 't':
            echoGridMod_y = true
        else:
            echoGridMod_y = false
        if config_options[58] == 't':
            noLog_y = true
        else:
            noLog_y = false

    #Parse and interpret the code
    let parsed_code = code_parser.parse(path, advancedParse_y, dontCache_y , noLog_y)
    code_interpreter.interpret(parsed_code, echoGridMod_y, noLog_y)
    echo "\nCode finished successfully!"

    let exit = readLine(stdin)
    discard exit

proc glyth_value_get(glyth: string) =
    echo glyths.get_glyth(glyth)

proc main() =
    let args = docopt(doc, version = "2022-016")

    if args["about"] or args["a"]:
        about()

    if args["version"] or args["v"]:
        version()

    if args["documentation"] or args["d"]:
        documentation()
    
    if args["example"] or args["e"]:
        example($args["<name>"])

    if args["interpret"] or args["i"]:
        interpret($args["<path>"], args["--advancedParse"], args["--dontCache"], args["--echoGridMod"], args["--noLog"])

    if args["glyth_value_get"]:
        glyth_value_get($args["<glyth>"])

proc non_terminal() =
    echo "No arguments passed\n" & doc

    let exit = readLine(stdin)
    discard exit

when isMainModule:
    
    #Create the file structure for info if it doesn't exist
    if not dirExists(main_dir):
        createDir(main_dir)
        if not dirExists(parser_cache_dir):
            createDir(parser_cache_dir)
        if not dirExists(log_dir):
            createDir(log_dir)
        if not dirExists(example_dir):
            createDir(example_dir)
        if not dirExists(docs_dir):
            createDir(docs_dir)

    if len(os.commandLineParams()) > 0:
        if os.fileExists(os.commandLineParams()[0]) and len(os.commandLineParams()) == 1: interpret(os.commandLineParams()[0], false, false, false, false)
        else: main()
    else: non_terminal()
