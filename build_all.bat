@echo off
setlocal
cd "%~dp0"

cmd /c ".\00. Opening a Win32 Window\build.bat"
cmd /c ".\01. Initialising Direct3D 11\build.bat"
cmd /c ".\02. Drawing a Triangle\build.bat"
cmd /c ".\03. Drawing a Textured Quad\build.bat"
cmd /c ".\04. Using a Constant Buffer\build.bat"
cmd /c ".\05. Measuring Elapsed Time\build.bat"
cmd /c ".\06. Keyboard Input\build.bat"
cmd /c ".\07. Virtual Camera\build.bat"
cmd /c ".\08. Drawing a Cube\build.bat"
cmd /c ".\09. Loading a Wavefront .obj Mesh\build.bat"
cmd /c ".\10. Blinn-Phong Lighting\build.bat"
