defmodule Derivico do
  @moduledoc """
  Documentation for Derivico.
  """
  require CSV

  def load do
    :ets.new(:data, [:named_table, :set, :public])
    :ets.new(:headers, [:named_table, :set, :public])
    stream = File.stream!("priv/Data.csv") |> CSV.decode!
    stream |> Stream.take(1) |> Stream.each(&(:ets.insert(:headers, :erlang.list_to_tuple(&1))))
    |> Stream.run
    stream |> Stream.drop(1) |> Stream.each(&(:ets.insert(:data, :erlang.list_to_tuple(&1))))
    |> Stream.run
  end

  @spec get_headers :: tuple()
  def get_headers do
    :headers |> :ets.tab2list |> List.first
  end

  @spec get_data :: [tuple]
  def get_data do
    :data |> :ets.tab2list
  end
  # {"", "Div", "Season", "Date", "HomeTeam", "AwayTeam", "FTHG", "FTAG", "FTR", "HTHG", "HTAG", "HTR"}
  @spec get_data(binary(), binary()) :: [tuple()]
  def get_data div, season do
    :ets.match_object :data, {:_, div, season, :_, :_, :_, :_, :_, :_, :_, :_, :_}
  end

end
