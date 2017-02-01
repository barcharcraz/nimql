# Package

version       = "0.1.0"
author        = "Charles Barto"
description   = "Nimql is a library to embed SQL queries directly into a nim program"
license       = "MIT"

srcDir = "src"
bin = @["nimql/sqlite/cmdline.nim"]
# Dependencies

requires "nim >= 0.16.0"

