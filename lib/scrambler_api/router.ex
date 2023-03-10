defmodule ScramblerApi.Router do
  require Logger
  use Plug.Router

  @dir Application.compile_env!(:scrambler_api, :working_dir)
  @root Application.compile_env!(:scrambler_api, :serve_at)

  plug(Plug.Static,
    at: @root,
    from: @dir
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    Logger.debug("[200] GET #{URI.decode(conn.request_path)}index.html")

    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, "#{@dir}/index.html")
  end

  get "/s/:type" when type in ["2x2", "3x3", "4x4", "5x5", "6x6", "7x7", "3x3x2"] do
    scramble =
      Scrambler.gen_scramble(type)
      |> Enum.join(" ")

    Logger.debug("[200] GET #{URI.decode(conn.request_path)}: #{scramble}")

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, scramble)
  end

  get "/i/:type/:scramble" when type in ["2x2", "3x3", "4x4", "3x3x2"] do
    cube =
      scramble
      |> String.split()
      |> Enum.map(&String.to_atom/1)
      |> Cubes.apply(Cubes.cube(type))

    json =
      Cubes.Colors.as_map(cube)
      |> Enum.reduce(%{}, fn {k, v}, acc ->
        Map.merge(
          acc,
          %{
            k =>
              case v do
                "yellow" -> "#FFEE09"
                "orange" -> "#FF8800"
                "green" -> "#00AA55"
                "red" -> "#DD3322"
                "blue" -> "#0099DD"
                "white" -> "#FFFFFF"
              end
          }
        )
      end)
      |> Jason.encode!()

    Logger.debug("[200] GET #{URI.decode(conn.request_path)}:\n#{json}")

    conn
    |> put_resp_content_type("text/json")
    |> send_resp(200, json)
  end

  match _ do
    Logger.debug("[404] GET #{URI.decode(conn.request_path)}")

    send_resp(conn, 404, "404")
  end
end
