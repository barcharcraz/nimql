task backend, "Builds the backend":
    var outfile = "build/cmdline".toExe
    exec "nim c --out:" & outfile & " --nimcache:build/nimcache" & " src/nimql/backend/sqlite/cmdline.nim"
    setCommand("nop")