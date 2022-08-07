from code_parser import nil
from interpreter import nil
from glyths import nil
import docopt

const doc = """
CoolSeq - a program to do things

Usage:
    args_docopt version
    args_docopt v
    args_docopt interpret <path>
    args_docopt i <path>
    args_docopt glyth_value_get <glyth>
"""

proc main() =
    let args = docopt(doc, version = "1.0")

    if args["version"] or args["v"]:
        echo "0.0.3"

    if args["interpret"] or args["i"]:
        var parsed_code = code_parser.parse($args["<path>"])
        interpreter.interpret(parsed_code)

    if args["glyth_value_get"]:
        echo glyths.get_glyth($args["<glyth>"])

when isMainModule:
    main()

