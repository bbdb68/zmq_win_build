: build script on windows

SET CURRENTDIR=%cd%
SET CMAKE="c:\program files (x86)\cmake\bin\cmake"
SET CONFIGURATION=Release
SET GENERATOR="Visual Studio 14 2015 Win64"

: setup visual studio 2015
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64

: configure zmq
: -------------
mkdir "build_dir\zmq"
cd "build_dir\zmq"
%cmake% -G %GENERATOR% -DZMQ_BUILD_TESTS=OFF ..\..\..\libzmq
msbuild ZeroMQ.sln /p:Configuration=%CONFIGURATION%
.\bin\Release\inproc_lat.exe 100 100

cd ..\..

: configure czmq
: --------------
set LIBZMQ_INCLUDE_DIRS=%CURRENTDIR%\..\libzmq\include
set LIBZMQ_LIBRARIES=%CURRENTDIR%\build_dir\zmq\lib\%CONFIGURATION%\libzmq-v140-mt-4_2_2.lib

mkdir "build_dir\czmq"
cd "build_dir\czmq"
%cmake% -G %GENERATOR% ..\..\..\czmq -DLIBZMQ_INCLUDE_DIRS=%LIBZMQ_INCLUDE_DIRS% -DLIBZMQ_LIBRARIES=%LIBZMQ_LIBRARIES%
msbuild czmq.sln /p:Configuration=%CONFIGURATION%

cd ..\..

: zyre
: -----------
set CZMQ_INCLUDE_DIRS=%CURRENTDIR%\..\czmq\include
set CZMQ_LIBRARIES=%CURRENTDIR%\build_dir\czmq\%CONFIGURATION%\czmq.lib

mkdir "build_dir\zyre"
cd "build_dir\zyre"
%cmake% -G %GENERATOR%   ..\..\..\zyre -DLIBZMQ_INCLUDE_DIRS=%LIBZMQ_INCLUDE_DIRS% -DLIBZMQ_LIBRARIES=%LIBZMQ_LIBRARIES% -DCZMQ_INCLUDE_DIRS=%CZMQ_INCLUDE_DIRS% -DCZMQ_LIBRARIES=%CZMQ_LIBRARIES%
msbuild zyre.sln /p:Configuration=%CONFIGURATION%

cd ..\..

pause -1
