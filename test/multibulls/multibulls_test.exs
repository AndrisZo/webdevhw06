defmodule Multibulls.MultibullsTest do
  use ExUnit.Case
  import Multibulls.Game

  def getexample() do
    %{
      guesses: [
        ["player1", [1, 2, 3, 4], 0, 0],
        ["player2", [5, 6, 7, 8], 2, 0],
        ["player3", [1, 6, 2, 9], 1, 0],
        ["player4", [5, 3, 2, 1], 0, 0]
      ],
      secret: [7, 8, 9, 0],
      currentguesses: %{
        "player3" => [7, 8, 9, 0],
        "player4" => [8, 0, 7, 9]
      },
      passed: ["player2", "player1"],
      players: ["player1", "player2", "player3", "player4"],
      winners: [],
      playerswinloss: %{
        "player1" => [1, 18],
        "player2" => [4, 7],
        "player3" => [2, 12],
        "player4" => [5, 10]
      },
      playersready: ["player1", "player2", "player3", "player4"],
      turnnumber: 2,
      setup: false
    }
  end

  def nowinexample() do
    %{
      guesses: [
        ["player1", [1, 2, 3, 4], 0, 0],
        ["player2", [5, 6, 7, 8], 2, 0],
        ["player3", [1, 6, 2, 9], 1, 0],
        ["player4", [5, 3, 2, 1], 0, 0]
      ],
      secret: [7, 8, 9, 0],
      currentguesses: %{
        "player3" => [9, 6, 7, 5],
        "player4" => [8, 0, 7, 9]
      },
      passed: ["player2", "player1"],
      players: ["player1", "player2", "player3", "player4"],
      winners: [],
      playerswinloss: %{
        "player1" => [1, 18],
        "player2" => [4, 7],
        "player3" => [2, 12],
        "player4" => [5, 10]
      },
      playersready: ["player1", "player2", "player3", "player4"],
      turnnumber: 2,
      setup: false
    }
  end

  def setupex() do
    %{
      guesses: [],
      secret: [7, 8, 9, 0],
      currentguesses: %{},
      passed: [],
      players: ["player1", "player2", "player3", "player4"],
      winners: [],
      playerswinloss: %{
        "player1" => [1, 18],
        "player2" => [4, 7],
        "player3" => [2, 12],
        "player4" => [5, 10]
      },
      playersready: ["player1", "player2", "player3"],
      turnnumber: 0,
      setup: true
    }
  end

  def lesspasses() do
    %{
      guesses: [
        ["player1", [1, 2, 3, 4], 0, 0],
        ["player2", [5, 6, 7, 8], 2, 0],
        ["player3", [1, 6, 2, 9], 1, 0],
        ["player4", [5, 3, 2, 1], 0, 0]
      ],
      secret: [7, 8, 9, 0],
      currentguesses: %{
        "player3" => [7, 8, 9, 0],
        "player4" => [8, 0, 7, 9]
      },
      passed: ["player1"],
      players: ["player1", "player2", "player3", "player4"],
      winners: [],
      playerswinloss: %{
        "player1" => [1, 18],
        "player2" => [4, 7],
        "player3" => [2, 12],
        "player4" => [5, 10]
      },
      playersready: ["player1", "player2", "player3", "player4"],
      turnnumber: 2,
      setup: false
    }
  end

  def lessguesses() do
    %{
      guesses: [
        ["player1", [1, 2, 3, 4], 0, 0],
        ["player2", [5, 6, 7, 8], 2, 0],
        ["player3", [1, 6, 2, 9], 1, 0],
        ["player4", [5, 3, 2, 1], 0, 0]
      ],
      secret: [7, 8, 9, 0],
      currentguesses: %{
        "player3" => [7, 8, 9, 0]
      },
      passed: ["player1", "player2"],
      players: ["player1", "player2", "player3", "player4"],
      winners: [],
      playerswinloss: %{
        "player1" => [1, 18],
        "player2" => [4, 7],
        "player3" => [2, 12],
        "player4" => [5, 10]
      },
      playersready: ["player1", "player2", "player3", "player4"],
      turnnumber: 2,
      setup: false
    }
  end

  def playeroneeverywhere do
    %{
      guesses: ["player1", [1, 2, 3, 4], 0, 0],
      secret: [3, 4, 5, 6],
      currentguesses: %{"player1" => [5, 6, 7, 8]},
      passed: ["player1"],
      players: ["player1"],
      winners: ["player1"],
      playerswinloss: %{"player1" => [1, 1]},
      playersready: ["player1"],
      turnumber: 0,
      setup: true
    }
  end
  # This test involves randomness so it must be human verified, so I don't run it every time.
  #test "startnewgame" do
  #  assert false == startnewgame(getexample())
  #end

  test "test make a guess" do
    assert makeguess(getexample(), "player1", [8, 7, 9, 0]).currentguesses ==
    %{
      "player1" => [8, 7, 9, 0],
      "player3" => [7, 8, 9, 0],
      "player4" => [8, 0, 7, 9]
    }

    assert makeguess(getexample(), "player1", [8, 7, 9, 0]).passed == ["player2"]
    assert makeguess(getexample(), "player1", [8, 7, 9, 0]).turnnumber == 2
  end

  test "test is valid guess" do
      assert isValidGuess([1, 2, 3, 4])
      assert not isValidGuess([1, 2, 3])
      assert not isValidGuess([1, 1, 3, 4])
  end

  test "test all players guessed" do
    assert allplayersguessed(getexample())
    assert not allplayersguessed(lessguesses())
    assert not allplayersguessed(lesspasses())
  end

  test "pushguesses" do
    # Someone wins, so the game goes back to setup
    assert %{
      guesses: [
        ["player1", [1, 2, 3, 4], 0, 0],
        ["player2", [5, 6, 7, 8], 2, 0],
        ["player3", [1, 6, 2, 9], 1, 0],
        ["player4", [5, 3, 2, 1], 0, 0],
        ["player4", [8, 0, 7, 9], 0, 4],
        ["player3", [7, 8, 9, 0], 4, 0]
      ],
      secret: [7, 8, 9, 0],
      currentguesses: %{},
      passed: [],
      players: ["player1", "player2", "player3", "player4"],
      winners: ["player3"],
      playerswinloss: %{
        "player1" => [1, 19],
        "player2" => [4, 8],
        "player3" => [3, 12],
        "player4" => [5, 11],
      },
      playersready: [],
      turnnumber: 3,
      setup: true
    } == pushguesses(getexample())

    # None one wins, so the game is just progressed
    assert %{
      guesses: [
        ["player1", [1, 2, 3, 4], 0, 0],
        ["player2", [5, 6, 7, 8], 2, 0],
        ["player3", [1, 6, 2, 9], 1, 0],
        ["player4", [5, 3, 2, 1], 0, 0],
        ["player4", [8, 0, 7, 9], 0, 4],
        ["player3", [9, 6, 7, 5], 0, 2]
      ],
      secret: [7, 8, 9, 0],
      currentguesses: %{},
      passed: [],
      players: ["player1", "player2", "player3", "player4"],
      winners: [],
      playerswinloss: %{
        "player1" => [1, 18],
        "player2" => [4, 7],
        "player3" => [2, 12],
        "player4" => [5, 10],
      },
      playersready: ["player1", "player2", "player3", "player4"],
      turnnumber: 3,
      setup: false
    } == pushguesses(nowinexample())
  end

  test "extractguesses" do
    assert Enum.sort(extractguesses(%{"player3" => [7, 8, 9, 0],"player4" => [8, 0, 7, 9]}))
      == Enum.sort([["player3", [7, 8, 9, 0]], ["player4", [8, 0, 7, 9]]])
  end

  test "test pass" do
    assert getexample() == pass(lesspasses(), "player2")
    assert pass(getexample(), "player3").currentguesses ==
    %{
      "player4" => [8, 0, 7, 9]
    }
    assert Enum.sort(pass(getexample(), "player3").passed) == ["player1", "player2", "player3"]
  end

  test "test addplayer" do
    assert addplayer(setupex(), "player5").playerswinloss ==
    %{
      "player1" => [1, 18],
      "player2" => [4, 7],
      "player3" => [2, 12],
      "player4" => [5, 10],
      "player5" => [0, 0]
    }

    assert Enum.sort(addplayer(setupex(), "player5").players) == ["player1", "player2", "player3", "player4", "player5"]
    assert getexample() == addplayer(getexample(), "player10")
    assert addplayer(setupex(), "player4") == setupex()
    assert Enum.sort(addplayer(setupex(), "player5").players) == ["player1", "player2", "player3", "player4", "player5"]
    assert addplayer(setupex(), "player5").playerswinloss == %{
      "player1" => [1, 18],
      "player2" => [4, 7],
      "player3" => [2, 12],
      "player4" => [5, 10],
      "player5" => [0, 0]
    }

    wplayer5 = Map.put(setupex(), :playerswinloss, Map.put(setupex().playerswinloss, "player5", [1, 9]))

    assert addplayer(wplayer5, "player5").playerswinloss == %{
      "player1" => [1, 18],
      "player2" => [4, 7],
      "player3" => [2, 12],
      "player4" => [5, 10],
      "player5" => [1, 9]
    }

    assert Enum.sort(addplayer(wplayer5, "player5").players) == ["player1", "player2", "player3", "player4", "player5"]
  end

  test "removeplayer" do
    assert  Map.put(new(), :guesses, ["player1", [1, 2, 3, 4], 0, 0])
            |> Map.put(:secret, [3, 4, 5, 6])
            |> Map.put(:playerswinloss, %{"player1" => [1,1]}) ==
              removeplayer(playeroneeverywhere(), "player1")
  end

  test "getwinloss" do
    assert getwinloss(getexample(), "player1") == [1, 18]
    assert getwinloss(getexample(), "player2") == [4, 7]
    assert getwinloss(getexample(), "player3") == [2, 12]
    assert getwinloss(getexample(), "player4") == [5, 10]
  end

  test "readyplayer" do
    assert readyplayer(getexample(), "player4") == getexample()
    assert Enum.sort(readyplayer(setupex(), "player4").playersready) ==
      Enum.sort(["player1", "player2", "player3", "player4"])
  end

  test "unreadyplayer" do
    assert unreadyplayer(getexample(), "player1") == getexample()
    assert unreadyplayer(setupex(), "player1").playersready == ["player2", "player3"]
  end
end
