# qb-bankrobbery-target

This is a reworked version of qb-bankrobbery!

# Features

1. _QB-Target functionality!_
2. _Configurable Items for payout / beginning items._
3. _Configurable hack difficulty._

_**To be continued..**_

# Showcase

_**[YouTube Showcase](https://www.youtube.com/watch?v=dQw4w9WgXcQ)**_

# Information

**Currently, this only affects Fleeca Banks. I made this for a RP Server I was developing, and we decided to not release.**

**_I hopefully, in the future, will be implementing these for the paleto and pacific banks -- and possibly other locations._**

**The only modified files are client/fleeca.lua, server/main.lua, config.lua and fxmanifest.lua -- Script errors in other files are an issue with the original qb-bankrobbery.**

# Install Guide
stp 1...
2.
3
4
5
6

# Configuration Information

1. **Config.TwoHack** _is to enable a **20%** chance of an easier hack, mhacking. This is **disabled** by default._
To enable TwoHack, you must have mhacking, which can be found below in the dependencies section. Then, change the value of Config.Twohack from false to true (Config.TwoHack = false ---> Config.TwoHack = true)

2. **Config.WaitTime** _is your wait time for the fleeca (and future banks) vault doors to open. This is in **milliseconds**, so a link for a converter is included._
To change the time, edit the default (300000) to your desired value. (Config.WaitTime = 300000 ---> Config.WaitTime = YOURTIME)

3. **Config.ShowItems** _is a pop-up for the player to see the required items for the hack. This is **disabled** by default. Change to **true** to enable._
https://i.imgur.com/vCmp26D.png

# Dependencies 

1. _[hacking](https://github.com/Jesper-Hustad/NoPixel-minigame/tree/main/fivem-script) from [Jesper-Hustad](https://github.com/Jesper-Hustad)_

2. _***If you have Config.TwoHack enabled, you also will need:*** [mhacking](https://github.com/davedorm/mhacking)_

