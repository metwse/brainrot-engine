# libtrees.so libhuffman.so

# Required targets
update: libyou
	cd libyou; git pull origin main

build: libyou
	cd libyou; make build/all

clean:
	cd libyou; make clean

install: build
	mv libyou/target/*.so ../../lib/
	mkdir -p ../../include/you/

	for module in libyou/*/include; do \
		cp $$module/* ../../include/you/; \
		echo $$module; \
	done

.PHONY: update build clean install


# Internal targets
libyou:
	git clone https://github.com/metwse/libyou/ --depth 1;
