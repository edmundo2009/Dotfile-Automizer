<h1>Dotfile Automizer</h1>

> [!WARNING]
> The following is the link to the autosetup script: DO NOT RUN WITHOUT READING WHAT THE SCRIPT DOES
> ```
> Invoke-RestMethod https://raw.githubusercontent.com/AndreM222/Dotfile-Automizer/master/autoSetup.ps1 | Invoke-Expression 
> ```

<h2>Dependencies 📃</h2>

- Windows OS 🪟

<h2>Contents 📦</h2>

- Windows OS Dotfile Setup Automizer

<h2>Description ℹ️</h2>

The following is a repository which contains my automated setup for [Windows OS](https://www.microsoft.com/en-us/windows?r=1).
The project is specifically made for my own setup but if someone wants to use it than you are free to do so.
I decided to make my own automizer instead of using other people's as I wanted to learn how to make one and 
also to customize it to my own needs. 

The language being used is [PowerShell](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/powershell)
I specifically chose this language since it is by default installed on all Windows OS machines and is a powerful 
script which interpreter language is by default integrated.

To make it easy to set up I came up with the idea of obtaining the raw path of the scripts from this github 
repository and invoke them directly into the command line. This way the user does not have to clone the repository to 
run the scripts.

[LICENSE](https://github.com/AndreM222/Dotfile-Automizer/blob/master/License) <span style="font-size:2em">🪪</span>

<h2>Instructions 📖</h2>

- The listSetup script contains the list of all the scripts which are being invoked in the autoSetup script. You can
add or change to your preference
- The autoSetup script is the main script which is being invoked by the user to set up the requirments
from the listSetup.
- The managerSetting contains the setup of managers action to find if package exist, uninstall, and install. If a 
package manager is added then the managerSetting script should be updated to include the package manager.

<h2>Roadmap Missing 🗺️</h2>

- [ ] Make Autosetup work for nvm versions
- [ ] Make uninstall command for all packages
- [ ] Make listSetup to autoupdate when a package manager in the list of managerSettings is used.
- [ ] Make command status to show changes withing scripts
- [ ] Make command to push script changes
- [ ] Make Autosetup for Linux
- [ ] Make Autosetup for MacOS
