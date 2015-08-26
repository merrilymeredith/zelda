Zelda
=====

Zelda is a simple slack bot written in Elixir and based on Slacker.  Its
primary purpose is to catch things like "zr:123abc6" and reply back with
complete links to the appropriate service.

Before it will work, it needs a slack API token to be set in its configuration.
You can set the environment `$SLACK_API_TOKEN`

  $ mix deps.get
  $ mix run

TODO
----

- There should be an ignore $user command so people can opt out
- Should also just ignore users that are marked as bots
- The simple interface provided by Slacker doesn't easily expose a way to look
  up user and channel names from their IDs
- Ignores should persist, and unignore should work too.

