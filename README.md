# MultiMC-Patcher
Patches MultiMC Instances for ARM64

fixlibgl3.sh was modified from [this GitLab Snippet](https://gitlab.com/snippets/1933165)

## How to install:
1. Create the "patches" directory instide the root directory of MultiMC
2. Move patcher.sh and org.lwjgl.json to the "patches" directory

## How to use:
1. Start MultiMC.
2. Add patcher.sh as pre-launch command
## Notes:
+ Uses compiled binaries for LWJGL2 Aarch64 found [here](https://github.com/JJTech0130/Aarch64-Natives) (The script actually gets them from my dropbox)
+ Gets LWJGL3 directly from maven.
