Mix.Task.run "ecto.migrate", ["--quiet"]
ExUnit.start()
