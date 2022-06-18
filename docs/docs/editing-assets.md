# Editing Assets

Assets are complex Roblox instances that can't be easily represented by a file tree or in the Rojo file. Instead, Remodel is used to extract assets from the Roblox level and put them into the `assets` folder.

## Updating Assets

To extract assets from the current Roblox level and put them into the `assets` folder, run the following command in the root of the project:

```bash
remodel run extractModels.lua
```

To add a new asset category, edit the `extractModels.lua` file before running the command.
