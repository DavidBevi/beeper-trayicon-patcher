<p align="center">
  <img src="https://github.com/user-attachments/assets/7dc3a2ef-7bcb-411b-af10-8e9d4c9ba4e5" align="center">
  <div align="center">Customize the systray icons of Beeper.AppImage: use my icons or your own ones!</div>
</p>

<br>

# Web page
- **[beeper-trayicon-patcher web](https://davidbevi.github.io/beeper-trayicon-patcher)**
- much faster, patches offline, you can download the webpage for offline launch+use [download [`index.html`](https://git-link.vercel.app/api/download?url=https%3A%2F%2Fgithub.com%2FDavidBevi%2Fbeeper-trayicon-patcher%2Fblob%2Fmain%2Findex.html)]
- `🤖 AI-made`: I dislike AI more than I like it, but I had to attend an AI-course and make something `╮(°᎑°)╭`

<br>

# Bash script
- `❤️ human-made`
- has many options for advanced use (see them below)
- **PREP**: install the dependency `asar` [`[github/asar]`](https://github.com/electron/asar)
- **AUTO-INSTALL**: open a CLI in the working dir of your choice, then launch the guided installer with `curl -O https://raw.githubusercontent.com/DavidBevi/beeper-trayicon-patcher/refs/heads/main/beeper-trayicon-patcher.sh && source beeper-trayicon-patcher.sh install`

<details><summary>— or click here to show manual installation steps —</summary>

Put in a directory of your choice:
- `Beeper*.AppImage` from your PC or from [`[beeper.com]`](https://beeper.com)
- `trayIcon.png` of your own or [download mine](https://git-link.vercel.app/api/download?url=https%3A%2F%2Fgithub.com%2FDavidBevi%2Fbeeper-trayicon-patcher%2Fblob%2Fmain%2FtrayIcon.png)
- `trayUnreadIcon.png` of your own or [download mine](https://git-link.vercel.app/api/download?url=https%3A%2F%2Fgithub.com%2FDavidBevi%2Fbeeper-trayicon-patcher%2Fblob%2Fmain%2FtrayUnreadIcon.png)
- `appimagetool.AppImage` from [`[github/appimagetool]`](https://github.com/AppImage/appimagetool/releases/tag/continuous)
- `beeper-trayicon-patcher.sh`: [DOWNLOAD](https://git-link.vercel.app/api/download?url=https%3A%2F%2Fgithub.com%2FDavidBevi%2Fbeeper-trayicon-patcher%2Fblob%2Fmain%2Fbeeper-trayicon-patcher.sh) and make it executable with one of these methods:
  - `[GUI]`: use your file-manager to open the file-properties, find something like `[ ] Allow execution`, enable it
  - `[CLI]`: `chmod +x "/path/to/beeper-trayicon-patcher.sh"`
</details>

### Usage options
- `[GUI]`: double-click `beeper-trayicon-patcher.sh` to patch with the files in that directory
- `[GUI]`: select all the required files and drag-n-drop them onto `beeper-trayicon-patcher.sh`
- `[CLI]` directly: `"/path/to/beeper-trayicon-patcher.sh" [OPTION...]`
- `[CLI]` sourcing: `. "/path/to/beeper-trayicon-patcher.sh" [OPTION...]`

### Optional arguments (`CLI`)
- `install` to launch the guided installer
- `-h` or `--help` to show help page and exit
- `-v` or `--version` to show version and exit
- `-f` or `--forced` to skip confirmation prompt and patch directly
- `-o=/file/path` or `--out=/file/path` to use a custom filename for the output
- `path/to/file` to pass custom file-paths for the required files (if they are in a different directory)

----

### Demo gif
![Demo gif](./bpr-patcher-demo.gif)
