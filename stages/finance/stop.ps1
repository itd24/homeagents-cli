param([string]$ReposRoot)

. "$PSScriptRoot\..\..\lib\logging.ps1"
. "$PSScriptRoot\..\..\lib\paths.ps1"

$paths = Get-HomeAgentsPaths -Override $ReposRoot -CliRoot (Resolve-Path "$PSScriptRoot\..\..").Path

Write-Step "Stopping financial services..."
docker compose --env-file "$($paths.EnvFile)" -f "$($paths.CoreRoot)\finance\firefly-mcp.yml" down
