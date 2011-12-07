param($buildDirectory = $(throw "build results directory must be provided"))
# Test against all the dlls we can find, report any failures.
#todo: configurable pattern for test assemblies?

$nunit = "${env:ProgramFiles(x86)}\NUnit 2.5.10\bin\net-2.0\nunit-console-x86.exe"
$results = "$buildDirectory\_PoshNUnit_Results.xml"
$dlls = ""

ls -Filter "*.dll" -Path $buildDirectory | %{$dlls += "$_ "}

& $nunit $dlls /xml=$results | out-null

#todo: read the results xml for failed tests, output the name to the screen.