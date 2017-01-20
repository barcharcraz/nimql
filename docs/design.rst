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