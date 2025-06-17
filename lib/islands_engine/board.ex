defmodule IslandsEngine.Board do
  alias IslandsEngine.{Coordinate, Island}

  def new, do: %{}

  def position_island(board, key, %Island{} = island) do
    if overlaps_existing_island?(board, key, island) do
      {:error, :overlapping_island}
    else
      Map.put(board, key, island)
    end
  end

  def all_islands_positioned?(board), do: Enum.all?(Island.types(), &Map.has_key?(board, &1))

  def guess(board, %Coordinate{} = coordinate) do
    board
    |> check_all_islands(coordinate)
    |> guess_response(board)
  end

  defp overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn {existing_key, existing_island} ->
      existing_key != new_key and Island.overlaps?(existing_island, new_island)
    end)
  end

  defp check_all_islands(board, coordinate) do
    Enum.find_value(board, :miss, fn {key, island} ->
      case Island.guess(island, coordinate) do
        {:hit, island} -> {key, island}
        :miss -> false
      end
    end)
  end

  defp guess_response({key, island}, board) do
    board = %{board | key => island}
    {:hit, forest_check(board, key), win_check(board), board}
  end

  defp guess_response(:miss, board), do: {:miss, :none, :no_win, board}

  defp forest_check(board, key) do
    if forested?(board, key) do
      key
    else
      :none
    end
  end

  defp forested?(board, key) do
    board
    |> Map.fetch!(key)
    |> Island.forested?()
  end

  defp win_check(board) do
    if all_forested?(board) do
      :win
    else
      :no_win
    end
  end

  defp all_forested?(board), do: Enum.all?(board, fn {_, island} -> Island.forested?(island) end)
end
