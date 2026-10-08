param([string]$ReposRoot)

. "$PSScriptRoot\..\..\lib\logging.ps1"
. "$PSScriptRoot\..\..\lib\paths.ps1"

$paths = Get-HomeAgentsPaths -Override $ReposRoot -CliRoot (Resolve-Path "$PSScriptRoot\..\..").Path

Write-Step "Starting dify..."
# No --env-file on purpose: dify is self-contained. Docker Compose reads
# dify-deployment\.env (next to the compose file) for both variable
# interpolation and the containers' environment; passing the core .env would
# override those defaults.
docker compose -f "$($paths.DifyCompose)" up -d
