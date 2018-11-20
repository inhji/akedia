defmodule AkediaWeb.MentionControllerTest do
  use AkediaWeb.ConnCase

  alias Akedia.Mentions

  @create_attrs %{
    source_url: "some source_url",
    target_url: "some target_url"
  }
  @update_attrs %{
    source_url: "some updated source_url",
    target_url: "some updated target_url"
  }
  @invalid_attrs %{
    source_url: nil,
    target_url: nil
  }

  def fixture(:mention) do
    {:ok, mention} = Mentions.create_mention(@create_attrs)
    mention
  end

  describe "create mention" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.mention_path(conn, :create), mention: @create_attrs)
      assert response(conn, 400) =~ "This is not the host"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.mention_path(conn, :create), mention: @invalid_attrs)
      assert response(conn, 400) =~ "This is not the host"
    end
  end
end
