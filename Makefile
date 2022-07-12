
usage:
	: [usage]
	: make run/c-1so   # Run C program with 1 shared object written in Crystal
	: make run/c-2so   # Run C program with 2 shared objects written in Crystal
	: make run/cr-1so  # Run Crystal program with 1 shared object written in Crystal

lib/lib%.so: mod/%.cr
	@mkdir -p lib
	crystal build --single-module --link-flags="-shared" -o "$@" "$<"

bin/c-1so: main/c-1so.c lib/liblogger1.so
	@mkdir -p bin
	gcc -o "$@" "$<" -Llib -llogger1

bin/c-2so: main/c-2so.c lib/liblogger1.so lib/liblogger2.so
	@mkdir -p bin
	gcc -o "$@" "$<" -Llib -llogger1 -llogger2

bin/cr-1so: main/cr-1so.cr lib/liblogger1.so
	@mkdir -p bin
	crystal build --link-flags="-L$(PWD)/lib" -o "$@" "$<"

run/%: bin/%
	LD_LIBRARY_PATH="lib" ./$<

# for completions
run/c-1so:
run/c-2so:
run/cr-1so:

clean:
	rm -rf lib bin
