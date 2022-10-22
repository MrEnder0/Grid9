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
        #set yamlConfig values to global variables
        for i in 0 ..< yamlConfig.len:
            let advancedParse = yamlConfig[i].advancedParse
            let dontCache = yamlConfig[i].dontCache
            let echoGridMod = yamlConfig[i].echoGridMod
            let noLog = yamlConfig[i].noLog

            var configOptions =  $advancedParse & $dontCache & $echoGridMod & $noLog
            configOptions = configOptions.replace("true", "t")
            configOptions = configOptions.replace("false", "f")
            return configOptions
        echo "Using found Yaml config file"
    except:
        echo "Error withen Yaml config file, using default settings"
        return "ffff"
