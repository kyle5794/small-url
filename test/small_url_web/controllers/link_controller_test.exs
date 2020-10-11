defmodule SmallUrlWeb.LinkControllerTest do
  use SmallUrlWeb.ConnCase

  alias SmallUrl.Repo
  alias SmallUrl.Links.Link

  test "create link", %{conn: conn} do
    conn = post(conn, "/api/links", %{"url" => "https://www.twitch.tv/riotgames", "length" => 15})
    assert conn.status == 201
    body = Jason.decode!(conn.resp_body, keys: :atoms)
    assert body.url == "https://www.twitch.tv/riotgames"
    assert byte_size(body.hash_id) == 15

    link = Repo.get!(Link, body.id)
    assert link.url == "https://www.twitch.tv/riotgames"
    assert link.hash_id == body.hash_id
  end

  test "delete link", %{conn: conn} do
    {:ok, link} = Repo.insert(%Link{url: "https://www.twitch.tv/riotgames", hash_id: "omegalulz"})

    conn = delete(conn, "/api/links/#{link.id}")
    assert conn.status == 204

    assert_raise Ecto.NoResultsError, fn ->
      Repo.get!(Link, link.id)
    end
  end

  test "list links", %{conn: conn} do
    {:ok, l1} = Repo.insert(%Link{url: "https://www.twitch.tv/riotgames", hash_id: "omegalulz"})
    {:ok, l2} = Repo.insert(%Link{url: "https://www.twitch.tv/riotgames", hash_id: "omegalulz"})

    conn = get(conn, "/api/links")
    assert conn.status == 200
    [b1, b2] = Jason.decode!(conn.resp_body, keys: :atoms)
    assert Enum.sort([b1.id, b2.id]) == Enum.sort([l1.id, l2.id])
  end

  test "get link by id", %{conn: conn} do
    {:ok, _l1} = Repo.insert(%Link{url: "https://www.twitch.tv/riotgames", hash_id: "omegalulz"})
    {:ok, l2} = Repo.insert(%Link{url: "https://www.twitch.tv/riotgames", hash_id: "omegalulz"})

    conn = get(conn, "/api/links/#{l2.id}")
    assert conn.status == 200
    b1 = Jason.decode!(conn.resp_body, keys: :atoms)
    assert b1.hash_id == l2.hash_id
    assert b1.url == l2.url
  end
end
