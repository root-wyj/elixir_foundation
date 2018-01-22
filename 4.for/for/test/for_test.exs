defmodule ForTest do
  use ExUnit.Case
  doctest For

  test "basic for comprehensions" do
    result = for i <- [1,2,3], do: i
    assert [1,2,3] == result
  end

  test "collecting results into a map" do
    result = 
      for i <- 0..2, into: %{} do
        # 返回的是个2元祖类型，包装了key-value
        {"#{i}", i}
      end

      assert result == %{"0" => 0, "1" => 1, "2" => 2}
  end


    test "generating a deck of cards" do
      suits = [:clubs, :diamonds, :hearts, :spades]
      ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  
      # I'll paste in the list of all cards, to compare against
      all_cards =
        [
          {2, :clubs},
          {3, :clubs},
          {4, :clubs},
          {5, :clubs},
          {6, :clubs},
          {7, :clubs},
          {8, :clubs},
          {9, :clubs},
          {10, :clubs},
          {:jack, :clubs},
          {:queen, :clubs},
          {:king, :clubs},
          {:ace, :clubs},
          {2, :diamonds},
          {3, :diamonds},
          {4, :diamonds},
          {5, :diamonds},
          {6, :diamonds},
          {7, :diamonds},
          {8, :diamonds},
          {9, :diamonds},
          {10, :diamonds},
          {:jack, :diamonds},
          {:queen, :diamonds},
          {:king, :diamonds},
          {:ace, :diamonds},
          {2, :hearts},
          {3, :hearts},
          {4, :hearts},
          {5, :hearts},
          {6, :hearts},
          {7, :hearts},
          {8, :hearts},
          {9, :hearts},
          {10, :hearts},
          {:jack, :hearts},
          {:queen, :hearts},
          {:king, :hearts},
          {:ace, :hearts},
          {2, :spades},
          {3, :spades},
          {4, :spades},
          {5, :spades},
          {6, :spades},
          {7, :spades},
          {8, :spades},
          {9, :spades},
          {10, :spades},
          {:jack, :spades},
          {:queen, :spades},
          {:king, :spades},
          {:ace, :spades}
        ]
  
      # Then we use a for comprehension to combine the suits and ranks
      result =
        for suit <- suits,
            rank <- ranks,
            do: {rank, suit}
  
      assert all_cards == result
    end
end
