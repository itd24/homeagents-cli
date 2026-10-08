param(
    [Parameter(Position = 0)]
    [string]$Stage,

    [Parameter(Position = 1)]
    [string]$Command,

    [Parameter(Position = 2)]
    [string]$Arg1,

    # Directory that holds all HomeAgents repositories. Defaults to this
    # repo's parent directory (see lib/paths.ps1).
    [string]$ReposRoot
)

$root = $PSScriptRoot

# `homeagents status` is the only command that takes no stage.
if ($Stage -eq 'status' -and [string]::IsNullOrEmpty($Command)) {
    $Command = 'status'
}

switch ($Command) {
    "run" {
        & "$root\scripts\create-docker-network.ps1"
        switch ($Stage) {
            "core" {
                & "$root\stages\core\run.ps1" -ReposRoot $ReposRoot
            }

            "websearch" {
                & "$root\stages\websearch\run.ps1" -ReposRoot $ReposRoot
            }

            "programming" {
                & "$root\stages\programming\run.ps1" -ReposRoot $ReposRoot
            }

            "finance" {
                & "$root\stages\finance\run.ps1" -ReposRoot $ReposRoot
            }

            "chat" {
                & "$root\stages\chat\run.ps1" -ReposRoot $ReposRoot
            }

            "dify" {
                & "$root\stages\dify\run.ps1" -ReposRoot $ReposRoot
            }

            "document-ingestion" {
                & "$root\stages\document-ingestion\run.ps1" -ReposRoot $ReposRoot
            }

            default {
                Write-Host "Unknown stage: $Stage"
                exit 1
            }
        }
    }

    "stop" {
        switch ($Stage) {
            "core" {
                & "$root\stages\core\stop.ps1" -ReposRoot $ReposRoot
            }

            "websearch" {
                & "$root\stages\websearch\stop.ps1" -ReposRoot $ReposRoot
            }

            "programming" {
                & "$root\stages\programming\stop.ps1" -ReposRoot $ReposRoot
            }

            "chat" {
                & "$root\stages\chat\stop.ps1" -ReposRoot $ReposRoot
            }

            "dify" {
                & "$root\stages\dify\stop.ps1" -ReposRoot $ReposRoot
            }

            "finance" {
                & "$root\stages\finance\stop.ps1" -ReposRoot $ReposRoot
            }

            default {
                Write-Host "Unknown stage: $Stage"
                exit 1
            }
        }
    }

    "restart" {
        switch ($Stage) {
            "programming" {
                # Check if Arg1 was actually provided by the user
                if ([string]::IsNullOrEmpty($Arg1)) {
                    # Run without the parameter so the sub-script defaults to $PWD.Path
                    & "$root\stages\programming\restart.ps1" -ReposRoot $ReposRoot
                } else {
                    # Run with the parameter because the user explicitly provided a path
                    & "$root\stages\programming\restart.ps1" -ReposRoot $ReposRoot -Arg1 $Arg1
                }
            }

            default {
                Write-Host "Unknown stage: $Stage"
                exit 1
            }
        }
    }

    "status" {
        Write-Host "Containers on ai-platform-net:"
        docker ps --filter "network=ai-platform-net" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        Write-Host ""
        Write-Host "Dify containers (own network):"
        docker ps --filter "name=dify-" --format "table {{.Names}}\t{{.Status}}"
    }

    default {
        Write-Host "Usage:"
        Write-Host "  homeagents core run"
        Write-Host "  homeagents websearch run"
        Write-Host "  homeagents document-ingestion run"
        Write-Host "  homeagents programming run"
        Write-Host "  homeagents chat run"
        Write-Host "  homeagents dify run"
        Write-Host "  homeagents finance run"
        Write-Host "  homeagents core stop"
        Write-Host "  homeagents websearch stop"
        Write-Host "  homeagents programming stop"
        Write-Host "  homeagents chat stop"
        Write-Host "  homeagents dify stop"
        Write-Host "  homeagents finance stop"
        Write-Host "  homeagents status"
        Write-Host ""
        Write-Host "Add -ReposRoot <path> (or set HOMEAGENTS_REPOS_ROOT) when the"
        Write-Host "HomeAgents repositories are not checked out side by side."
    }
}