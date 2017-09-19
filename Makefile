# Source build variables.
SRCDIR := src
INCDIR := include
LIBDIR := lib
BUILDDIR := build
BINDIR := bin
TESTDIR := test

# Googletest build variables.
GTEST_DIR := vendor/googletest/googletest
GTEST_INC := -I $(GTEST_DIR) -I $(GTEST_DIR)/include
GTEST_ALL_OBJ:= $(BUILDDIR)/gtest-all.o
GTEST_LIB_NAME := gtest
GTEST_BUILD_LIB := $(LIBDIR)/lib$(GTEST_LIB_NAME).a

# Compiler variables.
CC := g++ # This is the main compiler
SRCEXT := cc
# Find all source code cpp files.
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
TESTS := $(shell find $(TESTDIR) -type f -name *.$(SRCEXT))

# Replace src/../filename.cpp with build/../filename.o
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
TEST_OBJECTS := $(patsubst $(TESTDIR)/%,$(BUILDDIR)/%,$(TESTS:.$(SRCEXT)=.o))
TEST_OBJECTS := $(subst $(BUILDDIR)/test_all.o,,${TEST_OBJECTS})

CFLAGS := -g -Wall
LIB := -pthread -L $(LIBDIR)
INC := -I $(INCDIR)

HLINES := "----------------"

# $@ - target
# $^ dependencies
# $< first dependency

# Phony target ensures clean target will always run regardless if there's a
# file named clean in the directory or not.
.PHONY: all clean test

all: $(OBJECTS)
	@echo "\nBuilding all..."
	@echo $(HLINES)

clean:
	@echo "\nCleaning..."
	@echo $(HLINES)
	$(RM) -r $(BUILDDIR) $(TARGET)

# Source objects
$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@echo "\nBuilding individual src object files..."
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) $(INC) -c -o $@ $<

# Tests
test: $(BINDIR)/test_all
	@echo "\nRunning all tests: $<"
	@echo $(HLINES)
	$<

$(BUILDDIR)/%.o: $(TESTDIR)/%.$(SRCEXT) $(GTEST_BUILD_LIB)
	@echo "\nBuilding individual test object files..."
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) $(INC) $(GTEST_INC) -c -o $@ $<

$(GTEST_ALL_OBJ): $(GTEST_DIR)/src/gtest-all.cc
	@echo "\nBuilding googletest object files..."
	@mkdir -p `dirname $@`
	$(CC) $(INC) $(GTEST_INC) -c -o $@ $<

$(GTEST_BUILD_LIB): $(GTEST_ALL_OBJ)
	@echo "\nArchiving googletest object files to lib..."
	ar -rv $@ $^

$(BINDIR)/test_all: $(GTEST_BUILD_LIB) $(OBJECTS) $(TEST_OBJECTS)
	@echo "\nBuilding test_all target..."
	$(CC) $(INC) $(GTEST_INC) $(LIB) -l$(GTEST_LIB_NAME) -o $@ $(TESTDIR)/test_all.$(SRCEXT) $(OBJECTS) $(TEST_OBJECTS)

