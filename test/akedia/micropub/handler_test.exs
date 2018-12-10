defmodule Akedia.Micropub.HandlerTest do
  use Akedia.DataCase

  describe "micropub_handler" do
    alias Akedia.Micropub.Handler

    test "get_post_id/1 extracts the post id from a url" do
      assert Handler.get_post_id("https://inhji.de/posts/1") == 1
    end

    test "check_scope/2 checks the list of currently supported scopes" do
      assert Handler.check_scope("create update", "destroy_world") ==
               {:error, :insufficient_scope}
    end

    test "check_scope/2 checks if required scope is included in supplied scopes" do
      assert Handler.check_scope("create update", "create") == :ok
    end
  end
end
