param([string]$ReposRoot)

. "$PSScriptRoot\..\..\lib\logging.ps1"
. "$PSScriptRoot\..\..\lib\paths.ps1"

$paths = Get-HomeAgentsPaths -Override $ReposRoot -CliRoot (Resolve-Path "$PSScriptRoot\..\..").Path

Write-Step "Starting librechat..."
docker compose --env-file "$($paths.EnvFile)" -f "$($paths.ChatCompose)" up -d
