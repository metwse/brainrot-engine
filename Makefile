PROJECT_NAME = brainrot-engine

CXX = g++
DEBUGGER = gdb
MEMCHECK = valgrind --fair-sched=try --leak-check=full

CXX_FLAGS=-O2 -Wall -Werror -std=c++17 -Iinclude -Iexternal/include
TXX_FLAGS=-O0 -g3 -Wall -std=c++17 -D_DEBUG -Iinclude -Iexternal/include

SRC_DIR = src
INCLUDE_DIR = include

BUILD_DIR = target
OBJ_DIR = $(BUILD_DIR)/obj

# Utility functions
filter-out = $(foreach v,$2,$(if $(findstring $1,$v),,$v))
rwildcard = $(wildcard $1$2) \
	$(foreach d, \
		$(wildcard $1*), \
		$(call rwildcard,$d/,$2))

SRC_CXX = $(call filter-out,%.test.cpp,$(call rwildcard,$(SRC_DIR)/,*.cpp))
OBJ_XX = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.xx.o,$(SRC_CXX))
DEBUG_OBJ_XX = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.debug.xx.o,$(SRC_CXX))


default: build

# External dependency management
# ===========================================================================
EXTERNAL_DEPS = $(patsubst external/%.mk,%,$(wildcard external/*.mk))
EXTERNAL_LIBS =

define dep_rules
LIB_$1 = $$(foreach so, \
		$$(shell echo "$$$$(head external/$1.mk -n 1)" | cut -c2-), \
		external/lib/$$(so))
EXTERNAL_LIBS += $$(LIB_$1)

.SECONDARY:
external-deps-$1/%: | external/build/$1/ external/lib/ external/include/
	cd external/build/$1/; \
		$(MAKE) -f ../../$1.mk $$(patsubst external-deps-$1/%,%,$$@)

$$(LIB_$1): external-deps-$1/install
endef

$(foreach dep, \
	$(EXTERNAL_DEPS), \
	$(eval $(call dep_rules,$(dep))))

.PHONY: external-deps/uninstall external-deps/clean-build

external-deps/uninstall: ; rm -rf external/build/ external/lib/ external/include/

external-deps/clean-build: ; rm -rf external/build/

external-deps/%:
	$(MAKE) $(foreach dep, \
		$(EXTERNAL_DEPS), \
		external-deps-$(dep)/$(patsubst external-deps/%,%,$@))

# Directory creation
external/%/: ; mkdir -p $@
# ---------------------------------------------------------------------------


# Build pattern rules
# ===========================================================================
define obj_rules
$$(OBJ_DIR)/$1.xx.o: $$(SRC_DIR)/$1.cpp | $(shell dirname $(OBJ_DIR)/$1/)/
	$$(CXX) -c \
		$$(CXX_FLAGS) $$^ \
		-o $$@

$$(OBJ_DIR)/$1.debug.xx.o: $$(SRC_DIR)/$1.cpp | $(shell dirname $(OBJ_DIR)/$1/)/
	$$(CXX) -c \
		$$(TXX_FLAGS) $$^ \
		-o $$@
endef

$(foreach src, \
	$(patsubst $(SRC_DIR)/%.cpp,%,$(call rwildcard,$(SRC_DIR)/,*.cpp)), \
	$(eval $(call obj_rules,$(src))))

$(BUILD_DIR)/$(PROJECT_NAME): $(OBJ_XX) $(EXTERNAL_LIBS) | $(BUILD_DIR)
	$(CXX) $(CXX_FLAGS) \
		$^ \
		-o $@

$(BUILD_DIR)/$(PROJECT_NAME).debug: $(DEBUG_OBJ_XX) $(EXTERNAL_LIBS) | $(BUILD_DIR)
	$(CXX) $(TXX_FLAGS) \
		$^ \
		-o $@

$(BUILD_DIR)/%/: ; mkdir -p $@

$(BUILD_DIR): ; mkdir -p $@
# ---------------------------------------------------------------------------


.PHONY: build build_debug run debug memcheck clean

build: $(BUILD_DIR)/$(PROJECT_NAME)

build_debug: $(BUILD_DIR)/$(PROJECT_NAME).debug

run: build
	$(BUILD_DIR)/$(PROJECT_NAME)

debug: build_debug
	$(DEBUGGER) $(BUILD_DIR)/$(PROJECT_NAME).debug

memcheck: build_debug
	$(MEMCHECK) $(BUILD_DIR)/$(PROJECT_NAME).debug

clean: ; rm -rf $(BUILD_DIR)
