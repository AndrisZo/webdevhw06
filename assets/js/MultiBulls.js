import "../css/app.scss"; // CSS
import React, { Component } from 'react';
import { useState, useEffect } from 'react';
import { channel_join, channel_makeguess, channel_stateupdate, channel_observer_join, channel_ready } from './socket.js';
import { generateCommaList, generateWinsTable, generateGuessTable, generateResult } from './helpers.js';

// Login Screen
function Login() {
    const [game, setGame] = useState("");

    return (
        <div className="row">
            <h1>Login</h1>
            <div className="column">
                <input type="text"
                    value={username}
                    onChange={(ev) => {username = ev.target.value}} />
            </div>
            <div className="column">
                <input type="text" 
                    value={game}
                    onChange={(ev) => setGame(ev.target.value)} />
            </div>
            <h2>Join As:</h2>
            <div className="column">
                <button onClick={() => channel_join(game, username)}>Player</button>
                <button onClick={() => channel_observer_join(game, username)}>Observer</button>
            </div>
        </div>
    );
}

// Win Screen
function WinScreen(currentWinners, winTable) {
    return (
        <div className="App">
            <h1>Game Finished</h1>
            <p id="WinScreenReadyLine">
                <h2>Ready for next round?</h2>
                <button onClick={() => channel_ready(username)}>Ready Up</button>
            </p>
            <h2>This Round's Winners: {winners}</h2>
            <p>
                {winTable}
            </p>
        </div>
    );
}

// The function for the app
function Play({state}) {
    let {guesses, winners, playerswinloss, playersready, setup, username} = state;
    let guess = "";

	// Makes the guess and adds it and its result to the respective arrays
	function makeGuess(guess) {
        channel_makeguess(guess, username);
	}

	// Returns the visual format of the game
	return (
		<div className="App">
			<h1>Bulls and Cows!</h1>
			<p>
				<input type="text"
					value={guess}
					onChange={(ev) => {guess = ev.target.value}}/>
				<button onClick={() => makeGuess(guess)}>Guess</button>
			</p>
			<p>
				{generateGuessTable(guesses)}
			</p>
		</div>
	);
}

// The function for the ready screen
function ReadyScreen() {
    return (
        <div className="App">
            <h1>Bulls and Cows!</h1>
            <h2>Logged in as: {username}</h2>
            <p>
                <h2>Players Ready: </h2>
                <h2 id="PlayersReadyList">{generateCommaList(playersready)}</h2>
            </p>
            <p>
                <button onClick={() => channel_ready(username)}>Ready Up</button>
            </p>
        </div>
    );
}

// The rendering function containing the state
function MultiBulls() {
    const [state, setState] = useState({
        guesses: [],
        winners: [],
        playerswinloss: new Map(),
        playersready: [],
        setup: true,
        username: "",
    });

    console.log("render state", state);

    useEffect(() => {
        channel_stateupdate(setState);
    });

    if (setup && playersready.length === playerswinloss.size) {
        setup = false;
    }

    if (setup) {
        if (username === "") {
            return <Login />
        } 
        else {
            return <ReadyScreen />
        }
    }
    else if (winners.length != 0) {
        return <WinScreen currentWinners={generateCommaList(winners)} winTable={generateWinsTable(playerswinloss)} />
    }
    else {
        return <Play state={state} />;
    }
}

export default App;