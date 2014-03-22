@ECHO OFF

REM Source is where we check out from SVN on the build server
set Source=C:\HB\hostelbookers.messaging\hostelbookers.messaging\Hostelbookers.Messaging

echo Base Source Path is %Source%
if not exist %Source% echo Source Path does NOT exist

set NuGetRepository=C:\HB\hostelbookers.messaging\hostelbookers.messaging\nuget
REM set NuGetRepositoryKey=600af901-2305-4783-b25b-3d7f9d25ad6d

REM set up the versions to give the nuget packages
set version=1.0.1

REM override versions here if required, otherwise just set to %version%
set configVersion=%version%
 
REM This is where we tell TeamCity to build the solution to on the build server, so all DLLs end up in this folder
set binaryFiles=%Source%\..\Binaries\
 
call :PublishNuGet Hostelbookers.Messaging.Configurations %configVersion%

exit 0

REM PublishNuGet is a function in a batch file

:PublishNuGet
setlocal

set ProjName=%1
set ProjVersion=%2
 
REM 1 - copy the nuspec file to the binary output location
copy %Source%\%ProjName%\%ProjName%.nuspec %binaryFiles%%ProjName%.nuspec
 
REM 2 - create the package using .nuspec file
%Source%\.nuget\nuget pack %binaryFiles%%ProjName%.nuspec -Version %ProjVersion% -OutputDirectory %binaryFiles%
 
REM 3 - publish the package to nuget repository
%Source%\.nuget\nuget push %binaryFiles%%ProjName%.%ProjVersion%.nupkg -s %NuGetRepository%
 
endlocal