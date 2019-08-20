defmodule Derivico do
  @moduledoc """
  Documentation for Derivico.
  """

  def load do
    table = :ets.new(:data, [:named_table, :set, :public])
    File.stream!("priv/Data.csv") |> CSV.decode! |> Stream.drop(1)  
    |> Stream.each(&(:ets.insert(table, :erlang.list_to_tuple(&1)))) 
    |> Stream.run
  end
end
