# ==========================================
# Paper Auto-Updater
# Downloads the latest Paper build if needed
# ==========================================

# Minecraft/Paper version
$version = "26.3"

# User-Agent required by PaperMC API
$headers = @{
    "User-Agent" = "PaperAutoUpdater/1.0"
}

Write-Host "Checking latest Paper build for $version..."

# Get version information
$versionInfo = Invoke-RestMethod `
    -Headers $headers `
    -Uri "https://fill.papermc.io/v3/projects/paper/versions/$version"

# Newest build is first in the list
$build = $versionInfo.builds[0]

Write-Host "Latest build: $build"

# Get build details
$buildInfo = Invoke-RestMethod `
    -Headers $headers `
    -Uri "https://fill.papermc.io/v3/projects/paper/versions/$version/builds/$build"

$downloadUrl = $buildInfo.downloads."server:default".url

if (-not $downloadUrl) {
    Write-Host "Failed to obtain download URL."
    exit 1
}

$jarName = Split-Path $downloadUrl -Leaf

Write-Host "Latest JAR: $jarName"

# Download only if not already present
if (-not (Test-Path $jarName)) {

    Write-Host "New build detected."

    # Remove older Paper builds
    Get-ChildItem "paper-*.jar" -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -ne $jarName } |
        Remove-Item -Force

    Write-Host "Downloading latest Paper..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $jarName

    Write-Host "Update complete."
}
else {
    Write-Host "Already up to date."
}

Write-Host "Done."