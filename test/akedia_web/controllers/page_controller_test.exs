defmodule AkediaWeb.PageControllerTest do
  use AkediaWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Inhji"
  end
end
