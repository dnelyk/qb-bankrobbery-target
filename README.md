# qb-bankrobbery-target

This is a reworked version of qb-bankrobbery! - Unaware if anyone has done this before.

# Features

1. _QB-Target functionality!_
2. _Configurable items for payout._
3. _Configurable hack difficulty._
4. _A lot more configurability._
5. _Lootable money trays._

_**Future Features will be added**_

# Showcase

_**[YouTube Showcase](https://www.youtube.com/watch?v=3g81Nj3t4cc)**_

# Information

**NOTE:** _I am currently unaware if Gabz's Bank Interiors will conflict with the fleeca banks, although I am pretty sure that his Pacific Standard and Paleto ones will affect the pacific bank and paleto banks. These interiors are not currently supported with my version of this bank robbery script. Sorry if you do have these interiors._

**Currently, this only affects Fleeca Banks. I made this for a RP Server I was developing, and we decided to not release.**

**_I hopefully, in the future, will be implementing these for the paleto and pacific banks -- and possibly other locations. If people want me to._**

**The only modified files are client/fleeca.lua, server/main.lua, config.lua and fxmanifest.lua -- Script errors in other files are an issue with the original qb-bankrobbery.**

**Resource Monitor:** _Anywhere from (**Idle** of **0.00ms-0.01ms**; **During Active Robbery**: **0.02ms-0.03ms**)_
 
**This disables showing the items required for the hack, as I feel it makes no sense from an RP standpoint, as this script is made for rp, I have disabled it.**
##### ![image](https://user-images.githubusercontent.com/95599217/174428190-652b1889-0d26-49c0-924f-4d51c8528df1.png)

# Install Guide

1. Download this resource, and remove -main from the end. It should now just be qb-bankrobbery-target.
2. Download the dependencies, **[hacking](https://github.com/Jesper-Hustad/NoPixel-minigame/tree/main/fivem-script)**, if using Config.TwoHack, also download
**[mhacking](https://github.com/davedorm/mhacking)** and make sure you have [qb-target](https://github.com/qbcore-framework/qb-target) in your server resources.   This is included with the QB Framework.
3. Drag and Drop **qb-bankrobbery-target**, **hacking**, and **mhacking**, if you are using it, into your resources folder in your server. 
4. Ensure these resources in your server.cfg, if they are not in a folder that is already ensured. Make sure that hacking, mhacking and qb-target are started before qb-bankrobbery-target. Example of server.cfg: 
##### ![image](https://i.imgur.com/AUh8cdO.png)
5. If you wish to change anything, open the Config.lua in **qb-bankrobbery-target**, and refer to the configuration information tab to make your changes.


# Configuration Information

1. **Config.TwoHack** _is to enable a **20%** chance of an easier hack, mhacking. This is **disabled** by default._
To enable TwoHack, you must have mhacking, which can be found below in the dependencies section. Then, change the value of Config.Twohack from false to true (Config.TwoHack = false ---> Config.TwoHack = true)

2. **Config.WaitTime** _is your wait time for the fleeca (and future banks) vault doors to open. This is in **milliseconds**, so a link for a converter is included._
To change the time, edit the default (300000) to your desired value. (Config.WaitTime = 300000 ---> Config.WaitTime = YOURTIME)

3. **Config.CopCallTime** _dictates the amount of time it takes for the police to get a ping if there is a robbery occuring. (IN MS)_

4. **Config.Stress** _dictates whether the player grabbing the money will gain stress when grabbing or not. **True** = Yes, **False** = No._

5. **Config.StressAmount** _dictates how much stress the player gets when grabbing. **Default** = **15**, this value shouldn't go over **30**._

6. **Config.FleecaItem** _dictates the item that the player gets after grabbing the money off of the tray. **Default** = "markedbills"_

7. **Config.RandomItemAmount** _dictates the amount of your designated item the player gets. **Default** = math.random(**5**, **9**) (**Random** number **5** to **9**)_

8. **Config.PaletoItem** _and_ **Config.PacificItem** _are not used at this moment, but will most likely be used when I add Paleto and Fleeca Robberies!_

# Dependencies 

1. _[hacking](https://github.com/Jesper-Hustad/NoPixel-minigame/tree/main/fivem-script) from [Jesper-Hustad](https://github.com/Jesper-Hustad)_

2. [qb-target](https://github.com/qbcore-framework/qb-target) from the QBCore Framework. This most likely will be included with QB Framewoork. 

3. _***If you have Config.TwoHack enabled, you also will need:*** [mhacking](https://github.com/davedorm/mhacking)_

# Support

If you need support, please join my [discord](https://discord.gg/sYpsygQ7jV)!

