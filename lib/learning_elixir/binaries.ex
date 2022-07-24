defmodule FileSniffer do
  @extensions %{
    "exe" => "application/octet-stream",
    "bmp" => "image/bmp",
    "png" => "image/png",
    "jpg" => "image/jpg",
    "gif" => "image/gif"
  }

  @signatures %{
    "application/octet-stream" => MapSet.new([0x7F, 0x45, 0x4C, 0x46]),
    "image/bmp" => MapSet.new([0x42, 0x4D]),
    "image/png" => MapSet.new([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]),
    "image/jpg" => MapSet.new([0xFF, 0xD8, 0xFF]),
    "image/gif" => MapSet.new([0x47, 0x49, 0x46])
  }

  def type_from_extension(extension), do: @extensions[extension]

  def type_from_binary(<<signature::8, _body::binary>>) do
    @signatures
    |> Map.filter(fn {k,v} -> MapSet.member?(v, signature) end)
    |> get_first_key()
  end

  def verify(file_binary, extension) do
    if(type_from_binary(file_binary) == type_from_extension(extension),
      do: {:ok, type_from_extension(extension)},
      else: {:error, "Warning, file format and file extension do not match."})
  end

  defp get_first_key(map), do: map |> Map.keys() |> List.first()
end
