import ospaths

task backend, "Builds the backend":
    var outfile = "build/nimql".toExe
    exec "nim c --out:" & outfile & " --nimcache:build/nimcache" & " src/nimql.nim"
    setCommand("nop")

task tests, "Builds the tests":
  for f in listFiles("test/"):
    exec "nim c -r --out:" & "build" / f.splitfile.name.toExe & " --path:../src/ " & f
