from code_parser import nil
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

Options:
    version                     Returns language version
    v                           Returns language version
    interpret                   Interpretes the code at the given path
    i                           Interpretes the code at the given path
    glyth_value_get                  Returns the speficied glyth value
    <path>                      Specify path to input files
    <glyth>                     Specify glyth to return value for
"""

proc main() =
    let args = docopt(doc, version = "1.0")

    if args["version"] or args["v"]:
        echo "0.0.2"

    if args["interpret"] or args["i"]:
        echo code_parser.parse($args["<path>"])

    if args["glyth_value_get"]:
        echo glyths.get_glyth($args["<glyth>"])

when isMainModule:
    main()

