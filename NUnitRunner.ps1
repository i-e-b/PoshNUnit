param($buildDirectory = $(throw "build results directory must be provided"))
# Test against all the dlls we can find, report any failures.
#todo: configurable pattern for test assemblies?

$nunit = "${env:ProgramFiles(x86)}\NUnit 2.5.10\bin\net-2.0\nunit-console-x86.exe"
$results = "$buildDirectory\_PoshNUnit_Results.xml"

$dlls = ls -Filter "*.Specs.dll" -Path $buildDirectory

pushd $buildDirectory
& $nunit $dlls /xml=$results | out-null
popd

#todo: read the results xml for failed tests, output the name to the screen.

# for now, copy results to a permanent location
mv $results -Destination "C:\temp\"

