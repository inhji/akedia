# Akedia

## Remarks

* Uses an unpublished version of arc_ecto that works with ecto ~3.0

## Deployment

* `build_essential` must be installed on the target system

build a release:

```
mix edeliver build release
```


```
MIX_ENV=prod mix do phx.digest, release --env=prod
```
