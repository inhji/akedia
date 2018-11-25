defmodule Akedia.Repo do
  use Ecto.Repo,
    otp_app: :akedia,
    adapter: Ecto.Adapters.MySQL

  use Scrivener,
    page_size: 10
end
