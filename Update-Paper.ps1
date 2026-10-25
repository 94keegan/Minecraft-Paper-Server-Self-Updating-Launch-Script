# ==========================================
# Configuration
# ==========================================

$Version = "26.3"
$DeleteOldBuilds = $true

$Headers = @{
    "User-Agent" = "PaperAutoUpdater/1.1"
}

# ==========================================
# Download Function
# ==========================================

function Download-FileWithProgress {
    param (
        [string]$Url,
        [string]$OutputFile
    )

    $request = [System.Net.HttpWebRequest]::Create($Url)
    $response = $request.GetResponse()

    $totalBytes = $response.ContentLength
    $totalMB = [math]::Round($totalBytes / 1MB, 2)

    $stream = $response.GetResponseStream()
    $fileStream = [System.IO.File]::Create($OutputFile)

    $buffer = New-Object byte[] 65536
    $downloadedBytes = 0

    while (($read = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {

        $fileStream.Write($buffer, 0, $read)
        $downloadedBytes += $read

        $downloadedMB = [math]::Round($downloadedBytes / 1MB, 2)
        $percent = [math]::Round(($downloadedBytes / $totalBytes) * 100)

        Write-Host -NoNewline "`r[INFO] Downloading: $downloadedMB MB / $totalMB MB ($percent%)"
    }

    $fileStream.Close()
    $stream.Close()
    $response.Close()

    Write-Host ""
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

        Download-FileWithProgress `
            -Url $DownloadUrl `
            -OutputFile $JarName

        Write-Host "[SUCCESS] Update complete." -ForegroundColor Green
    }
    catch {
        Write-Host ""
        Write-Host "[ERROR] Download failed." -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        exit 1
    }

}
else {

    Write-Host "[SUCCESS] Already up to date." -ForegroundColor Green

}

Write-Host "[SUCCESS] Ready to launch." -ForegroundColor Green