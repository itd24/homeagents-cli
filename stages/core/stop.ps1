param([string]$ReposRoot)

. "$PSScriptRoot\..\..\lib\logging.ps1"
. "$PSScriptRoot\..\..\lib\paths.ps1"

$paths = Get-HomeAgentsPaths -Override $ReposRoot -CliRoot (Resolve-Path "$PSScriptRoot\..\..").Path

Write-Step "Stopping core services..."
Write-Info "Stopping memory service..."
docker compose --env-file "$($paths.EnvFile)" -f "$($paths.CoreRoot)\core\memory.yml" down
Write-Info "Stopping LiteLLM service..."
docker compose --env-file "$($paths.EnvFile)" -f "$($paths.CoreRoot)\core\litellm.yml" down
