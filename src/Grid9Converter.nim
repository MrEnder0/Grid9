import docopt, os
import std/strutils
import std/terminal

when defined windows:
    const
        subMainDir = r"C:\ProgramData\Grid9\"
        mainDir = r"C:\ProgramData\Grid9\grid9converter\"
        tempDir = r"C:\ProgramData\Grid9\grid9converter\temp\"
else:
    const
        subMainDir = "/usr/share/Grid9/"
        mainDir = "/usr/share/Grid9/grid9converter/"
        tempDir = "/usr/share/Grid9/grid9converter/temp/"

const doc = """
Usage:
    Grid9Converter (about | a)
    Grid9Converter (version | v)
    Grid9Converter (convert | c) <path> <output> <conversion>
"""

proc logThis(mode: string, message: string) : string {.discardable.} =
    case mode
    of "INFO":
        stdout.styledWriteLine(fgCyan, mode, fgWhite, " ", message)
    of "WARNING":
        stdout.styledWriteLine(fgYellow, mode, fgWhite, " ", message)
    of "ERROR":
        stdout.styledWriteLine(fgRed, mode, fgWhite, " ", message)

proc about() =
    echo "\nGrid9Converter is tool for the Grid9 programming language that is used to convert your Grid9 projects to other things.\n"

proc version() =
    echo "\n2022-000\n"

proc clean() =
    os.removeDir(tempDir)
    os.createDir(tempDir)
    logThis("INFO", "Cleaned temp dir")

proc convert(path: string, output: string, conversion: string) =
    echo "You want to convert " & path & " to " & output & " using " & conversion & "\n"
    clean()

proc main() =
    let args = docopt(doc, version = "2022-023")

    if args["about"] or args["a"]:
        about()

    if args["version"] or args["v"]:
        version()

    if args["convert"] or args["c"]:
        convert($args["<path>"], $args["<output>"], $args["<conversion>"])

proc nonTerminal() =
    #Runs if no arguments are given
    echo "No arguments passed\n" & doc
    let exit = readLine(stdin)
    discard exit

when isMainModule:
    #Creates folders if they don't exist
    if not dirExists(subMainDir):
        createDir(subMainDir)
    if not dirExists(mainDir):
        createDir(mainDir)
    if not dirExists(tempDir):
        createDir(tempDir)

    #Checks if there are any arguments
    if len(os.commandLineParams()) > 0:
        if os.fileExists(os.commandLineParams()[0]) and len(os.commandLineParams()) == 1: convert(os.commandLineParams()[0], os.commandLineParams()[1], os.commandLineParams()[2])
        else: main()
    else: nonTerminal()