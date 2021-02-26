_ = """
{
  guesses: [
      [Username, [1, 2, 3, 4], bulls, cows],
      [Username, [1, 2, 3, 4], bulls, cows],
      [Username, [1, 2, 3, 4], bulls, cows],
      [Username, [1, 2, 3, 4], bulls, cows]
  ],
  secret: [1, 2, 3, 4],
  currentguesses: {
      username : [currentguess],
      username : [currentguess],
      username : [currentguess],
  }
  passed: [Username, Username],
  winners: [Username, Username],
  playerswinloss: {
      Username : [win, loss],
      Username : [win, loss],
  }
  playersready: [Username, Username]
  turnnumber: integer
  setup: boolean
}

Calls the user can make to the server:
- "makeguess"
- "pass"
- "login"
- "ready-up"
- "ready-down"
- "becomeplayer"
- "becomeobserver"
- "exitgame"
- "joingame"
- "ping"
"""

defmodule Multibulls.Game do
  import Enum

  # Get a new, blank game object
  def new() do
    %{
      guesses: [],
      secret: random_digits(),
      currentguesses: %{},
      passed: [],
      winners: [],
      players: [],
      playerswinloss: %{},
      playersready: [],
      turnumber: 0,
      setup: true
    }
  end

  def view(state) do
    %{
      guesses: state.guesses,
      winners: state.winners,
      playerswinloss: state.playerswinloss,
      playersready: state.playersready,
      setup: state.setup
    }
  end

  def startnewgame(game) do
    game
    |> Map.put(:currentguesses, %{})
    |> Map.put(:guesses, [])
    |> Map.put(:passed, [])
    |> Map.put(:playersready, [])
    |> Map.put(:secret, random_digits())
    |> Map.put(:setup, false)
    |> Map.put(:turnnumber, game.turnnumber + 1)
    |> Map.put(:winners, [])
  end

  # Set the user's current guess to the given guess
  def makeguess(gamestate, name, guess) do
    if isValidGuess(guess) and Enum.member?(gamestate.players, name) do
      gamestate = Map.put(gamestate, :currentguesses, Map.put(gamestate.currentguesses, name, guess))
      Map.put(gamestate, :passed, List.delete(gamestate.passed, name))
    end
  end

  # Is the given guess a list of 4 unique numbers?
  def isValidGuess(guess) do
    Enum.count(guess) == 4 and Enum.count(Enum.uniq(guess)) == 4
  end

  # Have all the players either made a guess or passed?
  def allplayersguessed(gamestate) do
    Enum.sort(Enum.concat(Map.keys(gamestate.currentguesses), gamestate.passed)) == Enum.sort(gamestate.players)
  end

  # Push any guesses that have been made to the list of guesses. Anyone that doesn't have a guess there
  # is assumed to have passed.
  # Clear out the map of current guesses
  # Reset the list of people that have passed
  # If someone won the game, add them to the winners and reset to setup state.
  def pushguesses(gamestate) do
    newguesses = all_cows_bulls(extractguesses(gamestate.currentguesses), gamestate.secret)
    state = gamestate
    |> Map.put(:guesses, Enum.concat(gamestate.guesses, newguesses))
    |> Map.put(:currentguesses, %{})
    |> Map.put(:passed, [])
    |> Map.put(:turnnumber, gamestate.turnnumber + 1)
    winners = anywinners(newguesses)
    if Enum.empty?(winners) do
      state
    else
      state
      |> Map.put(:winners, winners)
      |> Map.put(:setup, true)
      |> Map.put(:playersready, [])
      |> Map.put(:playerswinloss, updatewinloss(gamestate.playerswinloss, winners))
    end
  end

  def updatewinloss(winloss, winners) do
    cond do
      Enum.empty?(winners) -> winloss
      true -> updatewinloss(winloss, Map.keys(winloss), winners)
    end
  end

  def updatewinloss(winloss, winlosskeys, winners) do
    cond do
      Enum.empty?(winlosskeys) -> winloss
      Enum.member?(winners, hd(winlosskeys)) ->
        updatewinloss(Map.put(winloss, hd(winlosskeys), addwin(winloss[hd(winlosskeys)])), tl(winlosskeys), winners)
      true -> updatewinloss(Map.put(winloss, hd(winlosskeys), addloss(winloss[hd(winlosskeys)])), tl(winlosskeys), winners)
    end
  end

  def addwin(entry) do
    [Enum.at(entry, 0) + 1, Enum.at(entry, 1)]
  end

  def addloss(entry) do
    [Enum.at(entry, 0), Enum.at(entry, 1) + 1]
  end

  def anywinners(guesses) do
    Enum.map(Enum.filter(guesses, fn x -> Enum.at(x, 2) == 4 end), fn x -> Enum.at(x, 0) end)
  end

  def extractguesses(currguesses) do
    extractguesshelp(currguesses, Map.keys(currguesses), [])
  end

  def extractguesshelp(currguesses, keys, guesses) do
    if empty?(keys) do
      guesses
    else
      extractguesshelp(currguesses, tl(keys), [[hd(keys), currguesses[hd(keys)]] | guesses])
    end
  end

  # Note that the given player has decided to pass this round
  # If they had guessed, remove that guess
  def pass(gamestate, name) do
    # Pass should ensure that you can't be in the passed list twice
    if Enum.member?(gamestate.players, name) do
      gamestate = Map.put(gamestate, :passed, [name | gamestate.passed])
      Map.put(gamestate, :currentguesses, Map.drop(gamestate.currentguesses, [name]))
    end
  end


  # Change a lot

  # Add a player into the game. If it's not in setup phase, add them as an observer.
  # If it is in setup phase, let them in as a player.
  def addplayer(gamestate, name) do
    cond do
      not gamestate.setup -> gamestate
      Enum.member?(gamestate.players, name) -> gamestate
      Enum.member?(Map.keys(gamestate.playerswinloss), name) -> Map.put(gamestate, :players, [name | gamestate.players])
      true -> gamestate
        |> Map.put(:playerswinloss, Map.put(gamestate.playerswinloss, name, [0, 0]))
        |> Map.put(:players, [name | gamestate.players])
    end
  end

  # Remove a player from the game, either as an observer or player. They won't
  # be in the game anymore, so only the record of their guesses will stay.
  # Push the wins and losses they made in this round to the server?
  def removeplayer(gamestate, name) do
    gamestate
    |> Map.put(:currentguesses, Map.drop(gamestate.currentguesses, [name]))
    |> Map.put(:playersready, List.delete(gamestate.playersready, name))
    |> Map.put(:winners, List.delete(gamestate.winners, name))
    |> Map.put(:passed, List.delete(gamestate.passed, name))
    |> Map.put(:players, List.delete(gamestate.players, name))
  end

  def getwinloss(gamestate, name) do
    gamestate.playerswinloss[name]
  end

  # Set the player to ready, indicating that they're ready for the game to start.
  def readyplayer(gamestate, name) do
    if gamestate.setup and Enum.member?(gamestate.players, name) do
      Map.put(gamestate, :playersready, Enum.dedup([name | gamestate.playersready]))
    else
      gamestate
    end
  end

  # Set the player to not ready, indicating that they're not ready for the game to start.
  def unreadyplayer(gamestate, name) do
    if gamestate.setup and Enum.member?(gamestate.players, name) do
      Map.put(gamestate, :playersready, List.delete(gamestate.playersready, name))
    else
      gamestate
    end
  end

  # Create a random list of 4 digits
  def random_digits() do
    get_digits(4, [], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
  end

  # Helper for random_digits with an accumulator of the secret being built and the remaining uniq numbers
  def get_digits(numdigits, digits, avail) do
    cond do
      numdigits <= 0 -> digits
      numdigits > 0 ->
        {adddigit, newavail} = List.pop_at(avail, :rand.uniform(Enum.count(avail) - 1))
        get_digits(numdigits - 1, [adddigit | digits], newavail)
    end
  end

  # Take a list of guesses and make a list of cows and bulls for the given secret
  def all_cows_bulls(guesses, digits) do
    Enum.map(guesses, fn guess -> Enum.concat(guess, cows_bulls(Enum.at(guess, 1), digits)) end)
  end

  # Takes a guess and gives the number of cows and bulls for the guess
  def cows_bulls(guess, digits) do
    cows_bulls(guess, digits, digits, 0, 0)
  end

  # Helper for cows_bulls with accumulators to keep track of numbers of cows and bulls
  def cows_bulls(guessrem, digitsrem, digits, cows, bulls) do
    cond do
      Enum.empty?(guessrem) -> [bulls, cows]
      hd(guessrem) == hd(digitsrem) -> cows_bulls(tl(guessrem), tl(digitsrem), digits, cows, bulls + 1)
      Enum.member?(digits, hd(guessrem)) -> cows_bulls(tl(guessrem), tl(digitsrem), digits, cows + 1, bulls)
      true -> cows_bulls(tl(guessrem), tl(digitsrem), digits, cows, bulls)
    end
  end
end
