defmodule SmallUrl.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :hash_id, :text
      add :url, :text

      timestamps()
    end

    create index(:links, [:url])
    create index(:links, [:hash_id])
  end
end
