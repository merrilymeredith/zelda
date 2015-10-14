Zelda
=====

Zelda is a simple slack bot written in Elixir and based on Slacker.  Its
only function right now is to catch things like "rt:123abc6", as you may
write in commit logs, and reply back with complete links to the given
resource.

Out of the box all it does is handle things like "gh:lhorie/mithril" in chat,
but the most obvious use case is quick links to your team's ticket tracker,
code repositories, CI, and similar tools.

Before it will work, it needs a slack API token to be set in its configuration.
You can set the environment `SLACK_API_TOKEN`

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

This is my first Elixir project beyond small scripts and other toys, so I'm
both trying to get some best-practices down and figuring out some of my own.

- ✓ user name-id map
- ✓ There should be an ignore $user command so people can opt out
- ✓ Ignores should persist, and unignore should work too.
- ✓ use pid arguments instead of global process names so bits can be tested w/o mocking
- Should also just ignore users that are marked as bots, I think
- documentation
- more tests
  - probably a better practice for ecto tests
- Slacker doesn't seem to cover "match my own name" right now, so public commands
  are hard-coded to match `/^zelda:/` to get the bot's attention, no matter what name.


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

