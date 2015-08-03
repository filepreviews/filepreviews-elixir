# FilePreviews.io

[![build-status-image]][travis]
[![hexpm-version]][hexpm]

Elixir client library and CLI tool for [FilePreviews.io][filepreviews]. Generate image previews and metadata from almost any kind of file.

## TODO

- Implement CLI
- Add docs

## Installation

```elixir
{:filepreviews, "~> 0.0.1"}
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

Check out the [endpoint docs][endpoint_docs] for all available options.

```elixir
params = %{metadata: ["exif"], pages: "1"}
{status, response} = FilePreviews.generate("http://example.com/file.pdf", params)
```

### Retrieve

```elixir
{status, response} = FilePreviews.generate("42764e04-9094-467c-96b3-49d31ff4423d")
```

[build-status-image]: https://travis-ci.org/GetBlimp/filepreviews-elixir.svg?branch=master
[travis]: http://travis-ci.org/GetBlimp/filepreviews-elixir?branch=master
[hexpm-version]: https://img.shields.io/hexpm/v/filepreviews.svg
[hexpm]: https://hex.pm/packages/filepreviews
[filepreviews]: http://filepreviews.io
[endpoint_docs]: http://filepreviews.io/docs/endpoints.html
