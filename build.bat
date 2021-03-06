:: Generated by: https://github.com/swagger-api/swagger-codegen.git
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::      http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

@echo off

SET CSCPATH=%SYSTEMROOT%\Microsoft.NET\Framework\v4.0.30319

SET FORGESDK_VERSION=1.8.0
SET RESTSHARP_VERSION=106.11.7
SET NEWTOWNSOFT_VERSION=12.0.3

if not exist ".\nuget.exe" powershell -Command "(new-object System.Net.WebClient).DownloadFile('https://nuget.org/nuget.exe', '.\nuget.exe')"
:: .\nuget.exe install src\Autodesk.Forge\packages.config -OutputDirectory packages
.\nuget.exe install RestSharp -OutputDirectory packages
.\nuget.exe install Newtonsoft.Json -OutputDirectory packages

goto real_build

if not exist ".\bin" mkdir bin

copy packages\Newtonsoft.Json.%NEWTOWNSOFT_VERSION%\lib\net452\Newtonsoft.Json.dll bin\Newtonsoft.Json.dll
copy packages\RestSharp.%RESTSHARP_VERSION%\lib\net452\RestSharp.dll bin\RestSharp.dll

:: /platform:anycpu - default
:: /debug - not default
%CSCPATH%\csc /reference:bin\Newtonsoft.Json.dll;bin\RestSharp.dll /target:library /out:bin\Autodesk.Forge.dll /recurse:src\Autodesk.Forge\*.cs /doc:bin\Autodesk.Forge.xml

:: .\nuget pack src\Autodesk.Forge\Autodesk.Forge.csproj -Prop Platform=AnyCPU -Prop Configuration=Release
.\nuget pack Autodesk.Forge.nuspec

goto publishtonuget

:real_build
if not exist ".\src\Autodesk.Forge\bin" mkdir src\Autodesk.Forge\bin
if not exist ".\src\Autodesk.Forge\bin\Release" mkdir src\Autodesk.Forge\bin\Release
%CSCPATH%\csc /reference:packages\Newtonsoft.Json.%NEWTOWNSOFT_VERSION%\lib\net452\Newtonsoft.Json.dll;packages\RestSharp.%RESTSHARP_VERSION%\lib\net452\RestSharp.dll /target:library /out:src\Autodesk.Forge\bin\Release\Autodesk.Forge.dll /recurse:src\Autodesk.Forge\*.cs /doc:src\Autodesk.Forge\bin\Release\Autodesk.Forge.xml

.\nuget pack src\Autodesk.Forge\Autodesk.Forge.csproj -Prop Platform=AnyCPU -Prop Configuration=Release

:publishtonuget
echo .
echo ".\nuget push Autodesk.Forge%FORGESDK_VERSION%.nupkg %NUGETAPIKEY% -Source https://www.nuget.org/api/v2/package"
:: .\nuget push Autodesk.Forge.1.0.0.nupkg %NUGETAPIKEY% -Source https://www.nuget.org/api/v2/package
