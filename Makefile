all:
	./rebar compile
	./rebar doc
	./rebar xref
	./rebar eunit

compile:
	./rebar compile

doc:
	./rebar doc

xref: compile
	./rebar xref

clean:
	./rebar clean

test: xref
	./rebar eunit

AFL_FUZZ ?= afl-fuzz
AFL_CC ?= afl-gcc
AFL_CXX ?= afl-g++
FUZZ_SKELETON ?= fuzz_skeleton

fuzz:
	./rebar clean
	CC=$(AFL_CC) CXX=$(AFL_CXX) ./rebar compile
	$(AFL_FUZZ) $(AFL_FLAGS) -i fuzz/samples -o fuzz/findings -- \
	  $(FUZZ_SKELETON) priv/lz4_nif.so fuzz/compress.term

.PHONY: all compile doc xref clean test fuzz
