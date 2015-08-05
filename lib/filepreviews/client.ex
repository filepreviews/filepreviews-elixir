defmodule FilePreviews.Client do
  @moduledoc false

  use HTTPoison.Base

  @url "https://api.filepreviews.io/v2"
  @headers ["Content-Type": "application/json"]

  def options do
    [
      hackney: [
        basic_auth: {FilePreviews.api_key, FilePreviews.api_secret}
      ]
    ]
  end

  def process_url(url) do
    @url <> url
  end

  def process_request_body(body) when body == "", do: ""
  def process_request_body(body) do
    Enum.into(body, %{})
    |> Poison.encode!
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  def get(url) do
    get(url, @headers, options)
    |> handle_response
  end

  def post(url, body) do
    post(url, body, @headers, options)
    |> handle_response
  end

  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        cond do
          code == 200 ->
            {:ok, body}
          code == 201 ->
            {:ok, body}
          true ->
            {:error, body}
        end
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

end
