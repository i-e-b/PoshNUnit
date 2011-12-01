param($watchPath = $(throw "Watch path is required"), $triggerScript = $(throw "Trigger script is required"))
# watch a file changes in the current directory, 
# execute all tests when a file is changed or renamed

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $watchPath
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $false
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName

$watch_filter = [System.IO.WatcherChangeTypes]::Changed -bor [System.IO.WatcherChangeTypes]::Renamed -bOr [System.IO.WatcherChangeTypes]::Created -bOr [System.IO.WatcherChangeTypes]::Deleted

while($true){
	$result = $watcher.WaitForChanged($watch_filter, 1000);
	if($result.TimedOut){
		Clear-Host
		[Console]::SetCursorPosition(0,0)
		[Console]::Write("Monitoring $watchPath $([DateTime]::Now) Hold [ctrl]-C to exit")
		[Console]::SetCursorPosition(0,1)
		continue;
	}
	write-host "Change in $($result.Name)"
	& $triggerScript $result.Name
}

