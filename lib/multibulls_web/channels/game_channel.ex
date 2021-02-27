defmodule MultibullsWeb.GameChannel do
  use MultibullsWeb, :channel

  alias Multibulls.Game
  alias Multibulls.GameServer

  @impl true
  def join("game:" <> lobbyname, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, :gamename, lobbyname)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in("getgame", %{}, socket) do
    game = GameServer.peek(socket.assigns[:gamename])
    {:reply, {:ok, Game.view(game, socket.assigns[:username])}, socket}
  end

  @impl true
  def handle_in("login", %{"name" => username}, socket) do
    socket = assign(socket, :user, username)
    currgame = GameServer.peek(socket.assign[:gamename])
    {:reply, {:ok, Game.view(currgame, username)}, socket}
  end

  @impl true
  def handle_in("makeguess", %{"guess" => guess}, socket) do
    username = socket.assign[:username]
    game = GameServer.guess(socket.assign[:gamename], username, guess)
    view = Game.view(game, username)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("pass", %{}, socket) do
    username = socket.assign[:username]
    game = GameServer.pass(socket.assign[:gamename], username)
    view = Game.view(game, username)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("readyup", %{}, socket) do
    username = socket.assign[:username]
    game = GameServer.readyup(socket.assign[:gamename], username)
    view = Game.view(game, username)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("readydown", %{}, socket) do
    username = socket.assign[:username]
    game = GameServer.readydown(socket.assign[:gamename], username)
    view = Game.view(game, username)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("addplayer", %{}, socket) do
    username = socket.assign[:username]
    game = GameServer.addplayer(socket.assign[:gamename], username)
    view = Game.view(game, username)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("removeplayer", %{}, socket) do
    username = socket.assign[:username]
    game = GameServer.removeplayer(socket.assign[:gamename], username)
    view = Game.view(game, username)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  intercept ["view"]

  @impl true
  def handle_out("view", msg, socket) do
    user = socket.assigns[:username]
    msg = %{msg | username: user}
    push(socket, "view", msg)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

"""
Calls the user can make to the server:
- "join"
    - Check for an ongoing game on the backup server
        - If there's an ongoing game, use it
        - If there's not, make a new one
    - view(addplayer(oldgame, name, namewinloss))
- "makeguess"
    - view(makeguess(oldgame, name, guess))
- "pass"
    - view(pass(oldgame, name))
- "ready-up"
    - readygame = readyup(game, name)
    - if everyone is ready:
        - view(startgame(game))
    - else
        -view(game)
    - view(readyup(oldgame, name))
- "ready-down"
    - view(readydown(oldgame, name))
- "becomeplayer"
    - view(addplayer(oldgame, name, namewinloss))
- "becomeobserver"
    - push wins and losses to backup server
    - view(removeplayer(oldgame, name))
- "getrecentgame"
    - view(oldgame)
"""
