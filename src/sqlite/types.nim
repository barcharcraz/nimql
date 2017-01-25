import db_sqlite
import strutils
type TypeMappingNotFoundException = object of Exception

proc nim_type*(metadata_db: DbConn, sql_type: string): string =
    result = metadata_db.getValue(sql""" SELECT lang_type FROM ql_native_types WHERE sql_type=? AND language='nim' """, sql_type)
    if result == "":
        raise newException(TypeMappingNotFoundException, "Could not find type mapping for $1".format(sql_type))
