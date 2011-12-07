param($watchPath = $(throw "Watch path is required"), $triggerScript = $(throw "Trigger script is required"))
# watch a file changes in the current directory, 
# execute all tests when a file is changed or renamed

function ResetHost($msg) {
	Clear-Host
	[Console]::SetCursorPosition(0,0)
	[Console]::Write($msg)
	[Console]::SetCursorPosition(0,1)
}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $watchPath
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $false
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName

$watch_filter = [System.IO.WatcherChangeTypes]::Changed -bor [System.IO.WatcherChangeTypes]::Renamed -bOr [System.IO.WatcherChangeTypes]::Created -bOr [System.IO.WatcherChangeTypes]::Deleted

Write-Host "Watching $watchPath for changes"

while($true){
	$result = $watcher.WaitForChanged($watch_filter, 1000);
	if($result.TimedOut){
		continue;
	}

	if ($result.Name.Contains(".svn")) { continue; }

	Write-Host "Change in $($result.Name)"
	& $triggerScript "$watchPath\$($result.Name)"
	Write-Host "Continuing to watch $watchPath"
}

