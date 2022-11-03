import std/strutils
import parsetoml

proc getConfig*(path: string) : seq[string] =
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
        let verbosity =
            try:
                $configFile["config"]["verbosity"]
            except KeyError:
                "1"

        #Define metadata values
        let author =
            try:
                $configFile["metadata"]["author"]
            except KeyError:
                "unknown"
        let description =
            try:
                $configFile["metadata"]["description"]
            except KeyError:
                "unknown"
        
        let version =
            try:
                $configFile["metadata"]["version"]
            except KeyError:
                "1.0.0"
        
        let showmetadata =
            try:
                configFile["metadata"]["showmetadata"].getBool()
            except KeyError:
                false

        #Parse config values
        var configOptions =  $advancedParse & $dontCache & $echoGridMod & $noLog
        configOptions = configOptions.replace("true", "t")
        configOptions = configOptions.replace("false", "f")

        if parseInt(verbosity) >= 1:
            echo "Using found Toml config file"
        return @[configOptions, author, description, version, $showmetadata, $verbosity]
    except:
        echo "Error withen Toml config file, using default settings"
        return @["ffff", "unknown", "unknown", "1.0.0", "false", "1"]
