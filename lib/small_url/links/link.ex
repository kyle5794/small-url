defmodule SmallUrl.Links.Link do
	import Ecto.Changeset

	use Ecto.Schema
	@primary_key {:id, :binary_id, autogenerate: true}


	alias __MODULE__
	alias SmallUrl.Repo

	schema "links" do
		field :hash_id, :string
		field :url, :string

		timestamps()
	end

	def changeset(link, params \\ %{}) do
		link
		|> cast(params, [:url])
		|> validate_url(:url)
	end

	def validate_url(changeset, field, options \\ []) do
		validate_change(changeset, field, fn _, url ->
			err = case URI.parse(url) do
				%URI{scheme: nil} -> "missing scheme"
				%URI{host: nil} -> "missing host"
				%URI{host: host} ->
					case :inet.gethostbyname(Kernel.to_charlist(host)) do
						{:ok, _} -> nil
						{:error, _} -> "invalid host"
					end
			end

			case err do
				nil -> []
				e -> [{field, options[:message] || e}]
			end
		end)
	end

	def new(url, length) do
		length = length || 10
		<<hash_id::binary-size(length), _::binary>> =
			length
			|> :crypto.strong_rand_bytes()
			|> Base.url_encode64()

		%Link{hash_id: hash_id}
		|> changeset(%{url: url})
		|> Repo.insert()
	end

	def delete(id) when is_binary(id), do: delete(%Link{id: id})
	def delete(%Link{}=link), do: Repo.delete(link)

	def list(), do: Repo.all(Link)
	def get!(id), do: Repo.get!(Link, id)
	def get_by_hash_id!(hash_id), do: Repo.get_by!(Link, hash_id: hash_id)
	def get_by_url!(url), do: Repo.get_by!(Link, url: url)
end