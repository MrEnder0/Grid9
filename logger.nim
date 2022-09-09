import strformat
import times

proc log_this*(mode: string, message: string) : string =
    when defined windows:
        let log_dir = r"C:\ProgramData\Grid9\logs\"
    else:
        let log_dir = "/usr/share/Grid9/logs/"

    let time = now().format("yyyy-MM-dd HH:mm:ss")
    let log_file = open(log_dir & now().format("yyyy-MM-dd") & ".log", fmAppend)
    log_file.writeLine(fmt"{time} - {mode} - {message}")