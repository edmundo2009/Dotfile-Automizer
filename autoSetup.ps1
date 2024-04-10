if($env:OS -notlike "*Windows*")
{
    Write-Host "> This script is only for Windows OS" -ForegroundColor DarkRed
    exit
}

[String] $user = "AndreM222" # User of repo
[String] $repo = "Dotfile-Automizer" # Repo of automizer

#region Module Setup
[String] $urlFileGitLink = "https://api.github.com/repos/$user/$repo/contents" # Link to the git repository files
[String] $urlGitLink = "https://raw.githubusercontent.com/$user/$repo/master" # Link to the git repository scripts

if([String](Split-Path -Path (Get-Location) -Leaf) -ne "Dotfile-Automizer") # Check if the current location is not the Dotfile-Automizer folder
{
    $manager = Invoke-WebRequest "$urlGitLink\.\Managers\managerSetting.json" | ConvertFrom-Json # <- Web Manager Setup
}
else
{
    $manager = Get-Content ".\Managers\managerSetting.json" | ConvertFrom-Json # <- Local Manager Setup
}

[Object] $jsonFolders =  @( # <- Installation List > Run priority from top to bottom
    "./Managers/setup/",
    "./SetupList/Tools/",
    "./SetupList/Others/"
)

[Object] $listTools = @()

[Object] $modules = @(
    "library.psm1" # <- Functions For Setup
) # List of modules to import

if([String](Split-Path -Path (Get-Location) -Leaf) -ne "Dotfile-Automizer") # Check if the current location is not the Dotfile-Automizer folder
{
    foreach($folder in $jsonFolders) # Setup all json files list from git
    {
        [String] $uri = "$urlFileGitLink/$folder"
        if([uri]::IsWellFormedUriString($uri, 'Absolute'))
        {
            [Object] $jfile = (Invoke-WebRequest -Uri $uri) | ConvertFrom-Json
            foreach($script in $jfile)
            {
                $listTools += $script.download_url # Setup Raw Url
            }
        }
    }
}
else
{
    foreach($folder in $jsonFolders) # Setup all json files list from local
    {
        $listTools += Get-ChildItem $folder
    }
}

if([String](Split-Path -Path (Get-Location) -Leaf) -ne "Dotfile-Automizer") # Check if the current location is not the Dotfile-Automizer folder
{
    foreach($curr in $modules)
    {
        Invoke-RestMethod "$urlGitLink/$curr" > $curr # Download the modules from the git repository

        Import-Module ".\$curr"

        if(Test-Path -Path $curr)
        {
            Remove-Item $curr # Remove modules from current location
        }
    }
}
else
{
    foreach($curr in $modules)
    {
        Import-Module ".\$curr"
    }

}

#region Functions

# Imported Functions List:
#  - installerExe <- (Name, Executable, Path)
#  - installerCommand <- (Name, Executable, Path)
#  - installerSearch <- (Name, Id, Path)
#  - gitRepoSetup <- (Name, Repo, Path)
#  - scriptSetup <- (Path, File)
#  - createSetup <- (File, Content, Path)
#
#  - section <- (Title)

#endregion Functions

#region Setup Functions
foreach($script in $listTools)
{
    if([String](Split-Path -Path (Get-Location) -Leaf) -ne "Dotfile-Automizer") # Check if the current location is not the Dotfile-Automizer folder
    {
        [Object] $list = (New-Object System.Net.WebClient).DownloadString($script) | ConvertFrom-Json # Get Web Lists
    }
    else
    {
        [Object] $list = Get-Content -raw $script | ConvertFrom-Json # Get Local Lists
    }

    foreach($item in $list)
    {
        section $item.TITLE # Print the section title

        Switch($manager.($item.MANAGER).INSTALL_TYPE)
        {
            #region Executable Installer
            "Executable"
            {
                installerExe $manager.($item.MANAGER).MANAGER_INSTALLER $item.CONTAINER
            }
            #endregion Executable Installer

            #region Executable Installer
            "Command"
            {
                installerCommand $manager.($item.MANAGER).MANAGER_INSTALLER $item.CONTAINER
            }
            #endregion Executable Installer


            #region Search Installer
            "Search"
            {
                installerSearch $manager.($item.MANAGER).FINDER $manager.($item.MANAGER).MANAGER_INSTALLER $item.CONTAINER
            }
            #region Search Installer

            #region Git Setups
            "Git"
            {
                gitRepoSetup $item.CONTAINER
            }
            #endregion Git Dotfile Setups

            #region Script Dotfile Setup
            "Script"
            {
                scriptSetup $item.CONTAINER
            }
            #endregion Script Dotfile Setup

            #region Create Dotfile Setup
            "Create"
            {
                createSetup $item.CONTAINER
            }
            #endregion Script Dotfile Setup


            #region Unkown Installer
            default
            {
                Write-Host "> Unknown Installer" -ForegroundColor DarkRed
            }
            #endregion Unkown Installer
        }
    }
}

#endregion Setup Functions
