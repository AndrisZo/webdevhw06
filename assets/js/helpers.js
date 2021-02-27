// CONTAINS HELPER FUNCTIONS FOR MultiBulls.js

import React, { Component } from 'react';

// Returns a string containing the contents of the given list separated by a comma
export function generateCommaList(list) {
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
export function generateWinsTable(playerswinloss) {
    let out = [];
    let i;
    for (i = 0; i < playerswinloss.length; i++) {
        out.push(
            <tr>
                <td>{playerswinloss[i][0]}</td>
                <td>{playerswinloss[i][1]}</td>
                <td>{playerswinloss[i][2]}</td>
            </tr>
        );
    }

    return (
        <table>
            <thead>
                <tr>
                   <th>Players</th>
                    <th>Wins</th>
                    <th>Losses</th>
                </tr>
            </thead>
            <tbody>
                {out}
            </tbody>
        </table>
    );   
}

// Generates an HTML table containing the data for the guesses given in the round thus far
export function generateGuessTable(guesses) {
    let out = [];
    let i;
    for (i = 0; i < guesses.length; i++) {
        out.push(
            <tr>
                <td>{i + 1}</td>
                <td>{guesses[i][0]}</td>
                <td>{guesses[i][1].join('')}</td>
                <td>{guesses[i][2] + "A" + guesses[i][3] + "B"}</td>
            </tr>
            );
    }

    return (
    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>User</th>
                <th>Guess</th>
                <th>Result</th>
            </tr>
        </thead>
        <tbody>{out}</tbody>
    </table>
    );
}