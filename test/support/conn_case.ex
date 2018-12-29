defmodule AkediaWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  import Plug.Test

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias AkediaWeb.Router.Helpers, as: Routes
      import Plug.Test
      import Akedia.UserFixture

      # The default endpoint for testing
      @endpoint AkediaWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Akedia.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Akedia.Repo, {:shared, self()})
    end

    conn =
      Phoenix.ConnTest.build_conn()
      |> init_test_session(%{})

    {:ok, conn: conn}
  end
end
