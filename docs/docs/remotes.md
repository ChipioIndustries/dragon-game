---
sidebar_position: 50
title: Remotes System
---

# Remotes System

This project uses the [remotes](https://chipioindustries.github.io/remotes/) package, which simplifies the creation and usage of remotes:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Packages.Remotes)
local myRemote = Remotes:getFunctionAsync("myRemote")
print(myRemote:InvokeServer())
```

## Rate Limiting

Rate limiting middleware is added to all remotes automatically. The configuration for these limits can be found in `server/Secrets`. Custom limits can be set for specific remotes if desired.

## Dispatching Actions From Remotes

Rodux actions can be exposed to players as RemoteFunctions. These remotes are rate-limited and checked rigorously to ensure the player cannot crash the server or use exploiting tools to gain an unfair advantage.

### Creating Actions

Create an action in `server/Actions` that you want the player to be able to invoke. These actions will receive the match ID, the player ID, and then any arguments provided by the player.

### Creating Checks

Create a check module in `shared/Checks/Requests`. This module will only receive the exact arguments provided by the remote (e.g. if the player invokes the function passing through 1 argument, the check will receive the player object and the argument). The check should verify that the user input is valid and there is no way the player would be breaking the game. In the end, the check should return true if the request is valid. If the request is invalid, the check should return false and the reason for the failure.

### Request Processor

`server/Modules/RequestProcessor` is responsible for converting these checks and actions into remotes that can be accessed by the client. It will cycle through each check module located in `shared/Checks/Requests` and create a `RemoteFunction` for it.
