# script-helpers

Script helpers to build 3rd party libraries including Magnum engine and it's dependencies during development process.

## Magnum
## Clone Magnum

To clone all Magnum repositories with all dependencies required by local build scripts.

`./clone-all-magnum.sh /d/Work/Git`

Where:
- "$1": root input directory (example) /d/Git

## Build Magnum

Folder includes setup scripts for cloned projects.
You can build particular project by calling one of the scripts with appropriate arguments.

For example to setup Corrade:

`./setup-corrade-build.sh /d/Work/Git /d/Work/Git/build Release Win64 ON`

Where:
- "$1": root input directory (example) /e/Git
- "$2": build output directory (example) /e/Git/build/
- "$3": build type Release/Debug
- "$5": build system Android/Win64/macOS/Linux
- "$6": perform build or configuration only ON/OFF. If ON system will build and install project.

Script will create cmake configuration in specified build folder.
Be aware that calling the build script means clean and rebuild the project again.
For faster development it is better to go directly to the generated build folder and call build `ninja` for example.

To configure and rebuild all projects call:

`./setup-build-all-magnum.sh /d/Work/Git /d/Work/Git/build Release Win64`

The script will call, setup, build and install all projects in right order.
