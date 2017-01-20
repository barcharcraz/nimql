
{.compile: "sqlite3.c" .}
# this is a modified amalgamation, the actual api of sqlite is all private
# but the parser has been exposed

#void *sqlite3ParserAlloc(void*(*)(u64));
#void sqlite3ParserFree(void*, void(*)(void*));
#void sqlite3Parser(void*, int, Token, Parse*);

type Token = object
    z: ptr cchar ## not null terminated
    n: cuint


proc ParserAlloc(malloc: proc (sz: uint64): Pointer {.cdecl.}): Pointer {.importc: "sqlite3ParserAlloc".}
proc ParserFree(parser: Pointer, free: proc(mem: Pointer) {.cdecl.}) {.importc: "sqlite3ParserFree".}
proc Parser(parser: Pointer, tokid: cint, tokenData: Token, pArg: Pointer) {.importc: "sqlite3Parser".}

