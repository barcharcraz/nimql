import sqlite3
import macros
import strutils
iterator row(db: PSqlite3, query: static[string]): auto =
    static: discard staticExec("cmdline gen \"$1\"".format(query))
    mixin ql_row
    var stm: PStmt
    discard prepare_v2(db, $query, -1, stm, nil)
    while step(stm) == SQLITE_ROW:
        yield ql_row(db, query, stm)

macro nimqlgen(): typed =
    result = parseStmt(staticExec("cmdline getall"))


when isMainModule:
    import db_sqlite
    proc ql_convert(typ: typedesc[int64], stm: PStmt, column: int32): int64 = column_int64(stm, column)
    nimqlgen()
    
    var db = open("testdb.sqlite", "", "", "")
    for id, value in db.row("SELECT id, value1 FROM test1"):
        echo id
        echo value
    
