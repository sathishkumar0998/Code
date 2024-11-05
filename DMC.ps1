
# Define the screenshots folder path
$screenshotsFolder = "C:\Users\Administrator\Desktop\test"

# Function to take a screenshot with a delay
function Take-ScreenshotWithDelay {
    param(
        [string]$OutputPath,
        [string]$FunctionName,
        [int]$DelaySeconds = 5
    )
    
    Start-Sleep -Seconds $DelaySeconds
    
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen
    $bounds = $screen.Bounds
    $bitmap = New-Object System.Drawing.Bitmap($bounds.Width, $bounds.Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $screenshotPath = Join-Path -Path $OutputPath -ChildPath ("Screenshot_{0}_{1}.png" -f $FunctionName, $timestamp)
    
    try {
        $bitmap.Save($screenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)
        Write-Output "Screenshot saved to: $screenshotPath"
    }
    catch {
        Write-Output "Failed to save screenshot: $_"
    }
    finally {
        $bitmap.Dispose()
    }
}

# Function to start an application if it exists
function Start-Application {
    param(
        [string]$ExecutablePath
    )

    if (Test-Path $ExecutablePath -PathType Leaf) {
        Start-Process $ExecutablePath
    } else {
        Write-Host "$ExecutablePath not found."
    }
}

# Function to start TeamViewer if available
function Start-TeamViewer {
    $possiblePaths = @(
        "${env:ProgramFiles(x86)}\TeamViewer\TeamViewer.exe",
        "${env:ProgramFiles}\TeamViewer\TeamViewer.exe"
    )

    foreach ($path in $possiblePaths) {
        if (Test-Path $path -PathType Leaf) {
            Start-Process -FilePath $path
            return
        }
    }

    Write-Host "TeamViewer not found."
}

# Function to start TightVNC Viewer if available
function Start-TightVNCViewer {
    $possiblePaths = @(
        "${env:ProgramFiles(x86)}\TightVNC\tvnviewer.exe",
        "${env:ProgramFiles}\TightVNC\tvnviewer.exe"
    )

    foreach ($path in $possiblePaths) {
        if (Test-Path $path -PathType Leaf) {
            Start-Process -FilePath $path
            return
        }
    }

    Write-Host "TightVNC Viewer not found."
}
#create folder
mkdir Desktop\DMC

# Start 'About' settings
$aboutSystemPath = "ms-settings:about"
Start-Process $aboutSystemPath
Take-ScreenshotWithDelay -OutputPath $screenshotsFolder -FunctionName "AboutSettings"

# Start 'Windows Update' settings
$updateHistoryPath = "ms-settings:windowsupdate-history"
Start-Process $updateHistoryPath
Take-ScreenshotWithDelay -OutputPath $screenshotsFolder -FunctionName "WindowsUpdateSettings"

# Start 'Activation' settings
$activationPath = "ms-settings:activation"
Start-Process $activationPath
Take-ScreenshotWithDelay -OutputPath $screenshotsFolder -FunctionName "ActivationSettings"

# Start 'Ethernet' network settings
$networkSettingsPath = "ms-settings:network-ethernet"
Start-Process $networkSettingsPath
Take-ScreenshotWithDelay -OutputPath $screenshotsFolder -FunctionName "EthernetSettings"

# Open 'Programs and Features'
Start-Process control.exe -ArgumentList "/name Microsoft.ProgramsAndFeatures"
Take-ScreenshotWithDelay -OutputPath $screenshotsFolder -FunctionName "ProgramsAndFeatures"

# Start Symantec Endpoint Protection UI if available
$sepExePath = "C:\Program Files\Symantec\Symantec Endpoint Protection\14.3.10148.8000.105\Bin64\SymCorpUI.exe"
Start-Application -ExecutablePath $sepExePath

# Wait longer for Symantec to prompt for password (15 seconds)
Start-Sleep -Seconds 15
Take-ScreenshotWithDelay -OutputPath $screenshotsFolder -FunctionName "SymantecUI"

# Start TeamViewer
Start-TeamViewer
Take-ScreenshotWithDelay -OutputPath $screenshotsFolder -FunctionName "TeamViewer"

# Start TightVNC Viewer
Start-TightVNCViewer
Take-ScreenshotWithDelay -OutputPath $screenshotsFolder -FunctionName "TightVNCViewer"

# Open File Explorer to C:\Users
$directoryPath = "C:\Users"
Invoke-Item -Path $directoryPath
Take-ScreenshotWithDelay -OutputPath $screenshotsFolder -FunctionName "FileExplorer"

# Final message
Write-Output "Script execution completed."

