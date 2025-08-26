# libtrees.so libhuffman.so

.PHONY: install
install:
	if [ -d libyou ]; then \
		cd libyou; git pull origin main; \
	else \
		git clone https://github.com/metwse/libyou/ --depth 1; \
	fi
	cd libyou; make build/all
	cp libyou/target/*.so ../../lib/
	mkdir -p ../../include/libyou/

	for module in libyou/*/include; do \
		cp $$module/* ../../include/libyou/; \
		echo $$module; \
	done
