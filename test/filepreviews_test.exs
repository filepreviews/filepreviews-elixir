defmodule FilePreviewsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    dir = "test/fixtures"
    ExVCR.Config.cassette_library_dir(dir, dir)

    HTTPoison.start()

    {:ok, filepreviews} = FilePreviews.new("API_KEY", "API_SECRET")
    {:ok, [filepreviews: filepreviews]}
  end

  test "stores api_key and api_secret" do
    assert FilePreviews.api_key() == "API_KEY"
    assert FilePreviews.api_secret() == "API_SECRET"
  end

  test "generate" do
    use_cassette "generate", custom: true do
      {status, response} = FilePreviews.generate("http://example.com")

      assert status == :ok

      assert response["url"] ==
               "https://api.filepreviews.io/v2/previews/42764e04-9094-467c-96b3-49d31ff4423d/"

      assert response["status"] == "pending"
    end
  end

  test "generate error" do
    use_cassette "generate_error", custom: true do
      {status, response} = FilePreviews.generate("")

      assert status == :error

      assert response["error"] == %{
               "message" => "This field may not be blank.",
               "param" => "url",
               "type" => "invalid_request_error"
             }
    end
  end

  test "retrieve" do
    use_cassette "retrieve", custom: true do
      {status, response} = FilePreviews.retrieve("9ed9ff9e-a734-4901-9f75-4c229cd83498")

      assert status == :ok

      assert response["url"] ==
               "https://api.filepreviews.io/v2/previews/9ed9ff9e-a734-4901-9f75-4c229cd83498/"

      assert response["status"] == "success"
    end
  end

  test "retrieve error" do
    use_cassette "retrieve_error", custom: true do
      {status, response} = FilePreviews.retrieve("123")

      assert status == :error

      assert response["error"] == %{
               "message" => "There is no preview with ID 123.",
               "param" => "task_id",
               "type" => "invalid_request_error"
             }
    end
  end
end
