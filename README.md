OGL Wrapper
===========

Making myself an OpenGL-based graphics engine. No particular reason.

Some of the code is based off of some C++ code from a course at university.

Building
========

All of the dependencies are handled by DUB. As such, building the application
should be as simple as running the dub command from within the project base
directory. You can get dub here: http://code.dlang.org/download

In order to run this on Windows, you will need to provide a 32-bit SDL2.dll
either in the project folder or in your System32 folder so that SDL will run
properly. Note that if you have a 64-bit machine and a 64-bit version of
SDL2.dll located in your SYSWOW64 folder, you will need to either delete that
or put a 32-bit version of the DLL into the project folder in order for the
program to work properly.

