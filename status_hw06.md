Please fill in answers to the questions below:

1. What are the names of the members of your team?
Andris Zonies, Iain Morrison

2. What hostname did you deploy to?
hw06.physicalmod.com

3. Which parts of this assignment did you have trouble with, if any?
We had some trouble with figuring out communication between the browser and the server, as well as needing to do some self teaching on
how the GenServer stuff worked. Debugging react code can also be annoying sometimes since there's no unit tests, but we got through it eventually. 

4. What part of your application state is on the server?
The server holds:
- guesses: The guesses made so far in this game,
- secret: The 4 secret digits,
- currentguesses: The guesses people have made in the current round,
- passed: The list of players passing this round,
- winners: The people that won the last game,
- players: The list of people playing in the current round,
- playerswinloss: The permanent win loss record for everyone that has played in this room,
- playersready: The players who are readied up for a game,
- turnnumber: The turn the players are currently on,
- setup: Whether or not the game is currently in setup phase, where the users can choose to be players or observers. 

5. What part of your application state, if any, is in the browser?
- The list of guesses made thus far
- The list of winners for the current round
- A 2D array with each index containing an array of: The player's username, their win count, and their loss count 
- The list of the players currently marked "Ready"
- A boolean representing whether the game is still in its setup state
- The current user's username
- A list of all the players

And here's a list of tasks for grading comments. Just leave this here:
 - Task 1
 - Task 2
 - Task 3
 - Task 4
 - Task 5
 - Task 6
 - Task 7
 - Task 8
