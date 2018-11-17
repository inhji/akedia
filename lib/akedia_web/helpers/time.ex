defmodule AkediaWeb.Helpers.Time do
  def from_now(date) do
    Timex.from_now(date, "de")
  end
end
