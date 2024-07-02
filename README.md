# Simple Automation Sysadmin Tools

## 📜 Description

Simple Automation Sysadmin Tools (SAST) using bash script to automate daily working sysadmin (init installation, (healthcheck, monitoring, backup (cpu, memory, ram) vm, source code, services and database))

You can use this tools to your own ubuntu os with just a few simple steps:

![SAST](https://github.com/ksatriow/sast/blob/main/asset/mainmenu.png?raw=true)


## 📖 Table of contents

- 📜 [Description](#-description)
- 🪒 [Prerequisites](#-prerequisites)
- 🌟 [Features](#-features)
- ⚙️ [Installation](#️-installation)
- 🚀 [Usage](#-usage)
- 🫱🏼‍🫲🏽 [Contributing](#-contributing)
- 📌 [Author](#-author)
- 📚 [References](#-references)

## 🪒 Prerequisites

* Ubuntu OS
* Linux Command Line interface
* User with root privilledge (for installation)
* Notes

    This script, unsurprisingly based on the name, requires to be run in a Bash shell and will terminate when run by `/bin/sh` or `/bin/dash` (for example).

    What I like to do at the top of my scripts is to ensure this by adding the code:

    ```
    # Ensure we are running under bash
    if [ "$BASH_SOURCE" = "" ]; then
        /bin/bash "$0"
        exit 0
    fi
    ```

    These scripts do not need to be in the same directory as your main script, however, so it is perfectly fine to source the `sast.sh` script into your scripts from any location.

## 🌟 Features

The SAST Menu will clear the screen and display a menu as shown above. You can select the menu item currently highlighted by pressing Enter. You can navigate the options using the following methods:

- **Init**: Initialization scripts are run needed tools before development usage.
- **Healthcheck**: Objective view on the current bottlenecks and challenges in your existing system with parameter (cpu,ram,memory and uptime). 
- **Extra Tools**: Additional tools that needed by Development proses but It's optional.
- **Daily Task**: Contains scripts to help sysadmins speed up their daily work.
- **Remove**: Remove package installation that unused.

## ⚙️ Installation

See the `demo.sh` script for an introduction to how to incorporate Bash Menu in your own scripts, but the quick steps would be:


### Step 1. Download the Bash Menu scripts

Download `sast.sh` and put them somewhere (in the same directory as each other).


### Step 2. Clone and Run this Tools

Somewhere in your own Bash script, before you want to use or configure a menu, you should import the `sast.sh` script, either via (assuming the same directory as your script):

make the script executable

```
chmod +x sast.sh
```

update

```
source sast.sh
```

or simply:

```
. sast.sh
```

to running this 

```
.\sast.sh 
```

or

```
bash sast.sh 
```

## 🚀 Usage

```
   ___  _ __  _ __  _ __ ___   __ _ _ __ ___  ___ ___ 
  / _ \| '_ \| '_ \| '__/ _ \ / _` | '__/ _ \/ __/ __|
 | (_) | | | | |_) | | | (_) | (_| | | |  __/\__ \__ \
  \___/|_| |_| .__/|_|  \___/ \__, |_|  \___||___/___/
             |_|              |___/                   
```
## 🫱🏼‍🫲🏽 Contributing

Contributions are welcome. Please feel free to fork, modify, and make pull requests or report issues.

Special thanks to:

- [Komar](https://github.com/kukuhsw) for support on Development this repo.

## 📌 Author

### Kukuh Satrio Wibowo

- [URL](https://satrioportofilio.netlify.app/)
- [Facebook](https://www.facebook.com/ksatriow)
- [LinkedIn](https://www.linkedin.com/in/kukuh-satrio-wibowo/)

## 📚 References

- [Bash](https://www.freecodecamp.org/news/bash-scripting-tutorial-linux-shell-script-and-command-line-for-beginners/)
- [Ubuntu](https://www.server-world.info/en/note?os=Ubuntu_22.04&p=initial_conf&f=1)
- [ShellCheck](https://www.shellcheck.net/)