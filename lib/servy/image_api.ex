defmodule Servy.ImageApi do
  def query(url) do
    HTTPoison.get(url)
    |> handle_response
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    image_url =
      body
      |> Poison.Parser.parse!
      |> get_in(["image", "image_url"])

    {:ok, image_url}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: _status, body: body}}) do
    message =
      body
      |> Poison.Parser.parse!
      |> get_in(["message"])

    {:error, message}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end
end
