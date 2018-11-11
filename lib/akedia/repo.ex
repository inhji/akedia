defmodule Akedia.Repo do
  use Ecto.Repo,
    otp_app: :akedia,
    adapter: Ecto.Adapters.MySQL
end
