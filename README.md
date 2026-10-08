# HomeAgents CLI

A small PowerShell runner that starts and stops the Docker Compose stacks of the
HomeAgents platform. It is thin on purpose. Each stage script resolves its own
paths and then calls `docker compose` directly.

## Requirements

* Windows PowerShell 5.1 or PowerShell 7 or newer
* Docker with Compose v2 on `PATH`
* All HomeAgents repositories checked out side by side, see the layout below

## Layout

The CLI expects to live next to the other repositories, so the "repos root" is
this repository's parent directory:

```
<repos root>/
  homeagents-cli/              this repository
  homeagents-core/             LiteLLM, Qdrant, TEI, SearXNG, OpenHands, Firefly MCP
  dify-deployment/
  librechat-deployment/
  paperless-qdrant-ingestion/
```

If your layout differs, pass `-ReposRoot` or set an environment variable:

```powershell
$env:HOMEAGENTS_REPOS_ROOT = 'D:\HomeAgents'
```

## Usage

```
homeagents <stage> <command> [arg]
```

| Stage | Starts |
|---|---|
| `core` | Qdrant, TEI, qdrant-mcp, LiteLLM, Postgres, Redis |
| `websearch` | SearXNG, web-search-mcp |
| `programming` | OpenHands |
| `finance` | Firefly III MCP |
| `chat` | LibreChat |
| `dify` | Dify |
| `document-ingestion` | the Paperless-ngx to Qdrant worker |

The commands are `run`, `stop` and `restart`, with `restart` available for the
programming stage only. `status` lists the running containers of the platform
and of Dify.

```powershell
./homeagents.ps1 core run
./homeagents.ps1 websearch run
./homeagents.ps1 chat run
./homeagents.ps1 programming restart D:\Projects\my-repo
./homeagents.ps1 core stop
```

`run` first makes sure the shared `ai-platform-net` Docker network exists.

## Structure

```
homeagents.ps1        dispatcher: stage + command -> stage script
lib/logging.ps1       Write-Step / Write-Info / Write-Warning output helpers
lib/paths.ps1         resolves the repos root and the per-repository paths
scripts/              one-off helpers (network creation)
stages/<stage>/       one folder per stage name, each with run.ps1 and stop.ps1
```

`stages/document-ingestion/` has only `run.ps1`, because that stage is a one-shot
job with no service to stop.

## How paths resolve

`lib/paths.ps1` derives every path from a single repos root. Order of
precedence:

1. `-ReposRoot` passed to `homeagents.ps1`
2. `$env:HOMEAGENTS_REPOS_ROOT`
3. the parent directory of this repository

Each stage passes the resolved root down to its own script, so the repository
contains no absolute paths.

## Role in the platform

The CLI calls no model. It only starts and stops the stacks that do, so what runs
behind a stage command is described in the `homeagents-core` repository: LiteLLM
for the hosted models, the local embedding service for memory, OpenHands as the
coding agent.

## Notes

* Dify keeps its own `.env` next to its compose file, so its stage does not pass
  `--env-file`. Copy `dify-deployment/.env.example` to `.env` before the first
  run.
* Every other stage runs against the shared `homeagents-core/.env`.
* `restart` is implemented for the programming stage only, because OpenHands
  needs its workspace path set again before the container starts.
