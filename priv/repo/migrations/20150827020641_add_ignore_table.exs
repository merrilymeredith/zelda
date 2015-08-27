defmodule Zelda.Repo.Migrations.AddIgnoreTable do
  use Ecto.Migration

  def up do
    create table(:ignores) do
      add :slack_id,   :string, null: false
      add :slack_name, :string, null: false
      timestamps
    end
    create index(:ignores, [:slack_id])
    create index(:ignores, [:slack_name])
  end

  def down do
    drop index(:ignores, [:slack_name])
    drop index(:ignores, [:slack_id])
    drop table(:ignores)
  end
end
