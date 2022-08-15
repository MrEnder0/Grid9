from code_interpreter import nil
from code_parser import nil
from glyths import nil
import docopt
import os

const doc = """
CoolSeq - a program to do things

Usage:
    args_docopt about
    args_docopt a
    args_docopt version
    args_docopt v
    args_docopt interpret <path>
    args_docopt i <path>
    args_docopt glyth_value_get <glyth>
"""

proc about() =
    echo "\nGrid9 is a esoteric programming language that is based on a 3x3 grid of memory cells where you make patterns glyths.\nThis language created by MrEnder in the Nim programming language.\n"

proc version() =
    echo "\n0.6.0\n"

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

    if args["interpret"] or args["i"]:
        interpret($args["<path>"])

    if args["glyth_value_get"]:
        glyth_value_get($args["<glyth>"])

when isMainModule:
    var commandLineParams = os.commandLineParams()
    if commandLineParams != @[]:
        interpret(commandLineParams[0])
    else:
        main()

