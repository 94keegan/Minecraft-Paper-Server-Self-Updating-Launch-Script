# ==========================================
# Configuration
# ==========================================

$Version = "26.3"
$DeleteOldBuilds = $true

$Headers = @{
    "User-Agent" = "PaperAutoUpdater/1.1"
}

# ==========================================
# Check Latest Build
# ==========================================

Write-Host "[INFO] Checking latest Paper build for $Version..." -ForegroundColor Cyan

try {

    $VersionInfo = Invoke-RestMethod `
        -Headers $Headers `
        -Uri "https://fill.papermc.io/v3/projects/paper/versions/$Version"

    $Build = $VersionInfo.builds[0]

    Write-Host "[INFO] Latest build: $Build" -ForegroundColor Cyan

    $BuildInfo = Invoke-RestMethod `
        -Headers $Headers `
        -Uri "https://fill.papermc.io/v3/projects/paper/versions/$Version/builds/$Build"

}
catch {
    Write-Host "[ERROR] Failed to contact PaperMC API." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

$DownloadUrl = $BuildInfo.downloads."server:default".url

if (-not $DownloadUrl) {
    Write-Host "[ERROR] Failed to obtain download URL." -ForegroundColor Red
    exit 1
}

$JarName = Split-Path $DownloadUrl -Leaf

Write-Host "[INFO] Latest JAR: $JarName" -ForegroundColor Cyan

# ==========================================
# Update Logic
# ==========================================

if (-not (Test-Path $JarName)) {

    Write-Host "[INFO] New build detected." -ForegroundColor Yellow

    if ($DeleteOldBuilds) {

        Write-Host "[INFO] Removing old Paper builds..." -ForegroundColor Yellow

        Get-ChildItem "paper-*.jar" -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -ne $JarName } |
            Remove-Item -Force
    }

    try {

        Write-Host "[INFO] Downloading latest Paper..." -ForegroundColor Yellow

        Invoke-WebRequest `
            -Uri $DownloadUrl `
            -OutFile $JarName

        Write-Host "[SUCCESS] Update complete." -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Download failed." -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        exit 1
    }

}
else {

    Write-Host "[SUCCESS] Already up to date." -ForegroundColor Green

}

Write-Host "[SUCCESS] Ready to launch." -ForegroundColor Green