Zelda
=====

Zelda is a simple slack bot written in Elixir and based on Slacker.  Its
primary purpose is to catch things like "zr:123abc6" and reply back with
complete links to the appropriate service.

Before it will work, it needs a slack API token to be set in its configuration.
If you test with a personal key and put that in `config/dev.exs`, the file is
already gitignored to keep your token safe.

  $ mix deps.get
  $ mix run


