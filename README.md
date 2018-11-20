# Akedia

## Remarks

* Needs Imagemagick installed on the host: `apt install imagemagick`

## Deployment

* `build_essential` must be installed on the target system

build a release:

```
mix edeliver build release
mix edeliver deploy release to production --version=x.x.x
mix edeliver restart production
mix edeliver migrate production
```
