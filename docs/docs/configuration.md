---
sidebar_position: 20
title: Configuration
---

# Configuration

Constants and "magic numbers" are all combined into a single file located at `src/shared/Constants/CONFIG.lua`. This makes it easy to adjust the game without having to sift through scripts.

## When to Put Values Into Config

Values should be extracted from scripts and moved to the configuration file if it fits the following criteria:

* The value is a constant (does not change at runtime)
* The value might need to be changed in the future
* The value is seemingly arbitrary (A wait time of 5 seconds is arbitrary - a transparency of 1 is not)

If you are unsure if a value fits these criteria, put it in anyway - better to have it and not need it.