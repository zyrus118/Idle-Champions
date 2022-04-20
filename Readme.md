# Test Branch
## This branch is for testing a refactored memory system

The ultimate goal of this branch is to create a refactored memory system that functions as well or better than the existing system that will continue to work with existing scripts and add ons and includes a new feature to automate or mostly automate updating offsets when CNE pushes out new patches.

Currently only works on Steam v425.1

## TO DO
1. Finish to do list
2. Test gem farm and add ons
3. Create add on for offset updater.
4. Figure out how to make a to do list auto number, or remove numbering.
7. Iterate on and refine changes
8. Create new or modify existing docs for all changes
10. Rethink file convention for memory structure files

## Known Issues
1. Azaka, NERDs, and No Modron Leveling add ons are probably broken.

## Change Log
4/19/22

    Semi functional offset updater.
    EGS now supported.
    Continued restructuring of files.

4/17/22

    Refactored server call class to not rely on GameSettings memory reads, now uses web request log.
    Revised gem farm and shared functions for refactored server call class.
    Refactored chest buy/open add on to not rely on chest data memory reads, now uses local cached defs as source with ability to resource from main cached defs.
    Added comments to memory structure files to assist in auto updating.

4/15/22

    Additional reorganization of memory structure base objects.
    
4/14/22

    Renamed memory structure base objects to align more closely to .NET naming convention

4/10/22

    Added simple logging to test methods for determining champions max level are actually working.
    Updated GameSettings and EngineSettings memory structures, for both Steam and EGS.

4/9/22

    Updated to v425.1 Steam
    Create new shared function library for leveling.
    Create new methods to determine champions max level.
    Memory Tree View is now an add on.

# IC Script Hub
## Introduction

> "This is your last chance. After this, there is no turning back. You take the blue pill—the story ends, you wake up in your bed and believe whatever you want to believe. You take the red pill—you stay in Wonderland, and I show you how deep the rabbit hole goes. Remember: all I'm offering is the truth. Nothing more." 
>  
> --- Morpheus 


> "I feel the need, the need for speed!"
> 
> --- Maverick

Welcome to 2022 and Happy New Year!  

New year, new script. We hope you like it.   
  
This script is the successor to ModronGUI.

**Warning**:
This script reads system memory. I do not know CNE's stance on reading system memory used by the game, so use at your own risk. Pointers may break on any given update and I may no longer decide to update them.  


## Prerequisites

You need AutoHotKey installed to be able to use `IC Script Hub`. The version of AutoHotKey installed also needs to support the switch command. 

[Download AutoHotKey](https://www.autohotkey.com/)

It is recommended that you set up Git and pull `IC Script Hub` via Git. 

This will be the easiest way for you to keep up to date with any changes made in the future. There is a little bit more to do upfront, but you will save so much time in the long run (kinda like scripting the game in the first place).

You may use any Git client you wish. [Here is a step-by-step guide](docfiles/getting-started-with-ic-script-hub-using-git.md) to installing and using Git Desktop with `IC Script Hub`.

If you would rather grab the latest version of the code manually, [head over here to learn how to do that](docfiles/getting-started-with-ic-script-hub-using-zip.md). I really don't recommend it though, as you will have to repeat this entire process every single time as opposed to simply opening an application and clicking a button.

## I know Git Fu!

You now have the latest version of `IC Script Hub` on your machine.

Let's go down the rabbit hole and see what awaits.

Where do you play the game?

[I play on Steam](docfiles/using-ic-script-hub-with-steam.md) 

[I play on EGS](docfiles/using-ic-script-hub-with-egs.md)

## Reading this documentation offline

You can open Readme.md (this file) in any Markdown editor on Windows that has a preview function. I use VS Code. 

1. Open the repository folder in VS Code
2. Open Readme.md
3. Press `Control+Shift+V` or right click on the file tab and pick `Open Preview`
4. Read and navigate using the preview pane that just opened



