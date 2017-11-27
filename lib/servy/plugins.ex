defmodule Servy.Plugins do

  alias Servy.Conv
  alias Servy.FourOhFourCounter

  @doc "Logs 404 requests"
  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env != :test do
      IO.puts "Warning: #{path} is on the loose!"
      FourOhFourCounter.bump_count(path)
    end
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    if Mix.env == :dev do
      IO.inspect conv
    end
    conv
  end
end
