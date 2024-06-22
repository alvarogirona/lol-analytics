# LoLAnalytics

## Requirements

- PostgreSQL
- Elixir
- RabbitMQ
- MinIO

A `docker-compose` file is provided to run them locally.

## Environment variables

The followign environment variables are required:

```
export RIOT_API_KEY="{API-KEY}"

export EX_AWS_SECRET_KEY="{SECRET}"
export EX_AWS_ACCESS_KEY="{ACCESS}"
export EX_AWS_ENDPOINT="{HOST}"
export EX_AWS_PORT="{PORT}" # minio defaults to 9000
export DATABASE_URL="ecto://{USERNAME}:{PASSWORD}@{HOST}/lol-analytics"
export SECRET_KEY_BASE="SECRET-KEY"
```

## Running

```
mix deps.get
mix ecto.create && mix ecto.migrate
iex -S mix phx.server
```

## Queueing a player

```
Scrapper.Queues.PlayerQueue.enqueue_puuid("PUUID")
```

The scrapper will retrieve player ranked history, enqueue it's teammates, and store every match in minio.

## Processing

A `Task` to process the matches stored for a patch can be spawned by running:
```
LolAnalytics.MatchesProcessor.process_for_patch "14.12.594.4901"
```

## Web site

A web site is exposed at `localhost:4000`.