@echo off
rem backward compatibility for  python command-line users
"%WINPYDIR%\python.exe" main.py --ngs=28 --rep=1000000 %*
