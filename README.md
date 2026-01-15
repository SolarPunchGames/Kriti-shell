# Kriti-shell
This is Kriti-shell. It has many features I have not seen in other configs of any widget system, like built in _**LYRICS**_!

[Video here](https://www.youtube.com/watch?v=I7NS3uAZfyI) since it is too long to upload directly in github.

## Notable features
### Media player with synced lyrics
<img width="633" height="470" alt="image" src="https://github.com/user-attachments/assets/c69a4cb2-8393-45ed-8243-9e40ae1a3594" />

<img width="340" height="440" alt="image" src="https://github.com/user-attachments/assets/f767fcc2-7ba3-464e-9a35-88d93494c418" />

<img width="340" height="470" alt="image" src="https://github.com/user-attachments/assets/5585bdd3-ac94-42a8-a02e-30f4edc71301" />

The media player automatically loads lyrics from lrclib. Also works with local files with correct metadata. 

You can also search for lyrics, if Kriti-shell does not automatically find them.

### Power menu
![2025-09-07 17-34-00](https://github.com/user-attachments/assets/b66d8628-da46-41f9-95e2-39ecee7f2ed8)

### App menu
<img width="709" height="485" alt="image" src="https://github.com/user-attachments/assets/5036304b-429d-4fb4-b3f2-588d8abe20c4" />

### Right click menus
<img width="242" height="293" alt="image" src="https://github.com/user-attachments/assets/df718dc3-58b8-4bf9-b71c-c84db8ac9379" />
<img width="297" height="107" alt="image" src="https://github.com/user-attachments/assets/2ce62a31-7213-4dc1-a1d7-9b7b7dac0090" />

## Known issues
### ~~Media length not updated correctly when using browser based players~~ 
> [!Note]
> Seems entirely fixed now when using Firefox.

This issue is currently addressed with a setting in `settings.json` called `"resetPositionOnTrackChange"`, but that has the issue that you may lose saved progress on media when switching to another tab with media.

### ~~Media position not updated correctly when using browser based players~~ 
> [!Note]
> Seems mostly fixed now when using Firefox.

This issue is also currently addressed with a setting in `settings.json` called `"saveLoadPositionOnPlayPause"`, but that has the issue that play/pause feels a little janky because it snaps back to the start of the current second.

## Updating

> [!Note]
> It is recommended to update Kriti-shell when you update Quickshell. If there are any breaking bugs from Quickshell updates, please make an issue!
>
> The new settings get automatically merged into your settings.json non-destructively.

Run this in the installation folder (usually `.config/quickshell/Kriti-shell`):
```sh
git pull
```

## Installation

1. Install quickshell. For Arch:

   ```sh
   pacman -S quickshell
   ```

2. Make sure you have installed: `curl` (and optionally: `pw-volume`)
3. Clone this repo into `.config/quickshell/Kriti-shell`
   
   ```sh
   git clone https://github.com/SolarPunchGames/Kriti-shell/ ~/.config/quickshell/Kriti-shell
   ```

5. Add `exec-once = qs -c Kriti-shell` to your hyprland.conf (You can also run once from the terminal with `qs -c Kriti-shell`)
6. Add `bind = SUPER, SPACE , exec, qs -c Kriti-shell ipc call appMenu toggle` to your hyprland.conf (edit keybind, if needed)
7. Add `windowrulev2 = float, class:org.quickshell` to your hyprland.conf
8. Profit.

## Editing settings

The settings can be found in the installation folder as `settings.json` after first launch. A graphical interface is planned.

If you want to reset to default settings, remove settings.json. Kriti-shell will ask you to copy defaults back.

*Multi choice settings have the value as a number. Remember that the values start from 0, so the first choice is 0 and the second is 1 and so on.

## Themes

Kriti-shell currently comes with 5 themes:
* `legacy` (The one in the pictures)
* `catppuccinMocha` (Default)
* `catppuccinMacchiato`
* `catppuccinFrappe`
* `catppuccinLatte` (Needs tweaking)

These themes can be set in `settings.json`.

#### Making custom themes

> [!Note]
> This will change.

Edit `Services/Colors.qml` property `themes`. Check the other themes for refrence.

Then you can set the theme in `settings.json`. Theme falls back to default, if it is not found.

## Ipc calls

You can use these for example to make keybinds for Kriti-shell.

Usage:
```sh
qs -c Kriti-shell ipc call <<target>> <<function>>
```

Targets and functions:
* appMenu
	* toggle
* bar
	* openCurrent
	* closeCurrent
	* toggleCurrent
	* openAll
	* openAll
	* closeAll
