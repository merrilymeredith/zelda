use Mix.Config

config :zelda,
  match: %{
    link:    ~r/\b(([a-z_]+):([\w-]+))\b/,
    repeat:  ~r/\b([a-z_]+:!\$)/,
    command: ~r/^zelda:\s*(\w+)\s*(.*)$/,
  }

config :zelda,
  slack_token: System.get_env("SLACK_API_TOKEN")

config :zelda, Zelda.Repo,
  adapter:  Sqlite.Ecto,
  database: "zelda-#{Mix.env}.sqlite"

# import_config "#{Mix.env}.exs"
