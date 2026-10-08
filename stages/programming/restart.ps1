param(
    [Parameter(Position = 0)]
    [string]$Arg1 = $PWD.Path,

    [string]$ReposRoot
)

. "$PSScriptRoot\..\..\lib\logging.ps1"

$cliRoot = (Resolve-Path "$PSScriptRoot\..\..").Path

& "$cliRoot\stages\programming\stop.ps1" -ReposRoot $ReposRoot

Write-Step "Setting the project path to $Arg1..."
$env:PROJECTS_PATH = $Arg1

& "$cliRoot\stages\programming\run.ps1" -ReposRoot $ReposRoot
