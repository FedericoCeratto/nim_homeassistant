
import parsecfg
from os import getAppDir
from strutils import replace

proc loadConf*(modulename: string): Config =
  ## Load config for the main daemon or a module
  var fn = ""
  when defined(dev):
    if modulename == "":
      # main daemon
      fn = getAppDir() & "/config/secret.cfg"
    else:
      fn = replace(getAppDir(), "/nimhapkg/mainmodules", "") & "/config/secret.cfg"
  else:
    fn = "/etc/nimha/nimha.cfg"

  echo("Reading cfg file " & fn)
  loadConfig(fn)

