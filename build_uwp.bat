: build script on windows

SET CURRENTDIR=%cd%
SET CMAKE="c:\program files (x86)\cmake\bin\cmake"
SET CMAKE="c:\program files\cmake\bin\cmake"
SET CONFIGURATION=Release
: SET CONFIGURATION=Debug
: SET GENERATOR="Visual Studio 14 2015 Win64"
SET GENERATOR="Visual Studio 14 2015" -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0

: setup visual studio 2015
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86

: -------------
:   ZeroMQ
: -------------

mkdir "build_dir_uwp\zmq"
cd "build_dir_uwp\zmq"
%cmake% -G %GENERATOR% -DZMQ_BUILD_TESTS=OFF  -DZMQ_USE_TWEETNACL=OFF -DENABLE_CURVE=OFF ..\..\..\libzmq
msbuild ZeroMQ.sln /p:Configuration=%CONFIGURATION% /p:Platform=Win32 /t:libzmq
: .\bin\%CONFIGURATION%\inproc_lat.exe 100 100

cd ..\..

set LIBZMQ_INCLUDE_DIRS=%CURRENTDIR%\..\libzmq\include
set LIBZMQ_LIBRARIES=%CURRENTDIR%\build_dir_uwp\zmq\lib\%CONFIGURATION%\libzmq-v140-mt-4_2_2.lib
set LIBZMQ_DLL=%CURRENTDIR%\build_dir_uwp\zmq\bin\%CONFIGURATION%\libzmq-v140-mt-4_2_2.dll


: -------------
:   CZMQ
: --------------

mkdir "build_dir_uwp\czmq"
cd "build_dir_uwp\czmq"
%cmake% -G %GENERATOR% ..\..\..\czmq ^
  -DLIBZMQ_INCLUDE_DIRS=%LIBZMQ_INCLUDE_DIRS% -DLIBZMQ_LIBRARIES=%LIBZMQ_LIBRARIES%

msbuild czmq.sln /p:Configuration=%CONFIGURATION% /p:Platform=Win32

copy %LIBZMQ_DLL% .\%CONFIGURATION%

cd ..\..

set CZMQ_INCLUDE_DIRS=%CURRENTDIR%\..\czmq\include
set CZMQ_LIBRARIES=%CURRENTDIR%\build_dir_uwp\czmq\%CONFIGURATION%\czmq.lib
set CZMQ_DLL=%CURRENTDIR%\build_dir_uwp\czmq\%CONFIGURATION%\czmq.dll


: -----------
:   zyre
: -----------

mkdir "build_dir_uwp\zyre"
cd "build_dir_uwp\zyre"
%cmake% -G %GENERATOR%   ..\..\..\zyre ^
  -DLIBZMQ_INCLUDE_DIRS=%LIBZMQ_INCLUDE_DIRS% -DLIBZMQ_LIBRARIES=%LIBZMQ_LIBRARIES% ^
  -DCZMQ_INCLUDE_DIRS=%CZMQ_INCLUDE_DIRS% -DCZMQ_LIBRARIES=%CZMQ_LIBRARIES%

msbuild zyre.sln /p:Configuration=%CONFIGURATION% /p:Platform=Win32
copy %LIBZMQ_DLL% .\%CONFIGURATION%
copy %CZMQ_DLL% .\%CONFIGURATION%

cd ..\..

pause -1
