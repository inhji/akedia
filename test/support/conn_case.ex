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

  # setup_all do
  #   :ok = Ecto.Adapters.SQL.Sandbox.checkout(Akedia.Repo)
  #   # we are setting :auto here so that the data persists for all tests,
  #   # normally (with :shared mode) every process runs in a transaction
  #   # and rolls back when it exits. setup_all runs in a distinct process
  #   # from each test so the data doesn't exist for each test.
  #   Ecto.Adapters.SQL.Sandbox.mode(Akedia.Repo, :auto)
  #
  #   {:ok, user} =
  #     Akedia.Accounts.create_user(%{
  #       encrypted_password: "some encrypted_password",
  #       username: "some username"
  #     })
  #
  #   on_exit(fn ->
  #     # this callback needs to checkout its own connection since it
  #     # runs in its own process
  #     :ok = Ecto.Adapters.SQL.Sandbox.checkout(Akedia.Repo)
  #     Ecto.Adapters.SQL.Sandbox.mode(Akedia.Repo, :auto)
  #
  #     # we also need to re-fetch the %Tenant struct since Ecto otherwise
  #     # complains it's "stale"
  #
  #     user = Akedia.Accounts.get_user!(user.id)
  #     Akedia.Accounts.delete_user(user)
  #     # Akedia.Repo.delete_all(Akedia.Accounts.User)
  #
  #     :ok
  #   end)
  #
  #   [user: user]
  # end

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
