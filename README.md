# CFC Restart Lib
Library to initiate, schedule, and cancel server restarts

# Overview
On CFC, we have a backend service that receives authenticated web requests and issues an OS-level game restart. This allows us to fully restart the server from within the GLua environment. We use it for a few things, most notably we have an in-game timer that restarts the server once per day. We also have a ULX command that uses this library to restart the server.

There are many possibilities, it's really up to you.

**Note:** This addon only sends a web request, it's up to you to make a web server that will actually do something with the request.

# Installation
Because the Restart Lib is a Moonscript addon, you'll need to use a moonscript compiler to get some Lua that you can run.
(At some point we'll add compiled lua files in the releases tab)

Once you've converted to lua, you can just plop the project into your addons folder

# Usage

## Setup
First, you need to create two files:
In `garrysmod/data/cfc/restart/url.txt`, you need to put the full URL of the endpoint that will restart the server.

You'll need to create `garrysmod/data/cfc/restart/token.txt` - the Restart Lib sends along a token with its request that you can use to help verify that the request actually came from your gmod server. If you don't want to use this feature, you can leave the file empty, but the addon expects it to exist so you still need to create it.

CFC Restart Lib is a require-able library, so in your code you'll need to do `require( "cfc_restart_lib" )` before using it.

## Examples

### Simple Restart
```lua
require("cfc_restart_lib")

local restarter = CFCRestartLib()

restarter:restart()
```

And.. that's it! It'll immediately fire off a request to the restart URL with the contents of `data/cfc/restart/url.txt`.


### Scheduled Restart
```lua
require( "cfc_restart_lib" )

local restartDelay = 5 -- in seconds
local restarter = CFCRestartLib()

restart:scheduleRestart( restartDelay )
```
In 5 seconds, the Restarter will initiate a restart.

### Cancelling a Scheduled Restart
```lua
require( "cfc_restart_lib" )

local restartDelay = 5 -- in seconds
local restarter = CFCRestartLib()

restart:scheduleRestart( restartDelay )

timer.Simple( restartDelay - 1, function()
    -- Cancel the scheduled restart
    restarter:stopTimer()
end )
```
In this example, we start a scheduled restart, but cancel it 1 second before it fires.

# API
There are two ways you can use restarter;
 1. Using the `restart()` method, which will restart the server immediately
 2. Using the `scheduleRestart( delay, reason )` method, which will wait for `delay` seconds before firing the request (The `reason` param currently isn't used)
 
 The Restart Lib also allows you to set your own `onSuccess` and `onFailure` methods for each instance of the Restart Lib.
 See here:
 ```lua
 require( "cfc_restart_lib" )
 
 local restarter = CFCRestartLib()
 
 restarter.onSuccess = function( data )
     print( "Restarter did a thing goodly!" )
 end
 
 restarter.onFailure = function( data )
     PrintTable( data )
     error( "Oh heck that boy didn't work" )
 end
 ```
