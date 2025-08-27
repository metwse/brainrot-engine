# External Dependencies Build
Manages external libraries, uses `Makefile` rules to automatically fetch,
build, and install dependencies.

## Directory Structure
```
external/
├── build/                  # Temporary build outputs, internal to build script
│   └── <build-artifacts>
├── include/                # Installed headers
│   ├── **.h
│   └── **.hpp
├── llibyouib/              # Installed shared libraries
│   └── *.so
└── <lib-name>.mk           # Build instructions for <lib-name>
```

## Writing Dependency Scripts
Each external dependency must provide a `.mk` file under `external/`.

Rules to implement:
- `update`: Fetch or update the source (clone repo, download tarball, etc.).
- `build`: Compile the library.
- `install`: Copy resulting `.so` files to `external/lib/` and headers to
  `external/include/`.
- `clean`: Remove build artifacts.

### First Line Convention
The first line of each `.mk` file must contain a comment listing the exposed
`.so` files, e.g.:
```make
# libtrees.so libhuffman.so
```
The top-level `Makefile` parses this line to track installed libraries.

## Integration with Top-Level Makefile
| top-level Makefile target | description |
|--|--|
| `external-deps/build` | builds all dependencies. |
| `external-deps/uninstall` | removes `external/build/`, `external/lib/`, and `external/include/`. |
| `external-deps/clean-build` | clears only build directories. |
| `external-deps/<target>` | forwards `<target>` to all dependencies.<br>(e.g. `make external-deps/update`, `make external-deps/install`). |

The set of valid `<target>` values is defined by the required targets expected
in each dependency `.mk` file *(see Writing Dependency Scripts above)*.
