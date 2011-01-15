/*  【前缀命名约定】
fn  表示一个流程，某项操作不应加该前缀
fl  0/1
sw  ON/OFF
dir 路径，不含引号，若是文件夹结尾应有“\”
ini <section> <item> 应符合Unix命名规范
*/
shellvar {
  return %shell:: [ $+ [ $1- ] ]
}
excmd {
  shell::OutDebugInfo {excmd} cmd= $1 , pram= $2-
  $1 $2-
} 

shell::fnUnLoad {
  var %ans = $?!="确定卸载当前的Shell吗？"
  if ( %ans ) {
    load -rs $+(",%shell::dirShellPath,ShellSetup.ini,")
    load -a $+(",%shell::dirShellPath,ShellSetup.ini,")
    signal shell_unload
  }
  else {
    return
  }
}

shell::ClearAllVar {
  unset %shell::*
}




;--------------------------------------------------------------
;  用户可见


;--------------------------------------------------------------
;  Shell Lib

shell::iniSetConfig {
  writeini $shell::GetPath(config.ini) $1 $2 $3-
}
shell::iniGetConfig {
  return $readini($shell::GetPath(config.ini),np,$1,$2)
}


shell::GetPath {
  if ( $1- ) {
    if ( $1- == config.ini ) return %shell::dirShellPath $+ config.ini
  
  }
  else {
    return %shell::dirShellPath
  }
}

shell::GetServerName {
  var %str = $server
  var %num = $numtok(%str,$asc(.))
  if ( %num == 3 ) {
    return $gettok(%str,2,$asc(.))
  }
  elseif ( %num == 4 ) {
    ; ip
    return %str
  }
  elseif ( %num == 2 ) {
    return $gettok(%str,1,$asc(.))
  }
  else {
    ; 未知
    return $network
  }
}

shell::OutWarning {
  Secho 5[Warning] $1-
}
shell::OutTip {
  Secho $1-
}
shell::OutInfo {
  Secho $1-
}
shell::OutError {
  Secho 4[Error] $1-
}
shell::OutDebugInfo {
  if ( %shell::DebugMode == ON ) {
    Secho $1-
  }
  else return
}

;--------------------------------------------------------------
;  Lib
lib::str2dir {
  var %dir = $strip($1-)
  %dir = $remove(%dir,")
  %dir = $remove(%dir,')
  return %dir
}

lib::strRemoveQuotes {
  return $remove($1-,")
}
