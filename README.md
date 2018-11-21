# Akedia

## Deployment

* Dependencies on the target system:
  * `build_essential`
  * `imagemagick`

build a release:

```
mix edeliver build release
mix edeliver deploy release to production --version=x.x.x
mix edeliver restart production
mix edeliver migrate production
```
