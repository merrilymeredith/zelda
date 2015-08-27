defmodule Zelda.Model do
  defmodule Ignore do
    use Ecto.Model
    schema "ignores" do
      field :slack_id,   :string
      field :slack_name, :string
      timestamps
    end
  end
end
