import yaml/serialization, streams

proc get_config*(path: string) : string =
    type yaml_object = object
        advancedParse: bool
        dontCache: bool
        echoGridMod: bool

    var yaml_config {.global.} : seq[yaml_object]

    try:
        var yaml_file = newFileStream(path)
        load(yaml_file, yaml_config)
        yaml_file.close()
        echo "Using found Yaml config file"
    except:
        echo "Error withen Yaml config file, using default settings"
        return "@[(advancedParse: false, dontCache: false, echoGridMod: false)]"

    return $yaml_config
