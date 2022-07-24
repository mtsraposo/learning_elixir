defmodule BasketballWebsite do
  def extract_from_path(nil, _path), do: nil
  def extract_from_path(data, [head | tail]), do: extract_from_path(data[head], tail)
  def extract_from_path(data, []), do: data
  def extract_from_path(data, path), do: extract_from_path(data, String.split(path, "."))

  def get_in_path(data, path), do: get_in(data, String.split(path, "."))
end
