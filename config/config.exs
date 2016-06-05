use Mix.Config

config :zelda, :link_aliases,
  github:     :gh,
  bitbucket:  :bb,
  google:     :gg,
  duckduckgo: :ddg

config :zelda, :link_templates,
  gh:  "https://github.com/<%= @id %>",
  bb:  "https://bitbucket.org/<%= @id %>",
  gg:  "https://google.com/?q=<%= @id %>",
  ddg: "https://duckduckgo.com/?q=<%= @id %>"

if File.exists? "config/link_config.exs" do
  import_config "link_config.exs"
end


config :zelda, :match,
  link:    ~r/\b(([a-z_]+):([\w-\/]+|<[^>]+>))/,
  repeat:  ~r/\b([a-z_]+:!\$)/,
  command: ~r/^zelda:\s*(\w+)\s*(.*)$/

# config :zelda,
#   slack_token: "a slack token"

config :zelda, Zelda.Repo,
  adapter: Sqlite.Ecto

if Mix.env == :prod do
  config :zelda, Zelda.Repo, database: "zelda-#{Mix.env}.sqlite"
  config :zelda, :users_module, Zelda.Users.Slack
  config :zelda, :slack_module, Zelda.Slack.Live
else
  config :zelda, Zelda.Repo, database: ":memory:"
  config :zelda, :users_module, Zelda.Users.Test
  config :zelda, :slack_module, Zelda.Slack.Test
  config :zelda, :slack_token, 'nada'
end

if File.exists? "#{Mix.env}.exs" do
  import_config "#{Mix.env}.exs"
end
