# Gather

ConsenSys Course Final Project

[![Travis](https://travis-ci.org/dev-bootcamp-2019/final-project-elshaek.svg?branch=master)](https://travis-ci.org/dev-bootcamp-2019/final-project-elshaek)

This decentralized application was developed as the final project for the [Consensys Academy developer program](https://consensys.net/academy/).

## What is Gather?

A simple application that allows anyone to create a gathering/event/community

There are two primary actors in this system:

ORGANIZER - An individual or entity that organizes a gathering

PARTICIPANTS - An individual or entity that takes part in a gathering

This web app allows any individual or entity to organize a gathering, and allow anyone to request to join the gathering.

## Running the application
1. Clone this repository
2. In the repo root directory, run `ganache-cli`
3. Still in the same directory, run `truffle migrate --reset`
4. `cd client` and run `npm install` 
5. In the `client` directory, run `npm run start` 
5. Interact with the application at [http://localhost:3000](http://localhost:3000)

## User Stories:

### Organizer
- The organizer can go to the web app and create a new gathering with the following details: Gathering name, details and purpose of the gathering
- The organizer can approve or reject a participant's request to join
- The organizer can archive an event

### Participant
- A participant can go to the app and see a list of gatherings
- A participant can click on a gathering to get more details: Purpose of gathering, number of participants who are already part of the gathering
- A participant can request to join the gathering
- A participant cannot join an archived event