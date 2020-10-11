defmodule SmallUrlWeb.LinkController do
  use SmallUrlWeb, :controller

  alias SmallUrl.Links.Link

  def create(conn, %{"url" => url, "length" => length}) do
    with {:ok, %Link{} = link} <- Link.new(url, length) do
      send_resp(conn, :created, Jason.encode!(link))
    end
  end

  def index(conn, _params), do: send_resp(conn, :ok, Jason.encode!(Link.list()))

  def show(conn, %{"id" => id}) do
    send_resp(conn, :ok, Jason.encode!(Link.get!(id)))
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, _} <- Link.delete(id) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_and_redirect(conn, %{"hash_id" => hash_id}) do
    url =
      hash_id
      |> Link.get_by_hash_id!()
      |> Map.get(:url)

    redirect(conn, external: url)
  end
end
