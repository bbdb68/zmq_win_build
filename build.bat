: build script on windows

SET CMAKE="c:\program files (x86)\cmake\bin\cmake"

: setup visual studio 2015
: call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64

: configure zmq
: -------------
mkdir "build_dir\zmq"
cd "build_dir\zmq"
%cmake% -G "Visual Studio 14 2015 Win64" ..\..\..\libzmq

pause -1
