# MultiMC-Patcher
Patches MultiMC Instances for ARM64/Aarch64

fixlibgl3.sh was modified from [this GitLab Snippet](https://gitlab.com/snippets/1933165)

Use MultiMC from [here](https://github.com/JJTech0130/MultiMC5/releases) (latest release)

## For Raspberry Pi users:
+ Use a 64-bit OS: [Ubuntu](https://ubuntu.com/download/raspberry-pi) or [Gentoo](https://github.com/sakaki-/gentoo-on-rpi-64bit). I personally prefer the Ubuntu (you need to install the desktop yourself) with KDE Plasma, but that is a matter of personal opinion.
+ Use low graphics settings and/or OptiFine: self-explanatory
+ It is faster to use versions below 1.13 but higher versions should work (file a bug if not!)
+ Raspberry Pi 4 is best used overclocked (with cooling) and minecraft set to use ~3GB RAM (if you have the 4GB model)
+ I'm assuming you have OpenGL enabled.

## How to install:
1. Create the "patches" directory instide the root directory of MultiMC
2. Move patcher.sh and org.lwjgl.json to the "patches" directory
3. MAKE SURE TO MARK PATCHER.SH AS EXECUTABLE! `sudo chmod +x ./patcher.sh`

## How to use:
1. Start MultiMC
2. Add patcher.sh as pre-launch command
3. Close MultiMC and relaunch.

## Notes:
+ Uses compiled binaries for LWJGL2 Aarch64 found [here](https://github.com/JJTech0130/Aarch64-Natives) (The script actually gets them from my dropbox)
+ Gets LWJGL3 directly from maven.
+ This is still a mess. Please feel free to contribute/ clean up!
