# Shared path resolution for the HomeAgents CLI.
#
# Every repository of the platform lives side by side under one "repos root":
#
#   <repos root>/
#     homeagents-cli/            <- this repo
#     homeagents-core/           LiteLLM, Qdrant, TEI, SearXNG, OpenHands, Firefly MCP
#     dify-deployment/
#     librechat-deployment/
#     paperless-qdrant-ingestion/
#
# The CLI therefore defaults the repos root to this repo's parent directory.
# When the layout differs, pass -ReposRoot to an entry script or export the
# HOMEAGENTS_REPOS_ROOT environment variable.
function Get-HomeAgentsPaths {
    param(
        # Explicit -ReposRoot value from an entry script (wins over everything).
        [string]$Override,

        # Absolute path of the CLI repository itself (callers know their own
        # depth, so they pass it in instead of this function guessing).
        [Parameter(Mandatory = $true)]
        [string]$CliRoot
    )

    if ($Override) {
        $reposRoot = $Override
    }
    elseif ($env:HOMEAGENTS_REPOS_ROOT) {
        $reposRoot = $env:HOMEAGENTS_REPOS_ROOT
    }
    else {
        $reposRoot = Join-Path $CliRoot '..'
    }

    $reposRoot = (Resolve-Path $reposRoot).Path
    $coreRoot = Join-Path $reposRoot 'homeagents-core'

    [pscustomobject]@{
        ReposRoot        = $reposRoot
        CoreRoot         = $coreRoot
        # The platform .env lives in the core repo; every stage except dify
        # consumes it. dify ships its own .env next to its compose file.
        EnvFile          = Join-Path $coreRoot '.env'
        DifyCompose      = Join-Path $reposRoot 'dify-deployment\dify.yml'
        ChatCompose      = Join-Path $reposRoot 'librechat-deployment\librechat.yml'
        IngestionCompose = Join-Path $reposRoot 'paperless-qdrant-ingestion\document-ingestion.yml'
    }
}
