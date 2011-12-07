param($changedFile = $(throw "change triggering file must be provided"))

$workingDirectory = .\SolutionBuilder.ps1 $changedFile
if ($LASTEXITCODE -ne 0) {return}

.\NUnitRunner.ps1 $workingDirectory

