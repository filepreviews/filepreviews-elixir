# FilePreviews.io

Elixir client library and CLI tool for the for the [FilePreviews.io](http://filepreviews.io) service. Generate image previews and metadata from almost any kind of file.

## Installation

```elixir
{:filepreviews, "~> 1.0.0"}
```

## Usage

```elixir
{:ok, filepreviews} = FilePreviews.new("API_KEY", "API_SECRET")
```

### Generate

```elixir
# status is either :ok or :error
# response is a Map converted from the JSON response from FilePreviews.
{status, response} = FilePreviews.generate("http://example.com/file.pdf")
```

#### Options

```elixir
params = %{metadata: ["exif"], pages: "1"}
{status, response} = FilePreviews.generate("http://example.com/file.pdf", params)
```

### Retrieve

```elixir
{status, response} = FilePreviews.generate("42764e04-9094-467c-96b3-49d31ff4423d")
```
