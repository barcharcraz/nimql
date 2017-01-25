import sqlite3
import db_sqlite
import types
import runtime



type ResultInfo* = object
    names*: seq[string]
    types*: seq[string]




proc import_schema_sql*(sqlfile: string): PSqlite3 =
    check open(":memory:", result)
    var sql = readFile(sqlfile)
    var errmsg: cstring
    check exec(result, sql, nil, nil, errmsg)
    free(errmsg)

proc import_schema_db*(db: DbConn, sqlitefile: string) =
    var conn: PSqlite3
    check open(sqlitefile, conn)
    for row in conn.rows(sql"SELECT sql FROM sqlite_master"):
        db.exec(sql(row[0]))
proc import_schema_db*(sqlitefile: string): PSqlite3 =
    check open(":memory:", result)
    import_schema_db(result, sqlitefile)
proc parse_stmt(db: PSqlite3, stm: string): ResultInfo =
    var statement: PStmt
    check prepare_v2(db, stm, -1, statement, nil)
    var count: int32
    result.names = @[]
    result.types = @[]
    check column_count(statement)
    for i in 0..<count:
        var name = column_name(statement, i)
        result.names.add($name)
        var typ = column_decltype(statement, i)
        result.types.add(db.nim_type($typ))
    check finalize(statement)
    
