defmodule AkediaWeb.UserView do
  use AkediaWeb, :view

  def totp_url(secret) do
    issuer = "Inhji.de"
    label = "inhji"

    "otpauth://totp/#{label}?secret=#{secret}&issuer=#{issuer}"
  end
end
