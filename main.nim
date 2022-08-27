from code_interpreter import nil
from code_parser import nil
from glyths import nil
import docopt
import os

const doc = """
Grid9 CLI
Usage:
    args_docopt about
    args_docopt a
    args_docopt version
    args_docopt v
    args_docopt help <command>
    args_docopt h <command>
    args_docopt clean <folder>
    args_docopt c <folder>
    args_docopt interpret <path>
    args_docopt i <path>
    args_docopt glyth_value_get <glyth>
"""

proc about() =
    echo "\nGrid9 is a esoteric programming language that is based on a 3x3 grid of memory cells where you make patterns glyths.\nThis language created by MrEnder in the Nim programming language.\n"

proc version() =
    echo "\n2022-007\n"

proc help(command: string) =
    case $command
    of $'f':
        echo "\nThe 'f' command is used to flip a value  on the memory grid and is used as 'f0' the 0 can be any number from 0-8 for the cell id on the grid to be fliped.\n"
    of $'s':
        echo "\nThe 's' command is used to set a value on the memory grid and is used as 's00' the first 0 can be any number from 0-8 for the cell id on the grid to be set and the second 0 is the 0 or 1 the cell gets set to.\n"
    of $'a':
        echo "\nThe 'a' command is used to set all the values on the memory grid and is used as 'a0' the 0 can be a 0 or a 1 and all the memory grid cells will be set to it.\n"
    of $'q':
        echo "\nThe 'q' command is used to store the current glyth (memory grid) as a character added to the end of the queue. The queue will be printed out and cleared when the 'p' command is used. If the letter 'c' is following a queue command it will only clear the queue with no output.\n"
    of $'p':
        echo "\nThe 'p' command is used to print the queue if it contains any data or the current glyth if the queue is empty.\n"
    of $'i':
        echo "\nThe 'i' command is used as a if statement like 'i0=0' the first 0 is the memory cell id (0-8) the equal sign can also be a ! if you want to use a not equal and the second 0 is the value you are checking the memory grid cell for. Also the if statement is closed by a ].\n"
    of $'w':
        echo "\nThe 'w' command is used as a while statement like 'w0=0' it uses the same logic as a if statement so do 'help i' for info on that but this time it will read code until a } and loop back the begining of the while statement if it is still true.\n"
    of $'x':
        echo "\nThe 'x' command is used as a break or exit statment where it will skip code until it finds a ] (a end of a while ).\n"
    of $'b':
        echo "\nThe 'b' command is used like this 'b0' the 0 can be a 0-9 and will go back that many characters (automatically skips whitespace and upercase characters) and is a basic implimentation of a goto statement.\n"
    of $'t':
        echo "\nThe 't' command is used to terminate the current script and not interpret any code past this point unless it gets ignored by a non true if statment or by a break command in a while if its before it.\n"
    of "example1":
        echo "\n**This example shows how to use basic language features such as the memory grid, queue and  printing.**\n"
        echo readFile("examples/example1.g9")
    of "example2":
        echo "\n**This example shows how to use if statements and while statements.**\n"
        echo readFile("examples/example2.g9")
    of "example3":
        echo "\n**This example shows how to use the break and goto commands.**\n"
        echo readFile("examples/example3.g9")
    else:
        echo "\nNo help found your input try any of the following 'f', 's', 'a', 'q', 'p', 'i', 'w', 'x', 'b', 't' or 'example1', 'example2', 'example3'.\n"
        
proc clean(folder: string) =
    case $folder
    of "parser_cache":
        if os.dirExists(r"C:\ProgramData\Grid9\parser_cache"):
            echo "\nCleaning parser cache folder\n"
            os.removeDir(r"C:\ProgramData\Grid9\parser_cache")
            os.createDir(r"C:\ProgramData\Grid9\parser_cache")
    of "logs":
        if os.dirExists(r"C:\ProgramData\Grid9\logs"):
            echo "\nCleaning logs folder\n"
            os.removeDir(r"C:\ProgramData\Grid9\logs")
            os.createDir(r"C:\ProgramData\Grid9\logs")
    else:
        echo "\nFolder not found try 'parser_cache' or 'logs'.\n"

proc interpret*(path: string) =
    var parsed_code = code_parser.parse(path)
    code_interpreter.interpret(parsed_code)
    echo "\nCode finished successfully!"

    while 1 == 1:
        discard

proc glyth_value_get(glyth: string) =
    echo glyths.get_glyth(glyth)

proc main() =
    let args = docopt(doc, version = "1.0")

    if args["about"] or args["a"]:
        about()

    if args["version"] or args["v"]:
        version()
    
    if args["help"] or args["h"]:
        help($args["<command>"])

    if args["clean"] or args["c"]:
        clean($args["<folder>"])

    if args["interpret"] or args["i"]:
        interpret($args["<path>"])

    if args["glyth_value_get"]:
        glyth_value_get($args["<glyth>"])

when isMainModule:
    var commandLineParams = os.commandLineParams()
    try:
        if os.fileExists(commandLineParams[0]): interpret(commandLineParams[0])
        else: main()
    except:
        echo doc
        while 1 == 1:
            discard
