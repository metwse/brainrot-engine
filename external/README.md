# External Dependencies Build
Contains external libraries used by the project. Provides a `Makefile`-based
system to automatically fetch, build, and install these dependencies, including
both shared libraries `(.so)` and headers.

## Directory Structure
```
external/
├── build/                # Temporary build outputs, internal to build script
│   └── libyou/
├── include/              # Installed headers
│   └── libyou/
├── lib/                  # Installed shared libraries
└── libyou.mk             # Build instructions for libyou
```

## Writing a Make Script for External Dependencies
Each external dependency should have a `Makefile` or `.mk` script that:
- Clones or updates the repository if necessary.
- Builds the library.
- Copies resulting .so files to `lib/`.
- Copies header files to `include/<library>/`.
- *Important*: The first line of the script must list the `.so` files that the
  library exposes.

## Integration to Top-Level Makefile
The top-level `Makefile` automatically detects all .mk files in `external/` and
ensures `.so` files and headers are copied to the proper locations. Dependency
tracing done checink `.so` files.
