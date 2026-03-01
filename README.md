# 🚀 RoboVelocity 🚀 

### 🔍 Digital Forensics Artifact Collector (robocopy-powered ) 🔍

RoboVelocity is a Windows-focused digital forensics artifact collector built around the Windows utility `robocopy`. It is designed to collect artifacts from a mounted Windows **NTFS** volume 
into a destination folder for analysis. It’s designed for repeatable, forensic-friendly extraction, when working with **Windows-based** and **read-only mounted disk images**. 🕵️‍♂️🧊

---

## ✨ Why RoboVelocity? ✨

- ✅ Fast and reliable copying
- ✅ Built around a Digital forensics-oriented workflow (read-only mounted evidence is required)
- ✅ Simple inputs: pick a source volume + a destination folder
- ✅ Creates a log to support transparency and case documentation 📄🔍

---

## 🧠 Core Workflow (Logic) 🧠

1. Mount the disk image in **Read-Only** mode via **Arsenal Image Mounter** 🧊🔒
2. Confirm it appears as a drive letter (example: `H:\`).  
3. Right-click `RoboVelocity.bat` 🖱️  
4. Select **Run as administrator** 🛡️  
5. Choose the Source **Windows NTFS mounted volume** (as above  : `H:\`) 💽🎯  
6. Enter the **destination folder location** for extracted data (example: `D:\CaseFolder\Extracted`) 📁➡️📁  
7. Press **Enter** and… 🚀  
8. Core forensic data are extracted to your chosen location ✅

---

## ✅ Requirements ✅

- 🪟 Windows Host (includes `robocopy`)
- 🛡️ Administrator privileges (required for protected paths)
- 💿 Arsenal Image Mounter (recommended) for read-only image mounting

---


## 📝 Logs & Output 📝

RoboVelocity produces a log file:

- 📄 `RoboVelocity.log` 📄 

Use it to:
- ✅ confirm what was copied  
- ⚠️ spot access-denied / locked-file issues (if exist)  
- 🧾 support reporting and documentation (if needed)  

💡 Keep in mind: 💡
- The `RoboVelocity.log` will be stored inside the Destination folder so everything collected stays together.

---

## ⚠️ Important Notes / Limitations (Read This)

- 🪟 Windows OS Host
- 🪟 Windows OS Target Disk Image
- 🛡️ Admin rights (necessary) before running RoboVelocity
- 🚫 `$J` (USN Journal) and `$MFT` copy are **NOT included** in data collection 
- 📌 RoboVelocity is currently scoped to **file-based extraction** using `robocopy`  

---

## ⚠️ Disclaimer (Important)

> RoboVelocity is an independent project and is **not affiliated with, endorsed by, or sponsored by Microsoft**.  
> `Robocopy` is a Microsoft utility included with Windows. This repository contains **only RoboVelocity scripts/code** and does **not** redistribute `robocopy.exe` or any other Microsoft binaries.
