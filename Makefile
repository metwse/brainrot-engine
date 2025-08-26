EXTERNAL_DEPS = $(patsubst external/%.mk,%,$(wildcard external/*.mk))
EXTERNAL_SO =


define dep_rules

LIB_$1 = $$(foreach so, \
	$$(shell echo "$$$$(head external/libyou.mk -n 1)" | cut -c2-), \
	external/lib/$$(so))

EXTERNAL_SO += $$(LIB_$1)

.SECONDARY:
external-deps-$1-%: external/build/$1/ external/lib/ external/include/
	cd external/build/$1/; \
		$(MAKE) -f ../../$1.mk $$(patsubst external-deps-$1-%,%,$$@)

$$(LIB_$1): external-deps-$1-install

endef

$(foreach dep, \
	$(EXTERNAL_DEPS), \
	$(eval $(call dep_rules,$(dep))))

# Directory creation
external/%/:
	mkdir -p $@

.PHONY: clean-external-deps

external-deps-clean:
	rm -rf external/build/ external/lib/ external/include/
