## 🔥 Burn - Anti-Forensics Tool

![burn](https://socialify.git.ci/omertasci11/burn/image?font=Inter&language=1&name=1&owner=1&pattern=Transparent&theme=Auto)

Welcome to **Anti‑Forensic tool Burn**! This script helps you securely shred log files, manipulate timestamps, clear shell history, and more—either selectively or in bulk.


---

## 📋 Table of Contents

- [Features](#-features)  
- [Installation](#-installation)  

---

## 🔒 Features

- **Selective log shredding** (`-s, --selected`)  
- **Bulk log cleaning** (`-l, --all`)  
- **Timestamp manipulation** (`-t, --timestamps`):  
  - Zero‑out (`-z`)  
  - Randomize (`-r`)  
  - Transfer between files (`-s`)  
  - Set to a custom date (`-g`)  
- **Shell history clearing** (`-c, --history`)  
- **All-in-one “terminate” mode** (`-x, --terminate`): runs log cleanup, timestamp changes, history clearing (and optionally MAC change) in sequence  
- **Background execution** (`-b, --background`) with cron‑style logging to `status.txt`  
- **Diff report** (`-d, --diff`) between two directories  

---

## ⚙️ Installation

1. Clone or download this repository.  
2. Make the script executable:

   ```bash
   chmod +x burn.sh
