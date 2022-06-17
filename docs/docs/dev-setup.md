---
sidebar_position: 10
title: Development Setup
---

This project requires a couple of command line tools to convert the source into a Roblox place.

## Requirements

* You must have [Foreman](https://github.com/Roblox/foreman) to install the toolchain. This [guide](https://www.youtube.com/watch?v=cMfPkBnmm3U) shows how to set up Foreman.

## Installing Toolchain

In the root of the project, run the following `foreman` command to install the toolchain:

```bash
foreman install
```

All of the tools listed in `foreman.toml` will now be installed and usable.

## Installing Packages

:::caution

The latest version of Wally has a bug that breaks this project. A fix is already in for this but not yet released. In the meantime, a custom build with this patch is located in the root of the project. Until the fixed version of Wally is released, use this build by substituting the beginning of any command that starts with `wally` with `./wally.exe`.

:::

This project depends on many libraries made available as Wally packages. To install the dependencies, run the following command:

```bash
wally install
```

## Installing Rojo

Rojo is the bridge between the Lua files and Roblox Studio. The Rojo server, which was installed by foreman, sends data to the Rojo Studio plugin. To install the Studio plugin, use the following command:

```bash
rojo plugin install
```

## Syncing Files to Studio

To start up the Rojo server, run the following command:

```bash
rojo serve
```

In Studio, open the Rojo plugin menu and connect. The scripts will be synced from the filesystem into the open Studio instance.
