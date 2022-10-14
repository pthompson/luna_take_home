defmodule LunaTakeHome.MetaExtractorTest do
  use ExUnit.Case
  alias LunaTakeHome.MetaExtractor

  describe "get_og_image/1" do
    test "success: accepts a valid url with og:image meta property, returns expected content attribute" do
      # This test is fragile, as it depends on a live site that could change. With more time
      # we would probably want a more robust test strategy, such as creating a mock.
      assert {:ok, "https://public-images.getluna.com/images/social/facebook.png"} =
               MetaExtractor.get_og_image("https://www.getluna.com")
    end

    test "error: returns error if page at url does not contain og:image property" do
      # This test is fragile, as it depends on a live site that could change. With more time
      # we would probably want a more robust test strategy, such as creating a mock.
      assert {:error, "document does not contain meta property 'og:image'"} =
               MetaExtractor.get_og_image("https://portland.craigslist.org")
    end

    test "error: returns error if given url points to non-existent site" do
      assert {:error, "could not access url"} =
               MetaExtractor.get_og_image("https://does_not_exist_aasdjfk.com")
    end
  end
end
