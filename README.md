This is Kriti-shell. It has many features I have not seen in other configs of any widget system, like built in _**LYRICS**_!
[insert cool showcase vid]

## Notable features
### Media player with synced lyrics
<img width="759" height="490" alt="image" src="https://github.com/user-attachments/assets/a2c96269-c7fe-4ee9-a5d4-40f00a0bf933" />

The media player loads lyrics from lrclib. Also works with local files with correct metadata. 
##### with a pop out window:
<img width="431" height="518" alt="image" src="https://github.com/user-attachments/assets/9c913a28-d1ac-4103-89ce-e4a6b5cef901" />

### Power menu
![2025-09-07 17-34-00](https://github.com/user-attachments/assets/b66d8628-da46-41f9-95e2-39ecee7f2ed8)

### App menu
<img width="709" height="485" alt="image" src="https://github.com/user-attachments/assets/5036304b-429d-4fb4-b3f2-588d8abe20c4" />

## Known issues
### ~~Media length not updated correctly when using browser based players~~ Seems entirely fixed now when using Firefox.
This issue is currently addressed with a setting in `settings.json` called `"resetPositionOnTrackChange"`, but that has the issue that you may lose saved progress on media when switching to another tab with media.

### ~~Media position not updated correctly when using browser based players~~ Seems mostly fixed now when using Firefox.
This issue is also currently addressed with a setting in `settings.json` called `"saveLoadPositionOnPlayPause"`, but that has the issue that play/pause feels a little janky because it snaps back to the start of the current second.

## Installation

1. Install quickshell (on arch: `pacman -S quickshell`)
2. Make sure you have installed: `curl` (and optionally: `pw-volume`)
3. Clone this repo into `.config/quickshell/Kriti-shell`
4. Add `exec-once qs -c Kriti-shell` to your hyprland.conf (You can also run once from the terminal with `qs -c Kriti-shell`)
5. Add `bind = $mainMod, SPACE , exec, qs -c Kriti-shell ipc call appMenu toggle `
6. Profit.

## Editing settings

The settings can be found in the installation folder as `settings.json` after first launch. A graphical interface is planned.

*Multi choice settings have the value as a number. Remember that the values start from 0, so the first choice is 0 and the second is 1 and so on.
