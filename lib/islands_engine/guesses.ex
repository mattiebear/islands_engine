defmodule IslandsEngine.Guesses do
  alias IslandsEngine.Coordinate

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  def new do
    %__MODULE__{hits: MapSet.new(), misses: MapSet.new()}
  end

  def add(%__MODULE__{} = guesses, :hit, %Coordinate{} = coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  end

  def add(%__MODULE__{} = guesses, :miss, %Coordinate{} = coordinate) do
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
  end
end
