---
id: 3492
title: How to Build a Custom Minecraft Server for Friends and Family
date: 2015-09-09T23:03:16+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/09/09/how-to-build-a-custom-minecraft-server-for-friends-and-family/
categories:
  - Makro Factory
tags:
  - HomeSpawnPlus
  - Lobby
  - Microsoft
  - Minecraft
  - Multiverse
  - Nether
  - NetherPortals
  - PermissionsEx
  - PerWorldInventory
  - Portals
  - SpigotMC
  - VoidWorld
  - WorldEdit
---
I have recently build a custom Minecraft server for some friends. Although there is a lot of content about Minecraft and the server software out there, I have not found a comprehensive guide how to go about this. Therefore this post describes how I have built and configured the server software.

<!--more-->

Note that this will not work for Minecraft Pocket Edition as these clients have a limited feature set and require dedicated server software.

## Minecraft Server Software

There are several different Minecraft server available:

  * The [vanilla server](https://minecraft.net/download) is provided by Mojang and does not support any kind of plugins.
  * The [CraftBukkit](http://wiki.bukkit.org/Setting_up_a_server) server has been the standard for Minecraft server for a long time but has been taken offline due to the DMCA
  * I am using [SpigotMC](https://www.spigotmc.org/) which seems to be a very popular Minecraft server software

In the course of the following sections I will also cover which plugins I am using.

Note: The SpigotMC server is not provided as a binary download. You will have to compile it yourself. After downloading the [BuildTools.jar](https://www.spigotmc.org/wiki/buildtools/#running-buildtools) and installing [Git](http://www.git-scm.com/) use the following batch script to build it **(Update 2015-09-28: the script now downloads the latest build tools automatically)**:

```
@Echo Off

Set JAVA_HOME=d:\OneDrive\Apps\Java
Set Path=%Path%;%JAVA_HOME%\bin

Set BaseDir=%~dp0
Set BashDir=C:\Program Files (x86)\Git\bin\bash.exe

Set BuildToolsUri=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
powershell -Command "Invoke-WebRequest -Uri '%BuildToolsUri%' -OutFile '%BaseDir%\BuildTools.jar'"

"%BashDir%" --login -i -c "java -jar ""%BaseDir%\BuildTools.jar"""

Pause
```

## Basic Setup

The Minecraft server software is written in Java. Looking back at more than a year with many security issues, this makes me uncomfortable. Therefore it is imperative that you do not execute the server with a privileges user account.

I am using the following batch script to start the server:

```
@Echo Off

Echo Testing for administrative rights
For /f "UseBackQ" %%i In (`WhoAmI /Groups ^| Find /c /i "BUILTIN\Administrators"`) Do Set IsAdministrator=%%i
If "%IsAdministrator%" == "1" (
    Echo Running as normal user
    Start RunAs.exe /User:%ComputerName%\minecraft "%~0"
    Exit
)

Echo Running as user %username%

Set JAVA_HOME=%~dp0..\Java
Set PATH=%PATH%;%JAVA_HOME%\Bin

%~d0
cd "%~dp0"
Java -Xmx1024M -Xms32M -jar "%~dp0spigot-1.8.8.jar" -W ./worlds

Pause
```

**(Update 2015-10-04: I removed the Pause at the end of the script to support automatic server restarts which I described further down.)**

You will have to decide how much initial (-Xms) and peak (-Xmx) memory is used my the Java virtual machine which is running the Minecraft server. I am assuming that each user will require up to 100MB which was deducted from several posts on well-known minecraft forums.

There are many reasons why you want easy access to the Minecraft server console. I decided to install [RemoteBukkit](http://www.curse.com/bukkit-plugins/minecraft/remotebukkit) (plugin and GUI) and use the above script with the following call to connect to it:

`start "" Java -jar "%~dp0remotebukkitgui-2.0.0.jar"`

## Basic Configuration

The basic configuration files are generated after you have launched the server for the first time!

You will first have to take a closer look at server.properties. The following parameters are most important:

  * Use `server-ip` if you need to restrict the listener to a certain IP address on a multi-homed server
  * The `server-port` defaults to 25565
  * The `server-name` is the display name in the client
  * The "Message of the Day" (`motd`) is displayed with the name of the server
  * If you are running a private server, set `white-list` to `true`
  * The `max-players` parameter specifies the maximum number of concurrent players including operators
  * The `level-name` specifies the world users spawn in

I have decided to use whitelisting because the server is restricted to friends and family. You need to set`` in `server.properties` to `true` and add the appropriate accounts to the whitelist from the server console. The easiest way to determine names and UIDs is to tell players to attempt a connection. Of course, this will fail initially because they have not been added to the whitelist. But the corresponding error message provides you with all the details to issue the following command:

`whitelist add &lt;playername&gt;`

**Update (2015-10-04):** The Minecraft server can automatically restart in case of a crash or when the console command restart was issued. This requires that the parameter `restart-script` in `spigot.yml` is configured accordingly. I am using the following setting to have it automatically call my start script:

`restart-script: ./Start.cmd`

**(End of Update)**

## Permissions

The most important thing on a multiplayer server is proper management of permissions to restrict players to the exact right necessary. I am using [PermissionsEx](http://dev.bukkit.org/bukkit-plugins/permissionsex/) and have decided to explicitly allow individual permissions.

Minecraft manages permissions as a dot-separated string where the first item specifies the plugin that recognizes the permission node. For example, `minecraft.command.give` is an internal permission node for the `give` command.

Premission nodes may contain the wildcard character * to indicate that all sub permission nodes are to be handled in the same way. For example, `minecraft.command.*` matches all internals commands.

PermissionsEx offers groups to defined standardized sets of permissions. These groups can be assigned to users. See the following example:

```
users:

  00000000-0000-0000-0000-000000000000:
    group:
    - Default_Player
    options:
      name: player0


groups:

  Default_Player:
    permissions:
    - minecraft.command.(say|tell|kill|me|help|version|plugins)
    - -minecraft.command.*
    - -permissions.*
    options:
      default: true

  Server_Admin:
    permissions:
    - permissions.*

schema-version: 1</pre>

Note that specific permissions need to be listed before more general entries. The same applies to allow and deny rules. The latter is prefixed with a - (dash). The following two lines define that only the listed commands are allowed and all other denied:

<pre class="">- minecraft.command.(say|tell|kill|me|help|version|plugins)
- -minecraft.command.*
```

If those lines are reversed, PermissionsEx will not process the allowed permissions and therefore deny all commands.

## Multiple Worlds

If you are running the server for your friends, they may soon ask for their own private world to play on their own. Or they want different worlds for separate sets of players. As soon as that happens you need to decide if you want to dive into managing multiple worlds but this can be a lot of fun as well as frustration.

From what I have learnt, there is no real alternative to using [Multiverse](http://dev.bukkit.org/bukkit-plugins/multiverse-core/) for multi world management. Multiverse consist of several plugins to address different aspects of multiple worlds:

  * [Multiverse Core](https://github.com/Multiverse/Multiverse-Core/wiki) enables players to spawn in different worlds and teleport between those worlds
  * [Multiverse Portals](https://github.com/Multiverse/Multiverse-Portals/wiki) adds portals to teleport between worlds. This is considered supperior to using the teleport command because it enhanced the game experience
  * [Multiverse NetherPortals](https://github.com/Multiverse/Multiverse-NetherPortals/wiki) enables portals to nether and end worlds

Important: Most download pages for plugins offer version 2.4-AB (Awesome Build) of Multiverse. This version is old and actually deprecated. Use development builds instead. They are provided on the Multiverse Jenkins server. Builds marked as green have been successfully tested with automatic tests. I am currently running [Multiverse-Core b697](http://ci.onarandombox.com/view/Multiverse/job/Multiverse-Core/697/), [Multiverse-Portals b723](http://ci.onarandombox.com/view/Multiverse/job/Multiverse-Portals/723/) and [Multiverse-NetherPortals b692](http://ci.onarandombox.com/view/Multiverse/job/Multiverse-NetherPortals/692/) without any problems.

Multiverse is configured through two files located in the plugin directory: config.yml and worlds.yml. You can either modify those files directly or change the settings through console commands. I noticed that I hardly need to look at the Multiverse configuration except for changing the gamemode for individual worlds.

But it is even more important to manage permissions even more carefully than for a single world on a multiplayer server. Players will require different permissions based on their involvement with acertain world. For example:

  * If a survival world is shared among several players, they require identical permissions
  * Some players may require some or all cheats in their survival world
  * Some worlds may require modify permissions for one or a few players while other players will only interact with existing or prebuilt structures

I have started to defined several groups for each type of world to allow for these use cases:

```
users:

  00000000-0000-0000-0000-000000000000:
    group:
    - World_Utopia_Player
    - World_Utopia_Designer
    - Lobby_Designer
    - Default_Player
    options:
      name: player0

  00000000-0000-0000-0000-000000000000:
    group:
    - World_Utopia_Player
    - Default_Player
    options:
      name: player1


groups:

  Default_Player:
    permissions:
    - minecraft.command.(say|tell|kill|me|help|version|plugins)
    - -minecraft.command.*
    - -permissions.*
    - multiverse.help
    - multiverse.access.Lobby
    - multiverse.portal.access.*
    - multiverse.core.spawn.self
    - -multiverse.*
    - -modifyworld.*
    options:
      default: true

  Teleporter:
    permissions:
    - multiverse.teleport.self.w

  Server_Admin:
    permissions:
    - bukkit.command.*
    - permissions.*

  Multiverse_Admin:
    permissions:
    - multiverse.*
    - worldedit.*

  Lobby_Designer:
    worlds:
      Lobby:
      - modifyworld.*

  World_Utopia_Player:
    permissions:
    - multiverse.access.Utopia
    - multiverse.access.Utopia_nether
    - multiverse.access.Utopia_the_end

  World_Utopia_Designer:
    worlds:
      Utopia:
        permissions:
        - modifyworld.*


worlds:
  Utopia_nether:
    inheritance:
    - Utopia
  Utopia_the_end:
    inheritance:
    - Utopia

schema-version: 1
```

If players are moving among different worlds, it may be undesirable to let them mode their inventory with them. To address this issue I have installed [PerWorldInventories](http://dev.bukkit.org/bukkit-plugins/world-inventory/). This plugin keeps separate inventories for all worlds. You can define exceptions for a set of worlds which require a shared inventory. For example, normal, nether and end worlds need to have a shared inventory.

## Building a Lobby

If you are running multiple worlds, a lobby is a nice way to give your players access to different worlds. I have created a lobby from scratch using [VoidWorld](http://dev.bukkit.org/bukkit-plugins/voidworld/) as a generator and then adding the first block using [WorldEdit](http://dev.bukkit.org/bukkit-plugins/worldedit/) (/up 1).

I have portals leading to the different worlds and add a portal leading back to the lobby in every survival world. That way it is not necessary to allow the use of cross world teleport commands.

## Advanced configuration

**Update (2015-09-28):** If your players are running their worlds in different gamemodes, set the `force-gamemode` parameter in `server.properties` to `true` to make sure the preconfigured gamemode is enforced for each world.**(End of Update)**

**Update (2015-10-04):** If a player decided to work with command blocks in a creative world, you will quickly realize how messy the internal permission system of the vanilla server is. Because of this you will have to op such a player (with permission level 2) to allow editing command blocks. This is necessary on top of the permissions to put command blocks in the inventory. Unfortunately, the server commands only support making someone an operator. This operator will then receive the `op-permission-level` specified in `server.properties`. In my case, I have set the following to limit new operators to level 2:

`op-permission-level=2`

Note that handling permissions with a plug in like PermissionsEx restricts those operators to the command and behaviour specified in `permissions.yml`. I have already provided several examples how to work with permissions. The following permissions are equivalent to enabling cheats in a single player world.

```
World_MyWorld_Designer:
  worlds:
    MyWorld:
      permissions:
      - modifyworld.*
      - worldedit.*
      - minecraft.command.(difficulty|gamemode|gamerule)
      - minecraft.command.(clear|time|summon|toggledownfall|weather)
      - minecraft.command.(achievement|clear|effect|enchant|give|scoreboard|setblock|spreadsplayers|testfor|testforblock|tp|xp)
```

To enable command blocks you need to enable the `give` command.**(End of Update)**

If you have ambitious players they will want to cross into the nether or the end. The portals leading there wil not work out of the box although you have Multiverse-NetherPortals installed. You need to link the world using the following command:

```
/mvnp link nether Utopia Utopia_nether
/mvtp link end Utopia Utopia_the_end
```

**Update (2015-09-28):** In my case I have players with multiple worlds who do not want to return to the lobby themselves to enter another world. Let's take a closer look at my requirements:

  * When a player connects to the server, he/she is to be spawned in the default world (configured by `level-name` in `server.properties`)
  * When a player dies, he/she must return to the bed
  * When a player disconnects, his/her position must be stored for spawning later
  * When a player uses a portal to enter a world from the lobby, he/she must spawn at his/her last location

For this scenario to work, I installed [HomeSpawnPlus](http://dev.bukkit.org/bukkit-plugins/homespawnplus/). This plugin implements different strategies for spawning players on event like joining a server or respawning after dying. The configuration is rather complex but the author has provided documentation as well as detailed examples. I have created the following configuration to meet the requirements:

```
# Web doc reference for event strategies:
# http://dev.bukkit.org/server-mods/homespawnplus/pages/strategy-doc/
#
events:
# strategies to use when player is joining the game
onJoin:
- spawnDefaultWorld
- default

# strategies to use when player is respawning after a death
onDeath:
- modeHomeBedOnly
- homeMultiWorld
- modeDefault
- spawnLocalWorld

# strategies to use when player types "/spawn"
onSpawnCommand:
- spawnLocalWorld
- spawnDefaultWorld

# strategies to use when player types "/groupspawn"
onGroupSpawnCommand:
- spawnGroup

# strategies to use when player types "/home"
onHomeCommand:
- homeMultiWorld

# strategies to use when player types "/home name"
onNamedHomeCommand:
- homeNamedHome

# strategies to use when player types "/spawn name"
onNamedSpawnCommand:
- spawnNamedSpawn

# a crossWorld teleport that didn't involve Multiverse
crossWorldTeleport:
- default

# a crossWorld teleport by Multiverse
multiverseCrossWorldTeleport:
- SpawnLastLocation
- homeLocalWorld
- SpawnLocalPlayerSpawn
#- modeRememberLocation
#- SpawnWorldRandom
- modeDefault
- default

# a non-crossWorld teleport by Multiverse
multiverseTeleport:
- default
```

**(End of Update)**

## More Stuff?

I guess I have missed a lot of information about issues I have come across. I will update this post whenever I remember something ;-)
