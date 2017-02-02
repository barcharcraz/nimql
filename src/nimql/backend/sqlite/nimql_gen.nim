import parser
import sequtils
import strutils
import sqlite3
proc gen_return_type(info: ResultInfo): string =
    var types: seq[string] = @[]
    for name, typ in zip(info.names, info.types).items:
        types &= "$1: $2".format(name, typ)
    return "tuple[$1]".format(types.join(","))


# example of generated code
when false:
    proc ql_row(db: PSqlite3, query: static[string], stm: PStmt): Tuple[field1: string, field2: int64] =
        result[0] = ql_convert("{name of sql type}", stm.column_blob(0), stm.column_bytes(0))
        result[1] = "..."

proc gen_code*(info: ResultInfo, statement: string): string =
    var proc_header = "proc ql_row(db: PSqlite3, query: static[string], stm: PStmt): $1 = \n"
    var proc_overload = """   when query != "$1": {.fatal: "No overload for that query".} """
    var proc_construct_line = "   result[$1] = ql_convert($2, stm, $1)\n"
    var result_lines = @[proc_header.format(gen_return_type(info)), proc_overload.format(statement)]
    for idx, typ in info.types:
        result_lines &= proc_construct_line.format(idx, typ)
    return result_lines.join("\n")

