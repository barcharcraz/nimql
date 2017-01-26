import sqlite3
import strutils
import db_sqlite
when defined(windows):
  when defined(nimOldDlls):
    const Lib = "sqlite3.dll"
  elif defined(cpu64):
    const Lib = "sqlite3_64.dll"
  else:
    const Lib = "sqlite3_32.dll"
elif defined(macosx):
  const
    Lib = "libsqlite3(|.0).dylib"
else:
  const
    Lib = "libsqlite3.so(|.0)"

type SqliteError* = object of Exception
template check*(db: PSqlite3, code: typed) =
  {.line.}:
    var res = code
    if res != SQLITE_OK and res != SQLITE_ROW and res != SQLITE_DONE:
        dbError(db)


    
type Backup = object
type PBackup = ptr Backup


proc sqlite3_backup_init(dest: PSqlite3, destName: cstring, src: PSqlite3, srcName: cstring): PBackup 
  {.importc, dynlib: Lib.}
proc sqlite3_backup_step(p: PBackup, npage: cint): cint {.importc, dynlib: Lib}
proc sqlite3_backup_finish(p: PBackup): cint {.importc, dynlib: Lib.}

proc backup_init*(dest: PSqlite3, destName: cstring, src: PSqlite3, srcName: cstring): PBackup =
  result = sqlite3_backup_init(dest, destName, src, srcName)
  if result == nil: dbError(dest)

proc step*(p: PBackup, npage: cint): cint = sqlite3_backup_step(p, npage)
proc finish*(p: PBackup): cint = sqlite3_backup_finish(p)

proc copy*(src: PSqlite3, dst: PSqlite3, schema: string) =
    var bak = backup_init(dst, schema, src, "main")
    check(dst): bak.step(-1)
    check(dst): bak.finish()