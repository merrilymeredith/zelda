ExUnit.start()

Mix.Task.run "ecto.migrate", ["--quiet"]
