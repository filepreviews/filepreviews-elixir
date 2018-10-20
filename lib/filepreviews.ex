defmodule FilePreviews do
  @type status :: :ok | :error
  @type response :: {status, map}

  defmodule Config do
    @type t :: %Config{api_key: binary, api_secret: binary}
    defstruct [:api_key, :api_secret]
  end

  @moduledoc """
  Provides an interface to the [FilePreviews][filepreviews] API.

  For the API's documentation please check [http://filepreviews.io/docs/][docs].

  ## Usage

  ```
  {:ok, filepreviews} = FilePreviews.new("API_KEY", "API_SECRET")
  ```

  ### Generate

  ```
  {status, response} = FilePreviews.generate("http://example.com/file.pdf")
  ```

  Note:
  - `status` is either :ok or :error.
  - `response` is a Map converted from the JSON response from FilePreviews.

  #### Options

  ```
  params = %{metadata: ["exif"], pages: "1"}
  {status, response} = FilePreviews.generate("http://example.com/file.pdf", params)
  ```

  ### Retrieve

  ```
  {status, response} = FilePreviews.generate("42764e04-9094-467c-96b3-49d31ff4423d")
  ```

  [filepreviews]: http://filepreviews.io
  [docs]: http://filepreviews.io/docs/
  """

  @doc """
  Starts FilePreviews process with the given api_key and api_secret.
  """
  @spec new(binary, binary) :: {FilePreviews.status(), pid}
  def new(api_key, api_secret) do
    %Config{api_key: api_key, api_secret: api_secret}
    |> new
  end

  @doc """
  Starts FilePreviews process with the config.
  """
  @spec new(FilePreviews.Config.t()) :: {FilePreviews.status(), pid}
  def new(config) do
    Agent.start_link(fn -> config end, name: __MODULE__)
  end

  @doc """
  Returns the API Key.
  """
  @spec api_key() :: binary
  def api_key() do
    config().api_key
  end

  @doc """
  Returns the API Secret.
  """
  @spec api_secret() :: binary
  def api_secret() do
    config().api_secret
  end

  @doc """
  Generates a preview for a given URL and params.
  """
  @spec generate(binary, map) :: FilePreviews.response()
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

  @doc """
  Retrieves a preview with a given ID.
  """
  @spec retrieve(binary) :: FilePreviews.response()
  def retrieve(id) do
    FilePreviews.Client.get("/previews/#{id}/")
  end

  def version() do
    Mix.Project.config()[:version]
  end

  defp config() do
    Agent.get(__MODULE__, fn state -> state end)
  end
end
