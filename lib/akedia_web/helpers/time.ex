defmodule AkediaWeb.Helpers.Time do
  def from_now(date) do
    Timex.from_now(date, "de")
  end

  def iso_date(date) do
    Timex.format!(date, "{ISO:Extended:Z}")
  end
end
