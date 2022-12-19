from toml_manager import nil
from glyphs import nil

import docopt, os, re
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
    Grid9Converter (convert | c) <path> <conversion>
"""

const converterversion = "2022-023"

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
    echo "\n", converterversion, "\n"

proc clean() =
    os.removeDir(tempDir)
    os.createDir(tempDir)
    logThis("INFO", "Cleaned temp dir")

proc convert(path: string, conversion: string) =
    var path = path
    if os.fileExists(path):
        discard
    elif os.fileExists(path & ".g9"):
        path = path & ".g9"
    else:
        let errorMessage = "File not found at '" & path & "' maybe check your path.\n"
        logThis("ERROR", errorMessage)
        discard errorMessage
        return

    case conversion
    of "textToGrid9":
        logThis("INFO", "Converting text to Grid9")
        logThis("INFO", "Reading config file")

        var minGrid9Ver = "2022.001"
        if os.fileExists(replace(path, re".g9", ".toml")):
            let
                tomlPath = replace(path, re".g9", ".toml")
                config = toml_manager.getConfig(tomlPath)
            minGrid9Ver = config[7]
            if minGrid9Ver > "2022-013":
                logThis("WARNING", "This conversion method is not supported for Grid9 versions below 2022-013, the output may not work as expected, continue? (y/n)")
                let answer = readLine(stdin)
                if answer != "y":
                    discard answer
                    return
                discard answer

        let inputFile = open(path, fmRead)
        var inputData = inputFile.readAll()
        inputFile.close()
        var outputData = ""

        for currentChar in inputData:
            #find current character in glyph table
            var charFound = false
            var currentCharNum = 0
            while currentCharNum < 255:
                let currentCharBin = toBin(currentCharNum, 9)
                if $currentChar == $glyphs.get_glyph($currentCharBin):
                    echo "found " & $glyphs.get_glyph($currentCharBin)
                    charFound = true
                    
                    #convert the bin to grid9
                    var cellNum = 0
                    while cellNum < 9:
                        var letter = currentCharBin[cellNum]
                        if $letter == "0":
                            outputData &= "s" & $cellNum & "0"
                        elif $letter == "1":
                            outputData &= "s" & $cellNum & "1"
                        discard letter
                        cellNum += 1
                    outputData &= "qs"

                    break
                currentCharNum += 1
            if charFound == false:
                let errorMessage = "The character '" & currentChar & "' was not found in the glyphs table.\n"
                logThis("ERROR", errorMessage)
                discard errorMessage
        
        logThis("INFO", "Conversion completed...\n\n" & outputData & "p")
        let exit = readLine(stdin)
        discard exit

    of "grid9ToRetroGadget":
        logThis("INFO", "Converting Grid9 to RetroGadget Grid9")
        logThis("INFO", "Reading config file")
        
        var minGrid9Ver = "2022.001"
        if os.fileExists(replace(path, re".g9", ".toml")):
            let
                tomlPath = replace(path, re".g9", ".toml")
                config = toml_manager.getConfig(tomlPath)
            minGrid9Ver = config[7]
            if minGrid9Ver > "2022.013":
                logThis("WARNING", "This conversion method is not supported for Grid9 versions below 2022.020, the output may not work as expected, continue? (y/n)")
                let answer = readLine(stdin)
                if answer != "y":
                    discard answer
                    return
                discard answer

        let inputFile = open(path, fmRead)
        var inputData = inputFile.readAll()
        inputFile.close()

        inputData = replace(inputData, re("[A-Z*()\t ]+"), "")
        inputData = replace(inputData, "f0", "f1")
        inputData = replace(inputData, "f1", "f2")
        inputData = replace(inputData, "f2", "f3")
        inputData = replace(inputData, "f3", "f4")
        inputData = replace(inputData, "f4", "f5")
        inputData = replace(inputData, "f5", "f6")
        inputData = replace(inputData, "f6", "f7")
        inputData = replace(inputData, "f7", "f8")
        inputData = replace(inputData, "f8", "f9")

        logThis("INFO", "Conversion completed...\n\n" & inputData)
        let exit = readLine(stdin)
        discard exit
        
    else:
        logThis("ERROR", "Conversion not found; try any of the following: 'textToGrid9', 'grid9ToRetroGadget'")
    clean()

proc main() =
    let args = docopt(doc, version = converterversion)

    if args["about"] or args["a"]:
        about()

    if args["version"] or args["v"]:
        version()

    if args["convert"] or args["c"]:
        convert($args["<path>"], $args["<conversion>"])

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
        if os.fileExists(os.commandLineParams()[0]) and len(os.commandLineParams()) == 1: convert(os.commandLineParams()[0], os.commandLineParams()[1])
        else: main()
    else: nonTerminal()
