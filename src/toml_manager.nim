import parsetoml
import std/strutils

proc getConfig*(path: string) : string =
    try:
        let configFile = parsetoml.parseFile(path)
        
        #Define config values
        let advancedParse =
            try:
                configFile["config"]["advancedParse"].getBool()
            except KeyError:
                false
        let dontCache =
            try:
                configFile["config"]["dontCache"].getBool()
            except KeyError:
                false
        let echoGridMod =
            try:
                configFile["config"]["echoGridMod"].getBool()
            except KeyError:
                false
        let noLog =
            try:
                configFile["config"]["noLog"].getBool()
            except KeyError:
                false

        #Parse config values
        var configOptions =  $advancedParse & $dontCache & $echoGridMod & $noLog
        configOptions = configOptions.replace("true", "t")
        configOptions = configOptions.replace("false", "f")

        echo "Using found Toml config file"
        return configOptions
    except:
        echo "Error withen Toml config file, using default settings"
        return "ffff"
