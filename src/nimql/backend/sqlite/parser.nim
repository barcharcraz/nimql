import sqlite3
import db_sqlite
import types
import runtime
import os
import logging
import strutils
import sqlite_utils


type ResultInfo* = object
    names*: seq[string]
    types*: seq[string]

type InputInfo* = object
    names*: seq[string]
    types*: seq[string]

type QueryInfo* = object
    results*: ResultInfo
    inputs*: InputInfo

proc initResultInfo*(): ResultInfo =
    result.names = @[]
    result.types = @[]


proc import_schema_sql(db: PSqlite3, sqlfile: string) =
    info "Loading SQL file: $1".format(sqlfile)
    var sql = readFile(sqlfile)
    var errmsg: cstring
    check db, exec(db, sql, nil, nil, errmsg)
    free(errmsg)



proc import_schema_sql*(sqlfile: string): PSqlite3 =
    check(result): open(":memory:", result)
    import_schema_sql(result, sqlfile)


proc import_schema_dir*(dir: string): PSqlite3 =
    check(result): open(":memory:", result)
    info "Loading SQL from directory: $1".format(dir)
    for kind, file in dir.walkDir:
        var (_, _, ext) = splitFile(file)
        if ext != ".sql": continue
        result.import_schema_sql(file)

proc import_schema_db*(db: DbConn, sqlitefile: string) =
    var conn: PSqlite3
    check(conn): open(sqlitefile, conn)
    for row in conn.rows(sql"SELECT sql FROM sqlite_master"):
        db.exec(sql(row[0]))
proc import_schema_db*(sqlitefile: string): PSqlite3 =
    check(result): open(":memory:", result)
    import_schema_db(result, sqlitefile)

proc parse_inputs(stm: PStmt): InputInfo =
    var count = bind_parameter_count(stm)
    result.names = @[]
    # inputs don't really have types (or rather they are determined on the nim side)
    # still we'll keep this field just in case
    result.types = @[]
    for i in 0..<count:
        var name = bind_parameter_name(stm, i)
        result.names.add($name)

proc parse_stmt*(db: PSqlite3, stm: string): ResultInfo =
    var statement: PStmt
    check db, prepare_v2(db, stm, -1, statement, nil)
    result.names = @[]
    result.types = @[]
    var count = column_count(statement)
    for i in 0..<count:
        var name = column_name(statement, i)
        result.names.add($name)
        var typ = column_decltype(statement, i)
        result.types.add(db.nim_type($typ))
    check(db): finalize(statement)
