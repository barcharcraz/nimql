

let doc = """
Sqlite Generator

Usage:
    nimql gen <query>
    nimql get <query>
    nimql getall
"""
import docopt
import os
import db_sqlite
import nimql_gen
import parser
import sequtils
import logging
import parsecfg
import sqlite_utils
proc find_metadata_dir(): string =
    for dir in getCurrentDir().parentDirs:
        if existsDir(dir / ".nimql"):
             return dir / ".nimql"



proc do_cmdline*() =
    let args = docopt(doc, version = "Sqlite Generator 0.1.0")

    let db = db_sqlite.open(find_metadata_dir() / "metadata.db", "", "", "")
    let config = loadConfig(find_metadata_dir() / "config.cfg")
    db.exec(sql"PRAGMA foreign_keys = ON")
    var logger = newConsoleLogger()
    add_handler(logger)
    if args["gen"]:
        db.exec(sql"ATTACH DATABASE ':memory:' as ddl_info")
        var ddl_db = import_schema_dir(find_metadata_dir() /../ config.getSectionValue("sqlite", "schema_dir"))
        ddl_db.copy(db, "ddl_info")
        var res = db.parse_stmt($args["<query>"])
        var id = db.insertId(sql"INSERT INTO ql_queries (query) VALUES (?)", $args["<query>"])
        assert(len(res.names) == len(res.types))
        for i in 0..<res.names.len:
            db.exec(sql"INSERT INTO ql_query_results (query, language, name, column, type) VALUES (?, ?, ?, ?, ?)",
                    id, "nim", res.names[i], i, res.types[i])
        db.exec(sql"INSERT INTO ql_code (query, language, code) VALUES (?, 'nim', ?)", id, gen_code(res, $args["<query>"]))
    if args["get"]:
        echo db.getValue(sql"SELECT code FROM ql_code c JOIN ql_queries q ON c.query = q.id WHERE q.query=? AND c.language='nim'", $args["<query>"])
    if args["getall"]:
        for row in db.rows(sql"SELECT code from ql_code where language='nim'"):
            echo row[0]