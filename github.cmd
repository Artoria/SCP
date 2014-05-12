@echo off
call :init

if [%1] == [init] (
  git remote add origin https://github.com/%2/%3
) 

if [%1] == [push] (
  git push -u origin master
)

if [%1] == [cp] (
  git add .
  git commit -m %2
  git push -u origin master
)

goto :eof
:init

:init_git
git remote list 2>&1 | find "Not a git" > nul
if %errorlevel% == 0 ( git init )

