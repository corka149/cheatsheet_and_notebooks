![Elixir](https://elixir-lang.org/images/logo/logo.png)

# How to put a phoenix project into a Docker container

Wanna see it in action? Here an example: [Jarvis with Docker and docker-compose](https://github.com/corka149/jarvis)

All the following things aim to build a Docker image for the  <b>prod</B> profile. So the following steps will all consider only the <b>prod</B> profile of the phoenix application. But I think, all steps should also be applicable to the dev profile or any other.

## 1. Config preparation

Changed config/prod.exs from
```Elixir
config :jarvis, JarvisWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"
```
to
```Elixir
config :jarvis, JarvisWeb.Endpoint,
  http: [:inet6, port: "${PORT}"],
  url: [host: "localhost", port: "${PORT}"], # This is critical for ensuring web-sockets properly authorize.
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: ".",
  version: Application.spec(:jarvis, :vsn)
```
Also uncomment the following line:
```Elixir
config :phoenix, :serve_endpoints, true
```

## 2. Environment variables

Extract them were needed. Example:
```Elixir
config :jarvis, Jarvis.Repo,
  username: "postgres",
  password: "secret",
  database: "jarvis_prod",
  hostname: "postgres",
  pool_size: 15
```
becomes
```Elixir
config :jarvis, Jarvis.Repo,
  username: "${DB_USERNAME}",
  password: "${DB_PASSWORD}",
  database: "${DB_NAME}",
  hostname: "${DB_HOST}",
  pool_size: 15
```

## 3. Distillery

It will build release versions of the project without mix and handles the environment variables. Add the distillery dependency to mix.exs. [hex.pm/distillery](https://hex.pm/packages/distillery)

./mix.exs
```Elixir
  defp deps do
    [
      ...,
      {:distillery, "~> 2.0"}
    ]
```

And run
```
mix release.init
```

This will create a bunch of config files.

[Distillery cli documentation](https://hexdocs.pm/distillery/tooling/cli.html)

## 4. Dockerfile

Create a new Dockerfile. I think the base image is not ideal yet.
```Dockerfile
FROM elixir
LABEL maintainer="corka149 <corka149@mailbox.org>"

ARG JARVIS_VERSION

ADD ./_build/prod/rel/jarvis/releases/$JARVIS_VERSION/jarvis.tar.gz /app

ENTRYPOINT ["app/bin/jarvis"]
CMD ["foreground"]
```

## [OPTIONAL] Add additional app event hooks

Why? This can be used to run "mix ecto.migrate"

### Create task
Create or add to file lib/release_tasks.ex
```Elixir
defmodule Jarvis.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:jarvis)

    path = Application.app_dir(:jarvis, "priv/repo/migrations")
    Ecto.Migrator.run(Jarvis.Repo, path, :up, all: true)
  end
end
```

### Example script for event "post_start"
Create a script in rel/hooks/post_start/migrate.sh (or use another script name)
```sh
set +e

while true; do  
  nodetool ping
  EXIT_CODE=$?
  if [ $EXIT_CODE -eq 0 ]; then
    echo "Application is up!"
    break
  fi
done

set -e

echo "Running migrations"  
bin/jarvis rpc "Elixir.Jarvis.Tasks.migrate"
echo "Migrations run successfully" 
```

### Add directory for event "post_start
This must be added to rel/config.exs.
```Elixir
environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"eP<7~RP!h:os:rQ@&L%$qCT85xc;0U&njd_Xh9{[1B(X/j?1.LN(lz~fvo;@4]KE"
  set vm_args: "rel/vm.args"
end
```
becomes
```Elixir
environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"eP<7~RP!h:os:rQ@&L%$qCT85xc;0U&njd_Xh9{[1B(X/j?1.LN(lz~fvo;@4]KE"
  set vm_args: "rel/vm.args"
  set post_start_hooks: "rel/hooks/post_start"
end
```

## 5. Build everything

Build frontend stuff with npm and afterwards a distillery prod release
```sh
npm run deploy --prefix assets && MIX_ENV=prod REPLACE_OS_VARS=true mix do phx.digest, release --env=prod
```
Build a docker image with a build arg for the version. This version must match with the number from the mix.exs.
```sh
docker build -t jarvis:0.5.0 --build-arg VERSION=0.5.0 .
```

# Links

Here some links where I read all this things.

 * https://hexdocs.pm/distillery/guides/phoenix_walkthrough.html
 * http://sgeos.github.io/phoenix/elixir/erlang/ecto/distillery/postgresql/mysql/2016/09/18/storing-elixir-release-configuration-in-environment-variables-with-distillery.html
 * https://blog.leif.io/deploying-elixir-with-docker-part-2/