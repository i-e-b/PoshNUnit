param(
	$buildDirectory = $(throw "build results directory must be provided"),
	$testAssmPattern = "*test*.dll" # replace with *.dll to test everything -- this is quite slow!
)
# Test against all the dlls we can find, report any failures.
#todo: configurable pattern for test assemblies?

$PossibleNunits = @(
	"${env:ProgramFiles}\NUnit*\bin\net-4.0\nunit-console.exe",
	"${env:ProgramFiles(x86)}\NUnit*\bin\net-4.0\nunit-console.exe",
	"${env:ProgramFiles(x86)}\NUnit*\bin\nunit-console.exe");

$nunit = $PossibleNunits | %{ ls $_ } | ?{ Test-Path $_ } | select-object -first 1
if (-not (Test-Path $nunit)) {
	Write-Host "No NUnit install found" -fo red
	return
}
$results = "$buildDirectory\_PoshNUnit_Results.xml"

$dlls = ls -Filter $testAssmPattern -Path $buildDirectory

if (Test-Path $results) { rm $results }

pushd $buildDirectory
& $nunit $dlls /framework=v4.0 /xml=$results | out-null
popd

if (-not (Test-Path $results)) {
	Write-Host "No test results found" -fo yellow
	return
}

Write-Host "Reading results: " -NoNewline

$tests = Select-Xml -Path "$results" -Xpath '//test-case' | %{ $_.Node }
$passed = 0
$failed = 0
$other = 0
$tests | %{
	if ($_.result -eq "success") {$passed++}
	elseif ($_.result -eq "inconclusive") {$other++}
    elseif ($_.result -eq "Ignored") {$other++}
	else {$failed++}
}
Write-Host "$passed tests passed " -fo green -NoNewline
if ($other -gt 0) {Write-Host "$other inconclusive or ignored " -fo yellow -NoNewline}
if ($failed -gt 0) {Write-Host "$failed failed " -fo red -NoNewLine}
Write-Host ";"
if ($failed -eq 0) {$tests | %{ if (($_.result -eq "ignored") -or ($_.result -eq "inconclusive")) {
	Write-Host $_.name -fo yellow
}}}
$tests | %{ if ($_.result -eq "Failure") {
	Write-Host $_.name -fo red
}}

