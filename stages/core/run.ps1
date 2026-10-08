param([string]$ReposRoot)

. "$PSScriptRoot\..\..\lib\logging.ps1"
. "$PSScriptRoot\..\..\lib\paths.ps1"

$paths = Get-HomeAgentsPaths -Override $ReposRoot -CliRoot (Resolve-Path "$PSScriptRoot\..\..").Path

Write-Step "Starting core services..."
Write-Info "Starting memory service..."
docker compose --env-file "$($paths.EnvFile)" -f "$($paths.CoreRoot)\core\memory.yml" up -d
Write-Info "Starting LiteLLM service..."
docker compose --env-file "$($paths.EnvFile)" -f "$($paths.CoreRoot)\core\litellm.yml" up -d
