param($changedFile = $(throw "change triggering file must be provided"))
# Given an input path, we hunt up the directory structure for a .sln file.
# With that, we trigger a build of the .sln into a temp directory, and then
# pass on to a test running script.
# As far as possible, this script should show nothing on the console.

$ms_build = "$env:windir\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe" # update this with the version of .Net to use #todo: autodetect for each .sln

function CreateTempDir {
	$tmp = [System.IO.Path]::Combine($env:Temp, [System.Guid]::NewGuid())
	mkdir $tmp | out-null
	$tmp
}

function BuildToDirectory($slnFile, $targetDirectory) {
		& $ms_build "$slnFile" /p:OutDir="$targetDirectory\"
}

function FindNearestSolution($src) {
	$matchCount = 0
	$trace = $src
	while ($matchCount -eq 0) {
		$trace = Split-Path -parent $trace
		$match= ls -Filter "*.sln" -Path $trace
		$matchCount = ($match| Measure-Object).Count
	}
	if ($matchCount -gt 1) {throw "More than one solution at $trace"}
	
	"$trace\$match"
}

$output = CreateTempDir
$sln = FindNearestSolution($changedFile)

BuildToDirectory -slnFile $sln -targetDirectory $output

# next steps... run .dll files in the output against NUnit and coallate the results.
#ls -Filter "*.dll" -Path $output
ls -Filter "*.Specs.dll" -Path $output

rm -Recurse -Force $output

