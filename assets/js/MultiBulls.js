import "../css/app.scss"; // CSS
import React, { Component } from 'react';
import { useState, useEffect } from 'react';
import { channel_join, channel_makeguess, channel_stateupdate, channel_observer_join, channel_ready, channel_readyup, channel_readydown,
    channel_toobserver, channel_toplayer, channel_pass, channel_leave} from './socket.js';
import { generateCommaList, generateWinsTable, generateGuessTable, generateResult } from './helpers.js';

// Login Screen
function Login() {
    const [username, setUsername] = useState("");
    const [game, setGame] = useState("");

    return (
        <div className="row">
            <h1>Login</h1>
            <div className="column">
                <input type="text"
                    value={username}
                    onChange={(ev) => setUsername(ev.target.value)} />
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

// function leavegame(callback) {
//     callback({
//         guesses: [],
//         winners: [],
//         playerswinloss: [],
//         playersready: [],
//         setup: true,
//         username: "",
//         players: [],
//     });
//     channel_leave();
// }



// The function for the ready screen
function ReadyScreen({state}) {
    console.log("State received by readyscreen:")
    console.log(state);

    let readyText = "Ready Up";

    if (state.playersready.includes(state.username)) {
        readyText = "Ready Down"
    }

    return (
        <div className="App">
            <h1>Bulls and Cows!</h1>

            <h2>Logged in as: {state.username}</h2>
            <h2>Players Ready: </h2>
            <h2 id="PlayersReadyList">{generateCommaList(state.playersready)}</h2>
            <p>
                <button onClick={() => channel_ready(state.username)}>{readyText}</button>
            </p>
            <h2>Change Roles?</h2>
            <p>
                <button onClick={() => channel_toplayer(state.username)}>Player</button>
                <button onClick={() => channel_toobserver(state.username)}>Observer</button>
            </p>
            <h2>This Round's Winners: {state.winners.join(', ')}</h2>
            <p>
                {generateWinsTable(state.playerswinloss)}
            </p>
        </div>
    );
}



// The rendering function containing the state
function MultiBulls() {
    const [state, setState] = useState({
        guesses: [],
        winners: [],
        playerswinloss: [],
        playersready: [],
        setup: true,
        username: "",
        players: [],
    });

    console.log("render state", state);

    useEffect(() => {
        channel_stateupdate(setState);
    });


    // The function for the app
    function Play({state}) {
        let {guesses, winners, playerswinloss, playersready, setup, username, players} = state;
        const [guess, setGuess] = useState("");

        // Makes the guess and adds it and its result to the respective arrays
        function makeGuess() {
            let arr = guess.split("");
            let i = 0;
            while (i < arr.length) {
                arr[i] = parseInt(arr[i], 10);
                i++;
            }
            channel_makeguess(arr, state.username);
        }

        let buttons = [];
        if (players.includes(username)) {
            buttons.push(
                <div>
                    <input type="text"
				        	value={guess}
					        onChange={(ev) => {setGuess(ev.target.value)}}></input>
                    <button onClick={makeGuess}>Guess</button>
                    <button onClick={channel_pass}>Pass</button>
                </div>
            );
        }

        

    	// Returns the visual format of the game
	    return (
		    <div className="App">
			    <h1>Bulls and Cows!</h1>
			    <p>    
                    {buttons}
                    <button id="LeaveButton" onClick={channel_leave}>Leave</button>
    			</p>
                {generateGuessTable(state.guesses)}
		    </div>
    	);
    }

    if (state.setup) {
        if (state.username === "") {
            return <Login />
        } 
        else {
            return <ReadyScreen state={state}/>
        }
    }
    else if (state.winners.length > 0) {
        return <WinScreen currentWinners={generateCommaList(state.winners)} winTable={generateWinsTable(state.playerswinloss)} />
    }
    else {
        return <Play state={state} />;
    }
}

export default MultiBulls;