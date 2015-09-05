Zelda
=====

Zelda is a simple slack bot written in Elixir and based on Slacker.  Its
primary purpose is to catch things like "blah:123abc6" and reply back with
complete links to the appropriate service.

Before it will work, it needs a slack API token to be set in its configuration.
You can set the environment `$SLACK_API_TOKEN`

    $ mix deps.get
    $ mix run

Only one default link type is enabled, github.  In my case, we have a pile but
there's no point in sharing those links with the public.  To add more, instead
of editing `config.exs` itself, create `config/link_config.exs` like so:

    use Mix.Config

    config :zelda, :link_aliases,
      bitbucket:  :hg

    config :zelda, :link_templates,
      hg:   "https://bitbucket.org/<%= @id %>",
      xkcd: "http://xkcd.com/<%= @id %>/"

These keys will then be merged with the default config.


TODO
----

x There should be an ignore $user command so people can opt out
- Should also just ignore users that are marked as bots, I think
~ The simple interface provided by Slacker doesn't easily expose a way to look
  up user and channel names from their IDs
  x user name-id map
x Ignores should persist, and unignore should work too.
- If a message handler in the Slack process crashes it, slack replays the message every restart
  x made link happen in a different process, which sortof avoids this
- documentation
- tests, how to make interconnected bits easier to test


LICENSE
-------

(aka MIT License)

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

