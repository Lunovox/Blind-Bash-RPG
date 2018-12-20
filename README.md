# Blind-Bash-RPG

Textual RPG game by the terminal with audio-narrator.

  * Supported Languages:
    * Portuguese (Default)
  * Repository: 
    * Old Version: https://www.vivaolinux.com.br/script/Bash-RPG
    * New Version:  https://github.com/Lunovox/Blind-Bash-RPG.git
  * Source Code (ZIP New Version): https://github.com/Lunovox/Blind-Bash-RPG/archive/master.zip
  * License: [GPL v3.0](https://github.com/Lunovox/Blind-Bash-RPG/blob/master/LICENSE)
  * Developers contacts:
    * 2017, [xerxeslins](mailto:xerxeslins@gmail.com)
    * 2018, [Lunovox Heavenfinder](https://libreplanet.org/wiki/User:Lunovox)

_____

### Command to generate the hash of the files in the package:
````
	cd ./blind-bash-rpg/
	find usr/ -type f -exec md5sum {} \; > DEBIAN/md5sums
````

### Command to reveal the package name of a dependency:
	* ````sudo apt-cache search paplay````

### Command to reveal the package version of a dependency:
	* ````sudo apt version pulseaudio-utils````


### Command to generate the sample package in the "Packages" directory:
	* ````dpkg-deb -b ./blind-bash-rpg/ ./Packages/````


### Command to extract the contents of a DB package in the "blind-bash-rpg" directory:
````
	dpkg-deb -x ./blind-bash-rpg.deb ./blind-bash-rpg
````

