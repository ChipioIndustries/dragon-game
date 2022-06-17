---
sidebar_position: 80
title: Unit Testing
---

# Unit Testing

As a project grows in complexity it becomes harder to thoroughly test for issues when changes are made. To solve this, test scripts are written that feed modules inputs and checks that the outputs match the expected result. These test scripts can all be run at once to test the entire game automatically.

## Blind Spots

Unit tests are ideal for testing self-contained, purely functional modules. However, there are weaknesses and gaps in coverage that need to be tested manually.

### Side Effects

For the most part, a test can only see the inputs it gives and the outputs it receives. If a module has side effects, these effects can be difficult to check for.

### Networking

There is currently no way to test client-sided or cross-network functionality due to the context test scripts are run in. Instead of starting a server, the place file is simply loaded into studio, and the test scripts are executed as a plugin.

## Test-Driven Development

Ideally, code should be written with testing in mind - there are many opportunities to design a module to make it easier to test. In fact, sometimes it's a good idea to write the unit tests before writing the module itself.

## Testing Workflow

The testing suite is run on every push and pull request to the repository. This workflow can take several minutes to run. I will now explain in excruciating detail how this works because I need to justify all the time I spent setting it up.

* The job begins by pulling the code from GitHub to test.
* Foreman is installed, which also installs the rest of the toolchain.
* Packages are installed with Wally.
* A test RBXL file is built with Rojo.

This next part goes off the rails and requires a deeper explanation: Studio requires you to log in to use it. This requires a .ROBLOSECURITY token, but this token must have originated from the same IP address the request is coming from. Because the IP address of the action runner changes every time, we need to tunnel into a self-hosted VPN with a static IP address the account cookie originated from. Insane.

* Download the OpenVPN client, which will be used to tunnel into a server with a static IP.
* Run OpenVPN and connect using the certificate included in the repo.
* Repeatedly check for when the IP successfully changes.
* Make an authenticated test request to Roblox to ensure the authentication is valid.
* Install and log into Roblox Studio with the authentication token.
* Run the testing suite in Studio.
* Take a screenshot on failure. OpenVPN puts connection errors on a GUI instead of in the console, so this is helpful in diagnosing VPN failures.
* Print the test results.
* Cause a failure if one of the tests failed.

