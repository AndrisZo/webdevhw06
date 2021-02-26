import React, { Component } from 'react';
import { useState, useEffect } from 'react';

// The function for the app
function MultiBulls() {

    const [state, setState] = useState({
        // guesses, winners, playerswinloss, playersready, setup (bool)
        // secret: generateAnswer(),
        // guess: "",
        // guesses: [],
        // winners: [],
        // players: [],
        // players_ready: [],
        // setup: true,
        // gameName: "",

        guesses: [],
        winners: [],
        playerswinloss: new Map(),
        playersready: [],
        setup: true,
    });

    let {guesses, winners, playerswinloss, playersready, setup} = state;

	// Generates the secret number that must be guessed and returns it
	// It is comprised of 4 unique digits
	function generateAnswer() {
		let digit1 = Math.floor(Math.random() * 9 + 1)
		let digit2 = digit1;
		while (digit2 === digit1) {
			digit2 = Math.floor(Math.random() * 10);
		}
		let digit3 = digit2;
		while (digit3 === digit2 || digit3 === digit1) {
			digit3 = Math.floor(Math.random() * 10);
		}
		let digit4 = digit3;
		while (digit4 === digit3 || digit4 === digit2 || digit4 === digit1) {
			digit4 = Math.floor(Math.random() * 10);
		}
		let out = (digit1 + (10 * digit2) + (100 * digit3) + (1000 * digit4));
		return out.toString();
	}

	// Updates the guess field
	function updateGuess(ev) {
		let text = ev.target.value;
		if (text.length > 4) {
			text = text.substring(0, 4);
		}

        setState({guesses, winners, playerswinloss, playersready, setup});
	}

	// Makes the guess and adds it and its result to the respective
	// arrays
	function makeGuess() {
		if (evaluateGuess(guess)) {
            let guesses = uniq(guesses.concat(guess));
            // TODO

            setState({guesses, winners, playerswinloss, playersready, setup});

			// setGuesses(guesses.concat(guess));
			// setResults(results.concat(generateResult(guess)));
			// setErrorString("");
		} else {
            setState({guesses, winners, playerswinloss, playersready, setup});
		}
        let newGuess = "";
        setState({guesses, winners, playerswinloss, playersready, setup});
	}

	// Generates the result string for a given guess in the form 0A1B
	// and returns it
	function generateResult(currentGuess) {
		let secretDigits = secret.toString().split('');
		let guessDigits = currentGuess.toString().split('');
		let correctPlaceCount = 0;
		let correctNumberCount = 0;

		var i;
		for (i = 0; i < secretDigits.length; i++) {
			if (secretDigits[i] === guessDigits[i]) {
				correctPlaceCount++;
			}
		}
		if (guessDigits[0] === secretDigits[1] ||
		guessDigits[0] === secretDigits[2] ||
		guessDigits[0] === secretDigits[3]) {
			correctNumberCount++;
		}
		if (guessDigits[1] === secretDigits[0] ||
		guessDigits[1] === secretDigits[2] ||
		guessDigits[1] === secretDigits[3]) {
			correctNumberCount++;
		}
		if (guessDigits[2] === secretDigits[0] ||
		guessDigits[2] === secretDigits[1] ||
		guessDigits[2] === secretDigits[3]) {
			correctNumberCount++;
		}
		if (guessDigits[3] === secretDigits[0] ||
		guessDigits[3] === secretDigits[1] ||
		guessDigits[3] === secretDigits[2]) {
			correctNumberCount++;
		}

		return correctPlaceCount + "A" + correctNumberCount + "B";
	}

	// Handles if enter is pressed, it calls the makeGuess function
	function keyPress(ev) {
		if (ev.key === "Enter") {
			makeGuess();
		}
	}

	// Evaluates whether a given guess is valid (i.e. 4 unique digits)
	function evaluateGuess(currentGuess) {
		var chars = currentGuess.toString().split('');
		return !(chars.length !== 4 || chars[0] === chars[1] || chars[0] === chars[2] || chars[0] === chars[3] || chars[1] === chars[2] || chars[1] === chars[3] || chars[2] === chars[3]);
	}

    function generateGuessTable() {
        let guessNumber = 1;
        let out = '';
        let i;
        for (i = 0; i < guesses.length; i++) {
            out += (
                <tr>
                    <td>{guessNumber}</td>
                    <td>{guesses[i][0]}</td>
                    <td>{guesses[i][1].toString()}</td>
                    <td>{generateResult(guesses[i][1])}</td>
                </tr>
                );
            guessNumber++;
        }

        return (
        <table>
            <tr>
                <th>#</th>
                <th>User</th>
                <th>Guess</th>
                <th>Result</th>
            </tr>
            {out}
        </table>
        );
    }

    function generateWinsTable() {
        let out = '';
        let i;
        for (i = 0; i < playerswinloss.length; i++) {
            out += (
                <tr>
                    <td>{players[i]}</td>
                    <td>{playerswinloss.get(players[i])[0]}</td>
                    <td>{playerswinloss.get(players[i])[1]}</td>
                </tr>
            );
        }

        return (
            <table>
                <tr>
                    <th>Players</th>
                    <th>Wins</th>
                    <th>Losses</th>
                </tr>
                {out}
            </table>
        );   
    }

    function generateCommaList(list) {
        let i;
        let out = "";
        let length = list.length;
        for (i = 0; i < length; i++) {
            if (i === length - 1) {
                out += list[i];
            }
            else {
                out += list[i] + ", ";
            }
        }

        return out;
    }

    // If it is the first time the user is viewing the page, presents a login screen
    // TODO FIX THIS

    if (setup) {
        const [username, setUsername] = useState("");
        const [game, setGame] = useState("");
        setup = false;

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
                <div className="column">
                    <button onClick={() => ch_login(username, game)}>Join</button>
                </div>
            </div>
        );
    }

    // If there are winners for the current round
    if (winners.length != 0) {
        return (
            <div className="App">
                <h1>Game Finished</h1>
                <h2>This Round's Winners: {generateCommaList(winners)}</h2>
                <p>
                    {generateWinsTable()}
                </p>
            </div>
        );
    }

	// Returns the visual format of the game
	return (
		<div className="App">
			<h1>Bulls and Cows!</h1>
            <h2>Players Ready: {generateCommaList(playersready)}</h2>
			<p>
				<input type="text"
					value={guess}
					onChange={updateGuess}
					onKeyPress={keyPress} />
				<button onClick={makeGuess}>
					Guess
				</button>
			</p>
			<p>
				{generateGuessTable()}
			</p>
		</div>
	);
}

export default App;