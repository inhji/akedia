# Akedia

## Remarks

* Uses an unpublished version of arc_ecto that works with ecto ~3.0

## Deployment

* `build_essential` must be installed on the target system

build a release:

```
mix edeliver build release
mix edeliver deploy release to production --version=x.x.x
mix edeliver restart production
mix edeliver migrate production
```
