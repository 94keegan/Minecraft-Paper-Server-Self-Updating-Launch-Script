# Paper Auto Updater

Automatically updates your PaperMC server to the latest available build before startup.

## Features

- Automatically checks for new Paper builds
- Downloads updates only when required
- Launches the newest Paper server JAR
- Optional cleanup of old builds
- Configurable memory allocation
- Colored PowerShell status messages
- Error handling for API and download failures

## Requirements

- Windows 10 or Windows 11
- PowerShell 5.1+
- Java 25 or newer
- Internet connection for update checks

## Installation

1. Download:
   - `StartServer.bat`
   - `Update-Paper.ps1`

2. Place both files in your Paper server directory.

3. Run:

   ```text
   StartServer.bat
   ```

The updater will automatically:

1. Check the PaperMC API
2. Compare the latest build against local files
3. Download new builds when available
4. Remove old builds (optional)
5. Start the newest server JAR

---

## Configuration

### StartServer.bat

Edit these values to change how much RAM is allocated to your server:

```bat
set MIN_RAM=4096M
set MAX_RAM=4096M
```

Example:

```bat
set MIN_RAM=8G
set MAX_RAM=8G
```

---

### Update-Paper.ps1

Set the Paper version:

```powershell
$Version = "26.3"
```

Enable or disable removal of old JAR files:

```powershell
$DeleteOldBuilds = $true
```

Options:

```powershell
$DeleteOldBuilds = $true
```

Deletes old Paper builds after downloading