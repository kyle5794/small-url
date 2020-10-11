defimpl Jason.Encoder, for: SmallUrl.Links.Link do
  def encode(struct, opts) do
    Jason.Encode.map(Map.take(struct, [:id, :hash_id, :url]), opts)
  end
end
