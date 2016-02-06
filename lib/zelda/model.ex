defmodule Zelda.Model do
  @moduledoc false

  defmodule Ignore do
    @moduledoc """
    Ecto model implementing an ignore record, which is both the slack_id and
    slack_name of the person Zelda should ignore.
    """

    use Ecto.Model
    schema "ignores" do
      field :slack_id,   :string
      field :slack_name, :string
      timestamps
    end
  end
end
