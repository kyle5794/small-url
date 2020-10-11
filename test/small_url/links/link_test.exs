defmodule SmallUrl.Links.LinkTest do
	use SmallUrl.DataCase

	alias SmallUrl.Links.Link

	test "changeset validate url" do
		params = %{url: "omegalulz"}
		%{errors: err, valid?: false} = Link.changeset(%Link{}, params)
		assert Keyword.get(err, :url) == {"missing scheme", []}
	end

	test "generate url success" do
		{:ok, link} = Link.new("https://www.twitch.tv/riotgames", 10)

		assert link.url == "https://www.twitch.tv/riotgames"
		assert byte_size(link.hash_id) == 10

		assert Repo.get!(Link, link.id).hash_id == link.hash_id
	end

	test "delete link by id success" do
		{:ok, link} = Link.new("https://www.twitch.tv/riotgames", 10)

		assert link.url == "https://www.twitch.tv/riotgames"
		assert byte_size(link.hash_id) == 10

		assert Repo.get!(Link, link.id).hash_id == link.hash_id

		{:ok, _} =  Link.delete(link.id)

		assert Repo.get(Link, link.id) == nil
	end

	test "delete non-existent link " do
		assert_raise Ecto.StaleEntryError, fn -> 
			Link.delete(Ecto.UUID.generate())
		end
	end

	test "get by hash_id success" do
		{:ok, link} = Link.new("https://www.twitch.tv/riotgames", 10)
		assert Link.get_by_hash_id!(link.hash_id).id == link.id
	end

	test "get by hash_id failed" do
		assert_raise Ecto.NoResultsError, fn -> 
			Link.get_by_hash_id!("omegalulz")
		end
	end

	test "get by url success" do
		{:ok, link} = Link.new("https://www.twitch.tv/riotgames", 10)
		assert Link.get_by_url!(link.url).id == link.id
	end

	test "get by url failed" do
		assert_raise Ecto.NoResultsError, fn -> 
			Link.get_by_url!("omegalulz")
		end
	end
end