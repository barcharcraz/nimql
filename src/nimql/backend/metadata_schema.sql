CREATE TABLE "ql_native_types" (
  id INTEGER PRIMARY KEY,
  sql_type TEXT,
  language TEXT,
  lang_type TEXT,
  UNIQUE (sql_type, language) ON CONFLICT FAIL
);
CREATE TABLE "ql_queries" (
  "id"  INTEGER NOT NULL,
  "query"  TEXT NOT NULL, code text,
  PRIMARY KEY ("id" ASC),
  CONSTRAINT "ql_query_uniq" UNIQUE ("query" ASC) ON CONFLICT REPLACE
);
CREATE TABLE "ql_query_results" (
  "id"  integer,
  "query"  integer,
  "language"  text,
  "name"  TEXT,
  "column"  integer,
  "type"  text,
  PRIMARY KEY ("id" ASC),
  CONSTRAINT "fkey0" FOREIGN KEY ("query") REFERENCES "ql_queries" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "ql_query_results_uniq" UNIQUE ("query" ASC, "language" ASC, "column" ASC)
);
CREATE TABLE ql_code (
    id integer primary key,
    query integer references ql_queries(id) on delete cascade on update cascade,
    language text,
    code text,
    constraint ql_code_uniq unique(query, language)
);
insert into ql_native_types (sql_type, language, lang_type) values
  ('INTEGER', 'nim', 'int64');
