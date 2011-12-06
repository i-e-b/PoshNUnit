param($changedFile = $(throw "change triggering file must be provided"))

$nunit = "C:\Program Files\NUnit 2.5.10\bin\net-2.0\nunit-console-x86.exe"

$workingDirectory = .\SolutionBuilder.ps1 $changedFile
.\NUnitRunner.ps1 $workingDirectory

rm -Recurse -Force $workingDirectory
