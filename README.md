# umbrel-hermes-workspace

Umbrel packaging for **Hermes Workspace**, the full browser UI for Hermes.

This repo packages two containers for Umbrel:

- `workspace`
  production build of `outsourc-e/hermes-workspace`
- `hermes-api`
  Hermes backend built from `outsourc-e/hermes-agent`

The canonical install surface remains:

`https://github.com/harmalh/umbrel-community-store`

## Source Pins

- Hermes Workspace upstream:
  `outsourc-e/hermes-workspace@f8380b55c78a4179b72a97f59c6022c2e2fc77fc`
- Hermes API upstream:
  `outsourc-e/hermes-agent@bd412640a6f76c57f2a97389fba24a7541595831`

## Umbrel Topology

```text
Umbrel browser
  -> app_proxy
  -> workspace:3000
  -> HERMES_API_URL=http://hermes-api:8642
  -> hermes-api:8642
```

Hermes runtime state is stored only under `${APP_DATA_DIR}/hermes`.

## Build And Publish

Use `.github/workflows/build-workspace-images.yml` to build and optionally push:

- `ghcr.io/harmalh/hermes-workspace-ui-umbrel`
- `ghcr.io/harmalh/hermes-workspace-api-umbrel`

After pushing, replace the tag-only image references in `app/docker-compose.yml`
with digest-pinned references before releasing.

## Release To Community Store

Copy `app/` into:

`umbrel-community-store/harmalh-hermes-workspace/`

This repo keeps the app id prefixed already, so the compose and manifest copies
can stay identical when you sync them to the store.

## Validation Scope

CI validates YAML and workflows. The build workflow also includes amd64 smoke
tests for:

- Hermes API listening on port `8642`
- Hermes Workspace serving HTTP on port `3000`
