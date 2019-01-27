# Gather

ConsenSys Course Final Project

[![Travis](https://travis-ci.org/dev-bootcamp-2019/final-project-elshaek.svg?branch=master)](https://travis-ci.org/dev-bootcamp-2019/final-project-elshaek)

This decentralized application was developed as the final project for the [Consensys Academy developer program](https://consensys.net/academy/).

## What is Gather?

A simple application that allows any individual or entity to organize a gathering, and allow anyone to request to join the gathering.

## Running the application
1. Clone this repository
2. In the repo root directory, run `ganache-cli`
3. Still in the same directory, run `truffle migrate --reset`
4. `cd client` and run `npm install` 
5. In the `client` directory, run `npm run start` 
6. Set metamask network to Localhost 8545
7. Interact with the application at [http://localhost:3000](http://localhost:3000)

## User Stories:
- Contract owner is also an admin
- An admin can add another admin
- Anyone can sign up as a user on the platform
- An organizer can change the name of a gathering
- An organizer can remove a participant from a gathering by the organizer
- An organizer can delete a previously created gathering
- A user can organize a gathering
- A user can become a participant of any gathering unless the gathering is already full
- A user can organize a maximum of 5 gatherings
- A user can leave a gathering
