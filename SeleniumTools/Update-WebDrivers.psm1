<#
.SYNOPSIS
    Update-WebDrivers.psm1 - A PowerShell module for updating Selenium WebDrivers for Chrome, Firefox, and Edge browsers.

.DESCRIPTION
    This module automates the process of downloading and updating Selenium WebDrivers for Chrome, Firefox, and Edge browsers.
    It checks for the latest versions, downloads the appropriate files, and updates the local WebDriver executables.

.NOTES
    Version:        1.0
    Author:         Roy Dawson IV
    Creation Date:  9-18-2024
    Purpose/Change: Initial version of the WebDriver update module.

.EXAMPLE
    Import-Module .\Update-WebDrivers.psm1
    Update-WebDrivers -Browser Chrome -Verbose

.LINK
    https://github.com/ImYourBoyRoy/PowershellTools/SeleniumTools
#>

#Requires -Version 5.1
#Requires -Modules @{ModuleName="Microsoft.PowerShell.Archive"; ModuleVersion="1.0.0.0"}

# Module parameters
param (
    [switch]$Verbose
)

# Function to update Chrome WebDriver
function Update-ChromeDriver {
    [CmdletBinding()]
    param (
        [string]$AssembliesPath = "$PSScriptRoot/assemblies"
    )

    begin {
        Write-Verbose "Starting Chrome WebDriver update process"
    }

    process {
        try {
            $LatestChromeStableRelease = Invoke-WebRequest 'https://chromedriver.storage.googleapis.com/LATEST_RELEASE' | Select-Object -ExpandProperty Content
            $ChromeBuilds = @('chromedriver_win32')  # Focusing on Windows for now
            $TempDir = [System.IO.Path]::GetTempPath()

            foreach ($Build in $ChromeBuilds) {
                $BinaryFileName = 'chromedriver.exe'
                $BuildFileName = "$Build.zip"
                
                Write-Verbose "Downloading: $BuildFileName"
                Invoke-WebRequest -OutFile "$($TempDir + $BuildFileName)" "https://chromedriver.storage.googleapis.com/$LatestChromeStableRelease/$BuildFileName" 
                
                Write-Verbose "Expanding: $($TempDir + $BuildFileName) to $AssembliesPath"
                Expand-Archive -Path "$($TempDir + $BuildFileName)" -DestinationPath $AssembliesPath -Force
                
                Write-Verbose "Generating SHA256 Hash File: $AssembliesPath/$BinaryFileName.sha256"
                Get-FileHash -Path "$AssembliesPath/$BinaryFileName" -Algorithm SHA256 | Select-Object -ExpandProperty Hash | Set-Content -Path "$AssembliesPath/$BinaryFileName.sha256" -Force
                
                Remove-Item "$($TempDir + $BuildFileName)" -Force
            }

            Write-Verbose "Chrome WebDriver updated successfully"
        }
        catch {
            Write-Error "Error updating Chrome WebDriver: $_"
        }
    }

    end {
        Write-Verbose "Chrome WebDriver update process completed"
    }
}

# Function to update Edge WebDriver
function Update-EdgeDriver {
    [CmdletBinding()]
    param (
        [string]$AssembliesPath = "$PSScriptRoot/assemblies"
    )

    begin {
        Write-Verbose "Starting Edge WebDriver update process"
    }

    process {
        try {
            $edgeDriverWebsite = "https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/"
            $edgeDriverAvailableVersions = (Invoke-RestMethod $edgeDriverWebsite) -split " " | Where-Object { $_ -like "*href=*win64*" } | ForEach-Object { $_.replace("href=","").replace('"','') }
            $downloadLink = $edgeDriverAvailableVersions | Select-Object -First 1  # Selecting the latest version

            $TempDir = [System.IO.Path]::GetTempPath()
            $TempFile = Join-Path $TempDir "edgedriver_win64.zip"

            Write-Verbose "Downloading Edge WebDriver"
            Invoke-WebRequest $downloadLink -OutFile $TempFile

            Write-Verbose "Expanding Edge WebDriver to $AssembliesPath"
            Expand-Archive $TempFile -DestinationPath $AssembliesPath -Force

            $BinaryFileName = "msedgedriver.exe"
            Write-Verbose "Generating SHA256 Hash File: $AssembliesPath/$BinaryFileName.sha256"
            Get-FileHash -Path "$AssembliesPath/$BinaryFileName" -Algorithm SHA256 | Select-Object -ExpandProperty Hash | Set-Content -Path "$AssembliesPath/$BinaryFileName.sha256" -Force

            Remove-Item $TempFile -Force

            Write-Verbose "Edge WebDriver updated successfully"
        }
        catch {
            Write-Error "Error updating Edge WebDriver: $_"
        }
    }

    end {
        Write-Verbose "Edge WebDriver update process completed"
    }
}

# Function to update Firefox WebDriver (geckodriver)
function Update-FirefoxDriver {
    [CmdletBinding()]
    param (
        [string]$AssembliesPath = "$PSScriptRoot/assemblies"
    )

    begin {
        Write-Verbose "Starting Firefox WebDriver (geckodriver) update process"
    }

    process {
        try {
            $apiUrl = "https://api.github.com/repos/mozilla/geckodriver/releases/latest"
            $release = Invoke-RestMethod -Uri $apiUrl
            $asset = $release.assets | Where-Object { $_.name -like "*win64.zip" } | Select-Object -First 1

            $TempDir = [System.IO.Path]::GetTempPath()
            $TempFile = Join-Path $TempDir $asset.name

            Write-Verbose "Downloading Firefox WebDriver (geckodriver)"
            Invoke-WebRequest $asset.browser_download_url -OutFile $TempFile

            Write-Verbose "Expanding Firefox WebDriver (geckodriver) to $AssembliesPath"
            Expand-Archive $TempFile -DestinationPath $AssembliesPath -Force

            $BinaryFileName = "geckodriver.exe"
            Write-Verbose "Generating SHA256 Hash File: $AssembliesPath/$BinaryFileName.sha256"
            Get-FileHash -Path "$AssembliesPath/$BinaryFileName" -Algorithm SHA256 | Select-Object -ExpandProperty Hash | Set-Content -Path "$AssembliesPath/$BinaryFileName.sha256" -Force

            Remove-Item $TempFile -Force

            Write-Verbose "Firefox WebDriver (geckodriver) updated successfully"
        }
        catch {
            Write-Error "Error updating Firefox WebDriver (geckodriver): $_"
        }
    }

    end {
        Write-Verbose "Firefox WebDriver (geckodriver) update process completed"
    }
}

# Main function to update WebDrivers
function Update-WebDrivers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet('Chrome', 'Firefox', 'Edge', 'All')]
        [string]$Browser,
        
        [Parameter(Mandatory=$false)]
        #[string]$AssembliesPath = "$PSScriptRoot/assemblies"
        [string]$AssembliesPath = (Get-Module -Name selenium -ListAvailable | Select-Object Path).Path.replace("Selenium.psd1","assemblies")
    )

    begin {
        Write-Verbose "Starting WebDriver update process for $Browser"
    }

    process {
        try {
            switch ($Browser) {
                'Chrome' {
                    Update-ChromeDriver -AssembliesPath $AssembliesPath
                }
                'Firefox' {
                    Update-FirefoxDriver -AssembliesPath $AssembliesPath
                }
                'Edge' {
                    Update-EdgeDriver -AssembliesPath $AssembliesPath
                }
                'All' {
                    Update-ChromeDriver -AssembliesPath $AssembliesPath
                    Update-FirefoxDriver -AssembliesPath $AssembliesPath
                    Update-EdgeDriver -AssembliesPath $AssembliesPath
                }
            }
        }
        catch {
            Write-Error "Error in Update-WebDrivers: $_"
        }
    }

    end {
        Write-Verbose "WebDriver update process completed for $Browser"
    }
}

# Export functions
Export-ModuleMember -Function Update-WebDrivers
