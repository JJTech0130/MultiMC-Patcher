# MultiMC-Patcher
Patches MultiMC Instances for ARM64

fixlibgl3.sh was modified from [this GitLab Snippet](https://gitlab.com/snippets/1933165)

## How to install:
1. Create the "patches" directory instide the root directory of MultiMC
2. Move fixgl3.sh, fixgl2.sh, and org.lwjgl.json to the "patches" directory

## How to use:
1. Start MultiMC. Create a new instance.
2. In a new terminal, execute either fixgl2.sh (if your instance is using a minecraft version below 1.13) or fixgl3.sh (if your instance is using minecraft version 1.13 or above) followed by the name of the instance.
  + It would look like this: `./fixgl2.sh name_of_pre_1.13_instance` or `./fixgl3.sh name_of_post_1.13_instance`
3. Now launch the instance you just patched and hopefully it should work :)
  + Note: *You need to patch every new instance you create!*
## Notes:
+ Uses compiled binaries for LWJGL2 Aarch64 found [here](https://github.com/JJTech0130/Aarch64-Natives) (The script actually gets them from my dropbox)
+ Gets LWJGL3 directly from maven.
