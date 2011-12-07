param($changedFile = $(throw "change triggering file must be provided"))

$workingDirectory = .\SolutionBuilder.ps1 $changedFile
.\NUnitRunner.ps1 $workingDirectory

#rm -Recurse -Force $workingDirectory
