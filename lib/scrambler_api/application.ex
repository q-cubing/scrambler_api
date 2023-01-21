defmodule ScramblerApi.Application do
  @moduledoc false

  require Logger
  use Application
  @port Application.compile_env!(:scrambler_api, :port)

  @impl true
  def start(_type, _args) do
    children =
      [{_, [_, {:plug, plug}, _]}] = [
        {Plug.Cowboy, scheme: :http, plug: ScramblerApi.Router, options: [port: @port]}
      ]

    opts = [strategy: :one_for_one, name: ScramblerApi.Supervisor]

    case Supervisor.start_link(children, opts) do
      {:ok, pid} ->
        Logger.info("#{plug} started at port #{@port}.")
        {:ok, pid}

      {:error, e} ->
        Logger.info("#{plug} failed to start: #{inspect(e)}.")
        {:error, e}
    end
  end
end
