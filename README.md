# Quickshell-Rice (Name needed before release)
 
This is my first Quickshell config. It has many features I have not seen in other configs of any widget system, like built in _**LYRICS**_!

[insert cool showcase vid]

## Features

### Media player with (synced) lyrics

<img width="673" height="475" alt="media player image" src="https://github.com/user-attachments/assets/6d8b9053-e41c-4c09-a5ba-b9e339a7aa64" />

The media player loads lyrics from lrclib. Also works with local files with correct metadata. (This currently has some jank with certain settings. See Known issues)

### Cool power menu

<img width="343" height="355" alt="image" src="https://github.com/user-attachments/assets/73f38000-2008-4625-8f7f-48baa49ee47a" />

The buttons show an icon when hovered on!

### And many others...

## Known issues

### Media length not updated correctly when using browser based players

This issue is currently addressed with a setting in `settings.json` called `"resetPositionOnTrackChange"`, but that has the issue that you may lose saved progress on media.

### Media position not updated correctly when using browser based players

This issue is also currently addressed with a setting in `settings.json` called `"saveLoadPositionOnPlayPause"`, but that has the issue that play/pause feels a little janky because it snaps back to the start of the current second.

## Installation

1. Install quickshell (on arch: `pacman -S quickshell`)
2. Clone this repo into a folder
3. Add `exec-once qs -p /path/to/folder` to your hyprland.conf (You can also run once from the terminal with `qs -p /path/to/folder`)
4. Profit.

## Editing settings

The settings can be found in the installation folder as `settings.json`. A graphical interface is planned.

*Multi choice settings have the value as a number. Remember that the values start from 0, so the first choice is 0 and the second is 1 and so on.
