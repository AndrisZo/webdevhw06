import React, { Component } from 'react';
import logo from './logo.svg';
import { useState, useEffect } from 'react';

// The function for the app
function MultiBulls() {

    const [state, setState] = useState({
        //secret: generateAnswer(),
        //guesses: [],
        //guess: "",
        //results: [],
        //errorString: "",
        //login: true,
        //username: "",
        //gameName: "",

        secret: generateAnswer(),
        guess: "",
        guesses: [],
        winners: [],
        players: [],
        players_ready: [],
        setup: true,
        gameName: "",
    });

    let {secret, guess, guesses, winners, players, players_ready, setup, gameName} = state;

	// const [secret, setSecret] = useState(generateAnswer());
	// const [guesses, setGuesses] = useState([]);
	// const [guess, setGuess] = useState("");
	// const [results, setResults] = useState([]);
	// const [errorString, setErrorString] = useState("");

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

        setState({secret, guess, guesses, winners, players, players_ready, setup, gameName});
	}

	// Makes the guess and adds it and its result to the respective
	// arrays
	function makeGuess() {
		if (evaluateGuess(guess)) {
            let guesses = uniq(guesses.concat(guess));
            // TODO

            setState({secret, guess, guesses, winners, players, players_ready, setup, gameName});

			// setGuesses(guesses.concat(guess));
			// setResults(results.concat(generateResult(guess)));
			// setErrorString("");
		} else {
            setState({secret, guess, guesses, winners, players, players_ready, setup, gameName});
		}
        let newGuess = "";
        setState({secret, newGuess, guesses, winners, players, players_ready, setup, gameName});
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

    // function usernameKeyPress(ev) {
    //     if (ev.key === "Enter") {
    //         setState({secret, guesses, guess, results, errorString, login, username, gameName});
    //     }
    // }

    // function gameNameKeyPress(ev) {
    //     if (ev.key === "Enter") {
    //         setState({secret, guesses, guess, results, errorString, login, username, gameName});
    //     }
    // }

	// Evaluates whether a given guess is valid (i.e. 4 unique digits)
	function evaluateGuess(currentGuess) {
		var chars = currentGuess.toString().split('');
		return !(chars.length !== 4 || chars[0] === chars[1] || chars[0] === chars[2] || chars[0] === chars[3] || chars[1] === chars[2] || chars[1] === chars[3] || chars[2] === chars[3]);
	}

    // If it is the first time the user is viewing the page, presents a login screen
    if (setup) {
        setup = false;
        return (
            <div className="App">
                <h1 id="Login">LOGIN</h1>
                <p>
                    <h2 id="Username">Username</h2>
                    <input type="text"
                        value={username}
                        onChange={updateUsername}
                        onKeyPress={usernameKeyPress} />
                </p>
                <p>
                    <h2 id="GameName">Game Name</h2>
                    <input type="text"
                        value={gameName}
                        onChange={updateGameName}
                        onKeyPress={gameNameKeyPress} />
                </p>
            </div>
        );
    }

	// If the user guesses the correct secret number, presents a win screen
	if (guesses.includes(secret)) {
		return (
			<div className="App">
				<h1 id="win">You Win! Congratulations!</h1>
				<p>
					<button onClick={function(){
                        let newSecret = generateAnswer();
                        let newGuesses = [];

						setState({newSecret, guess, newGuesses, winners, players, players_ready, setup, gameName});
					}}>
						Reset		
					</button>
				</p>
			</div>
		);
	}

    function generateTable() {
        var guessNumber = 1;
        let rows = [];
        var i;
        for (i = 0; i < guesses.length; i++) {
            rows = rows.concat(
                <tr>
                    <td>{guessNumber}</td>
                    <td>{guesses[i][0]}</td>
                    <td>{guesses[i][1].toString()}</td>
                    <td>{generateResult(guesses[i][1])}</td>
                </tr>
            );
        }

        var j;
        let out = "";
        for (j = 0; j < rows.length; j++) {
            out += rows[j];
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

	// Returns the visual format of the game
	return (
		<div className="App">
			<h1>Bulls and Cows! Room: {gameName}</h1>
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
				<button onClick={function(){
                    let newSecret = generateAnswer();
                    let newGuesses = [];

                    setState({newSecret, guess, newGuesses, winners, players, players_ready, setup, gameName});
                                        }}>
					Reset
				</button>
			</p>
			<p>
				{generateTable()}
			</p>
		</div>
	);
}

export default App;