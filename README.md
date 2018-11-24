# Akedia

## Deployment

* Dependencies on the target system:
  * `build_essential`
  * `imagemagick`

Nginx needs to be configured to alias requests to `/upload` to the uploads dir:

```
location /uploads {
    alias <APP_DIR>/release/akedia/uploads;
}
```


build a release:

```
mix edeliver build release
mix edeliver deploy release to production --version=x.x.x
mix edeliver restart production
mix edeliver migrate production
```
