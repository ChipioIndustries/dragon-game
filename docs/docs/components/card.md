---
title: Card
---

# Card Component

The card component is a standard playing card that can receive input and animate from one position to another.

## Animation

Card positions are cached automatically using the provided `playerId` and `signature` as a key. When a card is first rendered, it checks to see if it has a cached position. If it does, it animates from its cached position to the intended position.

## Props

|required|name|type|default|description|
|-|-|-|-|-|
||`anchorPoint`|`Vector2`|`0.5, 0.5`|The `AnchorPoint` of the card's underlying frame.|
|yes|`direction`|`CardDirection`||The `CardDirection` of the card.|
||`onClick`|`type`||The function to be called when the card is clicked.|
||`playerId`|`string`|`nil`|The ID of the card's player.|
||`position`|`type`|`0, 0, 0, 0`|The `Position` of the card's underlying frame.|
||`rotation`|`type`|`0`|The `Rotation` of the card's underlying frame.|
||`selected`|`type`|`false`|Whether or not a bright selection border should appear around the card.|
|yes|`signature`|`string`||The signature of the card.|
||`zIndex`|`type`|`1`|The `ZIndex` of the card's underlying frame.|

## onClick

The optional `onClick` prop is a callback function that runs when the player activates the card, either by clicking or tapping on it. The callback receives the underlying Roblox instance followed by the arguments provided by the `Activated` event.
