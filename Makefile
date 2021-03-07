NAME = Vector

CC = clang
OPT = -O2
VERSION = -std=c11

FLAGS = -Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic
WARNINGS = -Wno-incompatible-pointer-types
UNUSED_WARNINGS = -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-extra-semi
REMOVE_WARNINGS = -Wno-int-conversion
NIX_LIBS = -shared -fPIC
OSX_LIBS = -c

INPUTFILES = src/$(NAME)/*.c
INPUT = src/$(NAME).c
OUTPUT = $(NAME)

TESTFILES = ../src/$(NAME)/*.c
TESTINPUT = $(NAME).spec.c
TESTOUTPUT = spec_results

all: default

make_export:
	$(RM) -r export && mkdir export

copy_headers:
	mkdir export/$(NAME) && mkdir export/$(NAME)/headers
	cp src/$(NAME)/headers/* export/$(NAME)/headers/
	cp src/$(NAME).h export/

default: make_export
	$(CC) $(OPT) $(VERSION) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) -o $(OUTPUT) $(INPUT) $(INPUTFILES)
	mv $(OUTPUT) export/

lib: $(shell uname)

Darwin: make_export copy_headers
	$(CC) $(OPT) $(VERSION) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(OSX_LIBS) $(INPUTFILES)
	llvm-ar -rcs $(OUTPUT).so *.o
	mv $(OUTPUT).so export/
	$(RM) -r *.o

Linux: make_export copy_headers
	$(CC) $(OPT) $(VERSION) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(NIX_LIBS) -o $(OUTPUT).so $(INPUTFILES)
	mv $(OUTPUT).so export/

test:
	cd spec && $(CC) $(OPT) $(VERSION) $(HEADERS) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) -Wno-implicit-function-declaration $(LIBS) -o $(TESTOUTPUT) $(TESTFILES) $(TESTINPUT)
	@echo
	./spec/$(TESTOUTPUT)

spec: test

clean:
	$(RM) -r spec/$(TESTOUTPUT)
	$(RM) -r export

