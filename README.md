# Blind-Bash-RPG

Textual RPG game by the terminal with audio-narrator.

  * Supported Languages:
    * Portuguese (Default)
  * License: 
    * All files → [GPL v3.0](https://github.com/Lunovox/Blind-Bash-RPG/blob/master/LICENSE)
  * Download:
    * [Install Package](https://github.com/Lunovox/Blind-Bash-RPG/raw/master/Packages/blind-bash-rpg_2.0.0_all.deb) (DEB of New Version for all architectures)
    * [Source Code](https://github.com/Lunovox/Blind-Bash-RPG/archive/master.zip) (ZIP of New Version )
  * Depends:
    * figlet (>= 2.2.5)
    * sl (>= 3.03-17)
    * espeak (>= 1.47.11)
    * pulseaudio-utils (>= 4.0.0)
  * Developers contacts:
    * 2017, [Xerxes Lins](mailto:xerxeslins@gmail.com)
    * 2018, [Lunovox Heavenfinder](https://libreplanet.org/wiki/User:Lunovox)
  * Repository: 
    * Old Version: https://www.vivaolinux.com.br/script/Bash-RPG
    * New Version:  https://github.com/Lunovox/Blind-Bash-RPG.git

_____

### Command to generate the hash of the files in the package:
````
cd ./blind-bash-rpg/
find usr/ -type f -exec md5sum {} \; > DEBIAN/md5sums
````

### Command to reveal the package name of a dependency:
````sudo apt-cache search paplay````

### Command to reveal the package version of a dependency:
````sudo apt version pulseaudio-utils````


### Command to generate the sample package in the "Packages" directory:
````dpkg-deb -b ./blind-bash-rpg/ ./Packages/````


### Command to extract the contents of a DB package in the "blind-bash-rpg" directory:
````dpkg-deb -x ./blind-bash-rpg.deb ./blind-bash-rpg````

