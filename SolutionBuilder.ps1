param($changedFile = $(throw "change triggering file must be provided"))
# Given an input path, we hunt up the directory structure for a .sln file.
# With that, we trigger a build of the .sln into a temp directory, and then
# pass on to a test running script.
# As far as possible, this script should show nothing on the console.

$ms_build = "$env:windir\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe" # update this with the version of .Net to use #todo: autodetect for each .sln

function CreateTempDir($slnFile) {
	$name = Split-Path -Leaf $slnFile
	$tmp = [System.IO.Path]::Combine($env:Temp, "PoshNUnit\$name")
	mkdir $tmp | out-null
	$tmp
}

function BuildToDirectory($slnFile, $targetDirectory) {
	& $ms_build "$slnFile" /p:OutDir="$targetDirectory\" | out-null
}

function FindNearestSolution($src) {
	try {
		$matchCount = 0
		$trace = $src
		while ($matchCount -eq 0) {
			$trace = Split-Path -parent $trace
			Write-Host "looking in $trace"
			$match= ls -Filter "*.sln" -Path $trace
			$matchCount = ($match| Measure-Object).Count
			Write-Host "found $matchCount solutions"
		}
		if ($matchCount -gt 1) {throw "More than one solution at $trace"}
	} catch {
		throw $_
		exit 1
	}
	"$trace\$match"
}

Write-Host "Looking for nearest parent solution for $changedFile"

$sln = FindNearestSolution($changedFile)
$output = CreateTempDir($sln)

BuildToDirectory -slnFile $sln -targetDirectory $output

return $output

