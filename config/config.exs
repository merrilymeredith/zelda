use Mix.Config

config :zelda, :link_aliases,
  github:  :gh

config :zelda, :link_templates,
  gh:      "https://github.com/<%= @id %>"

if File.exists? "config/link_config.exs" do
  import_config "link_config.exs"
end


config :zelda, :match,
  link:    ~r/\b(([a-z_]+):([\w-\/]+|"[^"]+"))/,
  repeat:  ~r/\b([a-z_]+:!\$)/,
  command: ~r/^zelda:\s*(\w+)\s*(.*)$/


config :zelda,
  slack_token: System.get_env("SLACK_API_TOKEN")

config :zelda, Zelda.Repo,
  adapter:  Sqlite.Ecto

if Mix.env == :test do
  config :zelda, Zelda.Repo, database: ":memory:"
else
  config :zelda, Zelda.Repo, database: "zelda-#{Mix.env}.sqlite"
end

# import_config "#{Mix.env}.exs"
