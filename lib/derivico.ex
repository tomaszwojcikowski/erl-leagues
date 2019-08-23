defmodule Derivico do
  @moduledoc """
  Documentation for Derivico.
  """
  require CSV
  require Logger

  def load_data(path) do
    :ets.new(:data, [:named_table, :set, :public])
    :ets.new(:headers, [:named_table, :set, :public])

    case File.stat(path) do
      {:ok, _} ->
        do_load(path)
        :ok

      {:error, error} ->
        Logger.error("data file not found #{inspect(path)}")
        {:error, error, path}
    end
  end

  defp do_load(path) do
    stream = File.stream!(path) |> CSV.decode!()

    # save headers in ets
    stream
    |> Stream.take(1)
    |> Stream.each(&:ets.insert(:headers, :erlang.list_to_tuple(&1)))
    |> Stream.run()

    # load data into ets
    stream
    |> Stream.drop(1)
    |> Stream.each(&:ets.insert(:data, :erlang.list_to_tuple(&1)))
    |> Stream.run()
  end

  @spec get_headers :: tuple()
  def get_headers do
    :headers |> :ets.tab2list() |> List.first()
  end

  @spec get_data :: [map]
  def get_data do
    :data |> :ets.tab2list() |> to_map
  end

  # Headers: {"", "Div", "Season", "Date", "HomeTeam", "AwayTeam", "FTHG", "FTAG", "FTR", "HTHG", "HTAG", "HTR"}
  @spec get_data(binary, binary) :: [map]
  def get_data(div, season) do
    d = :ets.match_object(:data, {:_, div, season, :_, :_, :_, :_, :_, :_, :_, :_, :_})

    case d do
      [] ->
        []

      _ ->
        to_map(d)
    end
  end

  @spec to_map([tuple]) :: [map]
  def to_map(results) do
    h = get_headers() |> :erlang.tuple_to_list()

    results
    |> Enum.map(fn tuple ->
      [h, :erlang.tuple_to_list(tuple)] |> List.zip() |> Map.new()
    end)
  end
end
