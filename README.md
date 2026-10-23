# Minecraft-Paper-Server-Self-Updating-Launch-Script
Automatically checks for the latest Paper build before starting your Minecraft server.

## Features

- Checks the PaperMC Downloads API for the latest build
- Downloads new builds automatically
- Skips download if the latest build is already installed
- Removes old Paper JAR files
- Launches the newest Paper server automatically

## Requirements

- Windows 10 / Windows 11
- PowerShell 5+
- Java 25+ (required for Minecraft/Paper 26.3)

## Installation

1. Download:
   - `StartServer.bat`
   - `Update-Paper.ps1`

2. Place both files in your Paper server folder.

3. Edit `Update-Paper.ps1` and set your desired version:

```powershell
$version = "26.3"
```

4. Start your server using:

```text
StartServer.bat
```

## How It Works

1. Checks the latest available Paper build.
2. Compares it to local files.
3. Downloads the newest build if necessary.
4. Removes older builds.
5. Starts the newest server JAR.

## License

MIT License
