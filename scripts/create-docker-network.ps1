. "$PSScriptRoot\..\lib\logging.ps1"

$networkName = "ai-platform-net"

$networkExists = docker network ls --format "{{.Name}}" | Where-Object { $_ -eq $networkName }

if (-not $networkExists) {
    Write-Step "Creating Docker network '$networkName'..."
    docker network create $networkName
}
else {
    Write-Info "Docker network '$networkName' already exists."
}