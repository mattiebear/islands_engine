defmodule IslandsEngine.Rules do
  defstruct state: :initialized, player1: :islands_not_set, player2: :islands_not_set

  def new(), do: %__MODULE__{}

  def check(%__MODULE__{state: :initialized} = rules, :add_player) do
    {:ok, %{rules | state: :players_set}}
  end

  def check(%__MODULE__{state: :players_set} = rules, {:position_islands, player}) do
    case Map.fetch!(rules, player) do
      :islands_set -> :error
      :islands_not_set -> {:ok, rules}
    end
  end

  def check(%__MODULE__{state: :players_set} = rules, {:set_islands, player}) do
    rules = Map.put(rules, player, :islands_set)

    if both_players_islands_set?(rules) do
      {:ok, %{rules | state: :player1_turn}}
    else
      {:ok, rules}
    end
  end

  def check(%__MODULE__{state: :player1_turn} = rules, {:guess_coordinate, :player1}) do
    {:ok, %{rules | state: :player2_turn}}
  end

  def check(%__MODULE__{state: :player1_turn} = rules, {:win_check, win_or_not}) do
    case win_or_not do
      :win -> {:ok, %{rules | state: :game_over}}
      :no_win -> {:ok, rules}
    end
  end

  def check(%__MODULE__{state: :player2_turn} = rules, {:guess_coordinate, :player2}) do
    {:ok, %{rules | state: :player1_turn}}
  end

  def check(%__MODULE__{state: :player2_turn} = rules, {:win_check, win_or_not}) do
    case win_or_not do
      :win -> {:ok, %{rules | state: :game_over}}
      :no_win -> {:ok, rules}
    end
  end

  def check(_rules, _event), do: :error

  defp both_players_islands_set?(rules),
    do: rules.player1 == :islands_set && rules.player2 == :islands_set
end
