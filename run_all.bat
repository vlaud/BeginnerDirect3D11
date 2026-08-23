@echo off
setlocal
cd "%~dp0"

pushd ".\00. Opening a Win32 Window\"
".\build\main.exe"
popd
pushd ".\01. Initialising Direct3D 11\"
".\build\main.exe"
popd
pushd ".\02. Drawing a Triangle\"
".\build\main.exe"
popd
pushd ".\03. Drawing a Textured Quad\"
".\build\main.exe"
popd
pushd ".\04. Using a Constant Buffer\"
".\build\main.exe"
popd
pushd ".\05. Measuring Elapsed Time\"
".\build\main.exe"
popd
pushd ".\06. Keyboard Input\"
".\build\main.exe"
popd
pushd ".\07. Virtual Camera\"
".\build\main.exe"
popd
pushd ".\08. Drawing a Cube\"
".\build\main.exe"
popd
pushd ".\09. Loading a Wavefront .obj Mesh\"
".\build\main.exe"
popd
pushd ".\10. Blinn-Phong Lighting\"
".\build\main.exe"
popd
