defmodule Akedia.MixProject do
  use Mix.Project

  def project do
    [
      app: :akedia,
      version: "0.7.7",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Akedia.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :scrivener_ecto,
        :scrivener_html
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:mariaex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:comeonin, "~> 5.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:timex, "~> 3.4"},
      {:earmark, "~> 1.3"},
      {:exgravatar, "~> 2.0"},
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.1"},
      {:webmentions, "~> 0.3.4"},
      {:distillery, "~> 2.0"},
      {:edeliver, "~> 1.6"},
      {:atomex, "~> 0.3.0"},
      {:microformats2, "~> 0.2.0"},
      {:scrivener_ecto, "~> 2.0"},
      {:scrivener_html, git: "https://github.com/hlongvu/scrivener_html.git"},
      {:plug_micropub, "~> 0.1.0"},
      {:httpoison, "~> 0.11"},
      {:floki, "~> 0.15"},
      {:phoenix_active_link, "~> 0.2.1"},
      {:totpex, "~> 0.1.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      build: ["edeliver build release"]
    ]
  end
end
