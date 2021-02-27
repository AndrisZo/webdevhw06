// CONTAINS HELPER FUNCTIONS FOR MultiBulls.js

// Returns a string containing the contents of the given list separated by a comma
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

// Generates an HTML table containing the data for players' win and loss count
function generateWinsTable(playerswinloss) {
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

// Generates the result string for a given guess in the form 0A1B and returns it
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

// Generates an HTML table containing the data for the guesses given in the round thus far
function generateGuessTable(guesses) {
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