@echo off
powershell -NoProfile -ExecutionPolicy ByPass ".\Watcher.ps1 -watchPath 'C:\Projects\' -triggerScript '.\NUnitSolutionRunner.ps1' "

