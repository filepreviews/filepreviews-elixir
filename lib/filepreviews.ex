defmodule FilePreviews do

  defmodule Config do
    defstruct [:api_key, :api_secret]
  end

  def new(api_key, api_secret) do
    %Config{api_key: api_key, api_secret: api_secret}
    |> new
  end

  def new(config) do
    Agent.start_link(fn -> config end, name: __MODULE__)
  end

  def api_key() do
    config().api_key
  end

  def api_secret() do
    config().api_secret
  end

  def generate(url, params \\ %{}) do
    params = Dict.merge(%{url: url}, params)
    size = Dict.get(params, "size")

    if is_map(size) do
      width = Dict.get(size, "width")
      height = Dict.get(size, "height")
      geometry = ""

      if width do
        geometry = width
      end

      if height do
        geometry = "#{geometry}x#{height}"
      end

      params = Dict.put(params, "sizes", [geometry])
    end

    FilePreviews.Client.post("/previews/", params)
  end

  def retrieve(id) do
    FilePreviews.Client.get("/previews/#{id}/")
  end

  defp config() do
    Agent.get(__MODULE__, fn(state) -> state end)
  end

end
