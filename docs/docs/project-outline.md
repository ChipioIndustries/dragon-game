---
sidebar_position: 30
title: Project Outline
---

# Project Outline

This is a brief overview of the various files and folders in the project and the purposes they serve.

```text
Dragon Game
├── .github
│   └── workflows - This folder holds any workflow scripts that run when changes are pushed to GitHub.
├── docs - This is the root of the documentation site.
│   ├── docs - The folder of markdown files that are turned into the doc site.
│   ├── src - Scripts and components used by the doc site.
│   └── static - A folder containing public assets used by the docs.
├── src - This is the codebase of the game.
│   ├── client - This contains scripts that get placed into StarterPlayer.StarterPlayerScripts.
│   ├── server - This contains scripts that get placed into ServerScriptService and are hidden from the client.
│   │   ├── Actions - Server-exclusive actions that can be dispatched to the Rodux store.
│   │   └── Modules - Systems that run game logic not driven by player input.
│   └── shared - This contains modules that get placed into ReplicatedStorage and can be used by both the server and the client.
│       ├── Actions - Shared actions that can be dispatched on the server, replicating to clients, or dispatched on the client, not replicating anywhere else.
│       ├── Checks - Contains checks that verify if a remote call has provided valid input.
│       ├── Components - Roact components used to build the UI.
│       ├── Constants - Unchanging values centralized into one easy-to-modify location.
│       ├── Modules - Stateful modules with side effects that the client needs to be able to interact with.
│       ├── Reducers - A tree of modules that describe how to modify the state of the Rodux store when actions are dispatched.
│       ├── Selectors - Helper functions for rapidly grabbing info from the Rodux store.
│       └── Utilities - Stateless functions that are used across the game.
├── .gitignore - A list of files and directories that shouldn't be synced to GitHub.
├── LICENSE - This project is open-sourced under the MPL-2.0 license.
├── README.md - An introduction to this project.
├── TestExecution.lua - A script used by the automated testing workflow to run the testing suite. This can also be pasted into the Studio command bar to run the test suite without pushing.
├── client.ovpn - Used by the automated testing workflow to VPN into a static IP address with a valid authentication token to install and open Studio.
├── default.project.json - Describes to Rojo how a Roblox place should be built from the file tree.
├── foreman.toml - A list of tools that Foreman should automatically install.
├── selene.toml - Tells the linter which additional config files to look for.
├── testez.toml - Linting rules related to the TestEZ testing library.
├── wally.exe - A custom build of Wally that is temporarily in place until dev dependencies are fixed. Use this with `./wally` anywhere you would normally use `wally`.
├── wally.lock - A lockfile that determines exactly which packages should be installed by Wally.
└── wally.toml - A list of dependencies that need to be downloaded before the project can run.
```
