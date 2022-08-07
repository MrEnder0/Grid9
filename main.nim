from code_parser import nil
import docopt

const doc = """
CoolSeq - a program to do things

Usage:
    args_docopt version
    args_docopt v
    args_docopt interpret <path>
    args_docopt i <path>

Options:
    version                     Returns language version
    v                           Returns language version
    interpret                   Interpretes the code at the given path
    i                           Interpretes the code at the given path
    <path>                      Specify path to input files
"""

proc main() =
    let args = docopt(doc, version = "1.0")

    if args["version"] or args["v"]:
        echo "0.0.2"

    if args["interpret"] or args["i"]:
        echo code_parser.parse($args["<path>"])

when isMainModule:
    main()

