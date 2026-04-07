# umbrel-hermes-workspace

Umbrel packaging for **Hermes Workspace**, the full browser UI for Hermes.

This repo packages two containers for Umbrel:

- `workspace`
  production build of `outsourc-e/hermes-workspace`
- `hermes-api`
  Hermes backend built from `outsourc-e/hermes-agent`

The canonical install surface remains:

`https://github.com/harmalh/umbrel-community-store`

## Source Configuration

The editable packaging source configuration lives in `versions.json`.

- Hermes Workspace upstream repo/ref are read from that file.
- Hermes Agent is tracked from the configured upstream repo, but the release
  workflow resolves the **latest commit on the upstream default branch at
  release time**.

## Umbrel Topology

```text
Umbrel browser
  -> app_proxy
  -> workspace:3000
  -> HERMES_API_URL=http://hermes-api:8642
  -> hermes-api:8642
```

Hermes runtime state is stored only under `${APP_DATA_DIR}/hermes`.

## Canonical Release Path

The canonical pipeline is:

`.github/workflows/release-to-umbrel-community-store.yml`

That workflow:

1. resolves the latest upstream Hermes Agent commit,
2. builds and pushes both GHCR images,
3. smoke-tests the packaged UI and API,
4. rewrites the digest-pinned image references for the Umbrel app, and
5. publishes the updated app into `harmalh/umbrel-community-store`.

Required secret in this repo:

- `COMMUNITY_STORE_PAT`
  fine-grained token with contents write access to
  `harmalh/umbrel-community-store`

## Optional Image-Only Build

If you want a manual image-only build without publishing to the community store,
use:

`.github/workflows/build-workspace-images.yml`

## Notes

- The old auto-build workflow is deprecated and intentionally no longer used as
  the canonical path.
- The community store release workflow is the source of truth for published
  Umbrel releases.
