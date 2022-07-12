# PoC: Writing a C shared library in Crystal

* https://github.com/crystal-lang/crystal/issues/921
* https://news.ycombinator.com/item?id=26551326

## TL;DR

|      |  main  | lib1 | lib2 |
| :--:  | :--:  | :--:  | :--:  |
|  ✅  |  C  | Crystal | N/A |
|  ❌  |  C   | Crystal | Crystal |
|  ❌  |  Crystal | Crystal | N/A |

## Details

### 1. Run C program with 1 shared object written in Crystal.

```console
$ make run/c-1so 
LD_LIBRARY_PATH="lib" ./bin/c-1so
logger1: Hello world!
```

### 2. Run C program with 2 shared objects written in Crystal.

```console
n$ make run/c-2so 
crystal build --single-module --link-flags="-shared" -o "lib/liblogger2.so" "mod/logger2.cr"
gcc -o "bin/c-2so" "main/c-2so.c" -Llib -llogger1 -llogger2
LD_LIBRARY_PATH="lib" ./bin/c-2so
logger1: Hello world!
Invalid memory access (signal 11) at address 0x8
[0x7f1961dfc7b6] ?? +139746992965558 in lib/liblogger1.so
[0x7f1961dfc62a] ?? +139746992965162 in lib/liblogger1.so
[0x7f19619af0c0] ?? +139746988454080 in /lib/x86_64-linux-gnu/libc.so.6
[0x7f1961dfd9d1] ?? +139746992970193 in lib/liblogger1.so
[0x7f1961d6c945] __crystal_once +37 in lib/liblogger1.so
[0x7f1961bf4ffe] ?? +139746990837758 in lib/liblogger2.so
[0x7f1961c0d950] ?? +139746990938448 in lib/liblogger2.so
[0x7f1961c09850] crystal_log2 +32 in lib/liblogger2.so
[0x561318d231d3] main +42 in ./bin/c-2so
[0x7f19619900b3] __libc_start_main +243 in /lib/x86_64-linux-gnu/libc.so.6
[0x561318d230ee] ?? +94640020795630 in ./bin/c-2so
[0x0] ???
make: *** [Makefile:25: run/c-2so] Error 11
```

### 3. Run Crystal program with 1 shared object written in Crystal.

```console
$ make run/cr-1so 
crystal build --link-flags="-L/tmp/test/lib" -o "bin/cr-1so" "main/cr-1so.cr"
LD_LIBRARY_PATH="lib" ./bin/cr-1so
Stack overflow (e.g., infinite or very deep recursion)
Segmentation fault (core dumped)
make: *** [Makefile:25: run/cr-1so] Error 139
```

## Code

The code used in this approach is borrowed from
https://stackoverflow.com/questions/32916684/can-a-crystal-library-be-statically-linked-to-from-c
