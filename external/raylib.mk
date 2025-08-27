# libraylib.so

# Required targets
update: raylib-5.5_linux_amd64

build:

clean: ; rm raylib-*

install: update
	cp -r raylib-5.5_linux_amd64/include/* ../../include/
	cp raylib-5.5_linux_amd64/lib/libraylib.so ../../lib/

.PHONY: update build clean install


# Internal targets
raylib-5.5_linux_amd64.tar.gz:
	wget https://github.com/raysan5/raylib/releases/download/5.5/raylib-5.5_linux_amd64.tar.gz

raylib-5.5_linux_amd64: raylib-5.5_linux_amd64.tar.gz
	tar -xzf raylib-5.5_linux_amd64.tar.gz
