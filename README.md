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

## 🧾 Collected Artifacts

RoboVelocity collects the following artifacts (paths are relative to the target volume):

1. **Registry hives** — `\Windows\System32\config`  
2. **Windows Event Logs** — `\Windows\System32\winevt\Logs`  
3. **Prefetch files** — `\Windows\Prefetch`  
4. **Pagefile** — `\pagefile.sys`  
5. **Amcache folder** — `\Windows\appcompat\Programs`  
6. **SRU** — `\Windows\System32\sru`  
7. **Windows Defender quarantine files** — `\ProgramData\Microsoft\Windows Defender\Quarantine`  
8. **Windows Defender support files** — `\ProgramData\Microsoft\Windows Defender\Support`  
9. **NTUSER.DAT + transaction logs (all users)** — `\Users\*\NTUSER.DAT`, `\Users\*\NTUSER.DAT.LOG1`, `\Users\*\NTUSER.DAT.LOG2`  
10. **Jump Lists (AutomaticDestinations, all users)** — `\Users\*\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations`  
11. **Jump Lists (CustomDestinations, all users)** — `\Users\*\AppData\Roaming\Microsoft\Windows\Recent\CustomDestinations`  
12. **Recent `.lnk` shortcuts (all users)** — `\Users\*\AppData\Roaming\Microsoft\Windows\Recent`  
13. **Office Recent `.lnk` shortcuts (all users)** — `\Users\*\AppData\Roaming\Microsoft\Office\Recent`  
14. **UsrClass.dat + transaction logs (all users)** — `\Users\*\AppData\Local\Microsoft\Windows\UsrClass.dat`, `\Users\*\AppData\Local\Microsoft\Windows\UsrClass.dat.LOG1`, `\Users\*\AppData\Local\Microsoft\Windows\UsrClass.dat.LOG2`  
15. **ConnectedDevicesPlatform (all users)** — `\Users\*\AppData\Local\ConnectedDevicesPlatform`  
16. **Browser files (all users)**  
    - **Chrome** — `\Users\*\AppData\Local\Google\Chrome\User Data`  
    - **Edge** — `\Users\*\AppData\Local\Microsoft\Edge\User Data`  
    - **Brave** — *(add path if you want it listed explicitly)*  
    - **Mozilla Firefox** — *(add path if you want it listed explicitly)*  
17. **PowerShell console history (all users)** — `\Users\*\AppData\Roaming\Microsoft\Windows\PowerShell`  

### Additional folder paths

- `\Users\*\AppData\Local\Microsoft\Windows\WebCache`  
- `\Users\*\AppData\Local\Microsoft\Windows\INetCookies`  
- `\Users\*\AppData\Local\Microsoft\Windows\History`  
- `\Users\*\AppData\Local\Microsoft\Windows\INetCache`  

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
