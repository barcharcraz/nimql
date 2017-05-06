import sqlite3
import macros
import strutils

#proc ql_row(db: PSqlite3, query: static[string], stm: PStmt) =
  #{.error.}


iterator row*(db: PSqlite3, query: static[string]): auto =
    static:
       const res = gorgeEx("nimql gen \"$1\"".format(query))
       {.hint: query.}
       when res.exitCode != 0:
         {.fatal: $res.exitCode.}
    mixin ql_row
    var stm: PStmt
    discard prepare_v2(db, $query, -1, stm, nil)
    while step(stm) == SQLITE_ROW:
        yield ql_row(db, query, stm)

macro nimqlgen*(): typed =
    result = parseStmt(staticExec("nimql getall"))

proc ql_convert*(typ: typedesc[int64], stm: PStmt, column: int32): int64 = column_int64(stm, column)

when isMainModule:
    import db_sqlite

    nimqlgen()

    var db = open("testdb.sqlite", "", "", "")
    for id, value in db.row("SELECT id, value1 FROM test1"):
        echo id
        echo value
