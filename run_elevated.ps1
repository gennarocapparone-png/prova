Param(
  [Parameter(Mandatory=$true)][string]$Script,
  [string]$Arguments = ''
)

$task = 'RunElevatedOnce'
$scht = "$env:SystemRoot\System32\schtasks.exe"
$ps   = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$cmd  = "$ps -ExecutionPolicy Bypass -File `"$Script`" $Arguments"

& $scht /Create /F /RL HIGHEST /SC ONCE /ST 23:59 /TN $task /TR $cmd /RU "$env:USERNAME" | Out-Null
& $scht /Run /TN $task | Out-Null

Start-Sleep -Seconds 3
try { & $scht /Delete /F /TN $task | Out-Null } catch {}