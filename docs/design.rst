=====
Nimql Design
=====

Goals
--------

- queries should be written in sql. Full SQL.
- All features of a supported database's SQL dialect should be available
- SQL types should map to one, and only one, native type.
- Users should be able to add types per column. So a column may be
  of type BLOB but there's metadata for that specific column to tell
  the library what type the user wishes to convert it to
- queries embedded in the program should be executed verbatim
- only queries specified by the user should be executed
- copies should be minimized

Non Goals
---------

- Not an ORM solution, we're mapping tuples to objects not objects to tuples
- No concept of a "persistant object" but perhaps facilities to splat objects
  into a query

Getting Results
---------------
executing a nimql query should simply return a named tuple with the same names and types
as the result of the query.

Binding Data
------------
Getting data into a query (a parameterized query) will have multiple options.
There will be a relitively standard way of simply binding parameters by index or name.
Additionally the user will be able to interpolate strings into the query, however
these interpolations will be translated to parameterized queries, eliminating any
chance of sql injection.


Example code
-----------
.. code-block:: nim
import nimql

var res = nql"""select id, name, job from people"""
echo "got a row for " & $res[0].name

..

.. code-block:: nim
(name, job) = nql"""select name, job from people """
..

.. code-block:: nim
nql"""insert into people (name, job) values (${"peter"}, ${Programmer})"""
..