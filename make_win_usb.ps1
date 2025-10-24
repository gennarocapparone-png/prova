Param(
    [Parameter(Mandatory=$true)][ValidatePattern('^[A-Z]:$')]
    [string]$Drive,                      # es. E:
    [ValidateSet('win10','win11')]
    [string]$Version = 'win10',
    [string]$Lang = 'it-it',
    [string]$Arch = 'x64'
)

$ErrorActionPreference = 'Stop'
$root = 'C:\WinUSB'
New-Item -Force -ItemType Directory $root | Out-Null
Set-Location $root

Write-Host "== Scarico Fido (tool ufficiale Rufus per ISO Microsoft)…"
$FidoUrl = 'https://raw.githubusercontent.com/pbatard/Fido/master/Fido.ps1'
Invoke-WebRequest -UseBasicParsing $FidoUrl -OutFile "$root\Fido.ps1"

Write-Host "== Scarico l’ultima versione di Rufus (x64)…"
$RufusUrl = 'https://github.com/pbatard/rufus/releases/latest/download/rufus-x64.exe'
Invoke-WebRequest -UseBasicParsing $RufusUrl -OutFile "$root\rufus.exe"

Write-Host "== Scarico l’ISO di Windows ($Version $Arch $Lang) con Fido…"
# Fido genera un link ufficiale Microsoft e scarica l’ISO.
# Opzioni valide per $Version: win10 | win11
# Lingua (it-it) e architettura (x64) già impostate.
powershell -ExecutionPolicy Bypass -File "$root\Fido.ps1" `
    -Win $Version -Lang $Lang -Ed Pro -Arch $Arch -o "$root"

# Trova il file ISO appena salvato
$iso = Get-ChildItem -Path $root -Filter *.iso | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $iso) { throw "ISO non trovata. Fido non ha scaricato nulla." }

Write-Host "== Scrivo l’ISO su $Drive con Rufus in modalità silenziosa…"
# Rufus CLI non mostra finestre: richiede privilegi elevati.
& "$root\rufus.exe" --quiet --device $Drive --iso $iso.FullName --persistentpartition 0

Write-Host "== FATTO. La chiavetta $Drive è pronta per il boot di Windows."