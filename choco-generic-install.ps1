#Powershell Modules Used
Install-PackageProvider -name NuGet
Install-Module PSWindowsUpdate

#License Keys (don't forget the "" )

$win10hom =
$win10pro = 
$win10ent =
$serv19essentials = 
$serv19standard = 

#Application Variables
$gamingpc = "steam battle.net discord steam-cleaner"
$torrentbox = "lidarr radarr sonarr transmission plex"
$mediapc = ""
$generic = "adobereader 7zip vlc teamviewer-qs patch-my-pc"
$workstation = "office365proplus rsat rsat.featurepack"
$overclock = "msiafterburner gpu-z cpu-z heaven-benchmark hwinfo ddu"
$streamer = "streamlabs-obs"

#STAGE 1
#Check if running as admin
if ( ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") -eq $false ) { 
    write-error "This script requires admin permissions"
    pause
    exit
    }

#Detect windows version and prompt for key if not provided
write-host "Checking Windows version..."
$winactivated = Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | where { $_.PartialProductKey } | select Description, LicenseStatus
$winver = (Get-WMIObject win32_operatingsystem).name

write-host "Checking if Windows is Activated..."
if ( $winactivated.LicenseStatus -eq '1' ) {
    write-host "Windows already activated!" -ForegroundColor green
    } else {
    write-host "Windows not activated..."
    if ( $winver -match 'Windows 10 Pro' ) {
        if ( $win10pro -eq $null ) {
            Write-Warning "No Windows 10 Pro key provided, prompting..."
            $win10pro = read-host "Please provide key"
            }
        $windowskey = $win10pro
        }

    if ( $winver -match 'Windows 10 Home' ) {
        if ( $win10hom -eq $null ) {
            Write-Warning "No Windows 10 Pro key provided, prompting..."
            $win10hom = read-host "Please provide key"
            }
        $windowskey = $win10hom
        }

    if ( $winver -match 'Windows 10 ent' ) {
        if ( $win10ent -eq $null ) {
            Write-Warning "No Windows 10 Pro key provided, prompting..."
            $win10ent = read-host "Please provide key"
            }
        $windowskey = $win10ent
        }

    if ( $winver -match 'Windows Server 2019' ) {
        if ( $serv19standard -eq $null ) {
            Write-Warning "No Windows 10 Pro key provided, prompting..."
            $serv19standard = read-host "Please provide key"
            }
        $windowskey = $serv19standard
    }
    if ( $windowskey -eq $null ) {
        write-warning "EXCEPTION: OS version not coded into script"
        $winver
        $winactivated
        $windowskey = read-host "Please provide key"
    }
}



#Prompt for PC Build
write-host "Please answer the below questions"
$compname = read-host "Please provide your computername, eg BarryPC, CoolComputer:"
$chocogaming = read-host "Gaming PC? y/N"
$chocotorrent = read-host "Torrent Box? y/N"
$chocomedia = read-host "Media Box / Lounge Room Machine? y/N"
$chocowork = read-host "Work Station? y/N"
$chocostreampc = read-host "Streaming PC? y/N"
$cocoOC = read-host "Do you plan on overclocking? y/N"
$browserpref = read-host "Would you like to install Google (C)hrome, (E)dge Chromium, (F)irefox, (O)pera or (A)ll?"
$joindom = read-host "Will this machine be domain joined? Please type the domain:"

#Check if ran as Admin...


#check if choco is installed
if ( ( test-path "C:\ProgramData\chocolatey\bin") -eq $true ) {
    write-host "Choco installed..." -ForegroundColor green 
    } else {
    write-host "Choco not installed, queuing..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
write-host "No user input required from here!"

#STAGE 2
#Browser Preference
write-host "Installing browser/s"
if ( $browserpref -eq 'c' ) { cinst -y googlechrome }
elseif ( $browserpref -eq 'e' ) { cinst -y microsoft-edge }
elseif ( $browserpref -eq 'f' ) { cinst -y firefox }
elseif ( $browserpref -eq 'o' ) { cinst -y opera }
elseif ( $browserpref -eq 'a' ) { cinst -y chrome microsoft-edge firefox opera }
elseif ( $browserpref -ne $null ) { write-warning "Invalid choice for browser preference - no additional browsers will be installed" }
else { write-warning "No browser selected" }

#Choco Gaming
if ( $chocogaming -eq 'Y' ) {
    write-host "Installing Gaming PC Applications"
    write-host $gamingpc -ForegroundColor DarkGray
    write-host "Downloading Xbox Beta App..."
    Invoke-WebRequest -Uri "https://assets.xbox.com/installer/20190628.8/anycpu/XboxInstaller.exe" -OutFile "xboxinstaller.exe"
    write-host "Starting install..."
    start-process .\xboxinstaller.exe 
    write-host "Downloading Epic Games launcher..."
    Invoke-WebRequest -uri "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi" -OutFile "EpicGamesLauncherInstaller.msi"
    write-host "Launching Epic Lancher..."
    msiexec /i .\EpicGamesLauncherInstaller.msi /qn
    write-host "Downloaing GOG Galaxy 2.0..."
    Invoke-WebRequest -Uri  "https://drive.google.com/u/0/uc?id=1yMAnLuQZ3owIp0306mLULwTBQHKPNPdM&export=download" -OutFile "gog.exe"
    write-host "Launching GOG Galaxy Installer..."
    start-process .\gog.exe -argumentlist "/SILENT /VERYSILENT" -wait
    write-host "Installing others via Choco..."
    cinst -y $gamingpc
    }

if ( $chocoOC -eq 'Y' ) { 
    write-host "Installing Overclocking Applications"
    write-host $overclock -ForegroundColor DarkGray
    cinst -y $overclock }

#Choco Torrent
if ( $chocotorrent -eq 'Y' ) {
    write-host "Installing Torrent Applications"
    write-host $torrentpc -ForegroundColor DarkGray
    cinst -y $torrentpc
    }

#Choco Media
if ( $chocomedia -eq 'Y' ) {
    write-host "Installing Gaming PC Applications"
    write-host $mediapc -ForegroundColor DarkGray
    cinst -y $mediapc
    }
#Choco Work
if ( $chocowork -eq 'Y' ) {
    write-host "Installing Gaming PC Applications"
    write-host $workstation -ForegroundColor DarkGray
    cinst -y $workstation
    }

#Choco Stream
if ( $chocostreampc -eq 'Y' ) {
    write-host "Installing Streaming Applications"
    write-host $streamer -ForegroundColor DarkGray
    cinst -y $streamer
    }

if ( $compname -ne $false ) { Rename-Computer $compname -Verbose }

if ( $joindom -ne $false ) {
    write-host "Confirming can connect to domain..."
    if ( ( Test-Connection -ComputerName $joindom -Quiet ) ) {
        $domcred = Get-Credential -Message "Please provide credentials to use for joining machine to domain..."
        Add-Computer -ComputerName $compname -Credential $domcred -verbose 
        } else {
        write-warning "Unable to connect to domain, skipping domain join"
        }
    }


write-host "Specific applications now installed, installing generic..."
write-host $generic -ForegroundColor DarkGray
cinst -y $generic

#STAGE 3
#Install Drivers for PNP Devices
write-host "Testing for Drivers and any other relevant software..."
$pnp = Get-PnpDevice | select 'FriendlyName'

#Peripherals
if ( $pnp -match 'razer' ) { choco install razer-synapse-3 --version=1.0.87.116-beta --pre  }
if ( $pnp -match 'logitech' ) { cinst -y logitechgaming }
#Drivers
if ( $pnp -match 'nvidia' ) { cinst -y geforce-experience }
if ( $pnp -match 'Ryzen' ) { cinst -y amd-ryzen-chipset }
if ( $pnp -match 'AMD' ) { cinst -y  }
if ( $pnp -match "Intel(R) Core(TM)" ) { cinst -y intel-xtu intel-dsa }
if ( $pnp -match 'NZXT' ) { cinst -y nzxt-cam }

#STAGE 4
#Activate Windows
DISM /online /Set-Edition:ServerStandard /ProductKey:$windowskey /AcceptEula /NoRestart 

#STAGE 5
#System Tweaks

#Disable Stickey Keys
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506" -Verbose
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys" -Name "Flags" -Type String -Value "58" -Verbose
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "Flags" -Type String -Value "122" -Verbose



#Updates
write-host "Running windows update..."
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll -IgnoreReboot -ForceDownload

#Confirm Install is Happy
write-host "Running checks over sytem..."
write-host "This is the last step....!"
sfc /scannow 

write-host "Completed!" -ForegroundColor green 
write-host "Enjoy your fresh machine!" -ForegroundColor green 