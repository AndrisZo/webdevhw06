defmodule Multibulls.GameServer do
  use GenServer

  alias Multibulls.BackupAgent
  alias Multibulls.Game

  # public interface

  def reg(name) do
    {:via, Registry, {Multibulls.GameReg, name}}
  end

  def start(name) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]},
      restart: :permanent,
      type: :worker
    }
    Multibulls.GameSup.start_child(spec)
  end

  def start_link(name) do
    game = BackupAgent.get(name) || Game.new
    GenServer.start_link(
      __MODULE__,
      game,
      name: reg(name)
    )
  end

  def guess(gamename, username, guessarray) do
    GenServer.call(reg(gamename), {:guess, gamename, username, guessarray})
  end

  def peek(gamename) do
    GenServer.call(reg(gamename), {:peek, gamename})
  end

  def pass(gamename, playername) do
    GenServer.call(reg(gamename), {:pass, gamename, playername})
  end

  def readyup(gamename, playername) do
    GenServer.call(reg(gamename), {:readyup, gamename, playername})
  end

  def readydown(gamename, playername) do
    GenServer.call(reg(gamename), {:readydown, gamename, playername})
  end

  def addplayer(gamename, playername) do
    GenServer.call(reg(gamename), {:addplayer, gamename, playername})
  end

  def removeplayer(gamename, playername) do
    GenServer.call(reg(gamename), {:removeplayer, gamename, playername})
  end

  # implementation

  def init(game) do
    {:ok, game}
  end

  def handle_call({:pass, gamename, username}, _from, game) do
    game = Game.pass(game, username)
    BackupAgent.put(gamename, game)
    {:reply, game, game}
  end

  def handle_call({:readyup, gamename, playername}, _from, game) do
    game = Game.readyplayer(game, playername)
    BackupAgent.put(gamename, game)
    {:reply, game, game}
  end

  def handle_call({:readydown, gamename, playername}, _from, game) do
    game = Game.unreadyplayer(game, playername)
    BackupAgent.put(gamename, game)
    {:reply, game, game}
  end

  def handle_call({:addplayer, gamename, playername}, _from, game) do
    game = Game.addplayer(game, playername)
    BackupAgent.put(gamename, game)
    {:reply, game, game}
  end

  def handle_call({:removeplayer, gamename, playername}, _from, game) do
    game = Game.removeplayer(game, playername)
    BackupAgent.put(gamename, game)
    {:reply, game, game}
  end

  def handle_call({:guess, gamename, username, guessarray}, _from, game) do
    game = Game.makeguess(game, username, guessarray)
    if Game.allplayersguessed(game) do
      game = Game.pushguesses(game)
      BackupAgent.put(gamename, game)
      {:reply, game, game}
    else
      BackupAgent.put(gamename, game)
      {:reply, game, game}
    end
  end

  def handle_call({:peek, _name}, _from, game) do
    {:reply, game, game}
  end
end
