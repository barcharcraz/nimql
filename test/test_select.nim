import unittest
import db_sqlite
import sequtils
import sqlite3
import macros
import nimql.frontend.sqlite

nimqlgen()

suite "select tests":

  setup:
    var db = open("testdb.sqlite", "", "", "")
    var err: cstring
    discard sqlite3.exec(db, """
      CREATE TABLE test1 ( id integer primary key , value1 integer not null default 0);
      insert into test1 (value1) VALUES (10), (20), (50);
    """, nil, nil, err)

  test "test basic select":
    var res = toSeq(db.row("SELECT id, value1 FROM test1"))
    for res in db.row("SELECT id, value1 FROM test1"):
      echo $res.id
    echo repr(res)
    #check(res is seq[tuple[a: int64, b: int64]])
