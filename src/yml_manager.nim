import yaml/serialization, streams
import std/strutils

proc getConfig*(path: string) : string =
    type yamlObject = object
        advancedParse: bool
        dontCache: bool
        echoGridMod: bool
        noLog: bool

    var yamlConfig {.global.} : seq[yamlObject]

    try:
        let yamlFile = newFileStream(path)
        load(yamlFile, yamlConfig)
        yamlFile.close()
        echo "Using found Yaml config file"
    except:
        echo "Error withen Yaml config file, using default settings"
        return "@[(advancedParse: false, dontCache: false, echoGridMod: false)]"

    var yamlData = $yaml_config
    yamlData = yamlData.replace("true", "t")
    yamlData = yamlData.replace("false", "f")
    return yamlData
