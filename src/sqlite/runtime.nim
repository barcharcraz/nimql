##this module is the nim code that's used by both the code generator and
## the generated code
import sqlite3
import macros
type SqliteError* = object of Exception

proc check*(hr: int) =
    if hr != SQLITE_OK:
        raise newException(SqliteError, "Generic Sqlite Error")

macro ql_generate*(database: static[string]): NimNode = 
    parseStmt(gorge("nimql_gen", database))

# this is just to shut the compiler up, we don't care that there's no
# implementers of ql_row yet
template ql_row_hack(db: typed, query: typed, stm: typed): typed =
    ql_row(db, query)        
iterator ql_exec*(db: PSqlite3, query: static[string]): auto {.inline.} = 
    var stm: PStmt
    check prepare_v2(db, query, -1, stm, nil)
    while step(stm) == SQLITE_ROW:
        yield ql_row_hack(db, query, stm)