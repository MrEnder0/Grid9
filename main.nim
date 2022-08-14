from code_interpreter import nil
from code_parser import nil
from glyths import nil
import docopt

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

proc main() =
    let args = docopt(doc, version = "1.0")

    if args["about"] or args["a"]:
        echo "\nGrid9 is a esoteric programming language that is based on a 3x3 grid of memory cells where you make patterns glyths.\nThis language created by MrEnder in the Nim programming language.\n"

    if args["version"] or args["v"]:
        echo "\n0.4.3\n"

    if args["interpret"] or args["i"]:
        echo "\n"
        var parsed_code = code_parser.parse($args["<path>"])
        code_interpreter.interpret(parsed_code)
        echo "\nCode finished successfully!\n"

    if args["glyth_value_get"]:
        echo glyths.get_glyth($args["<glyth>"])

when isMainModule:
    main()

