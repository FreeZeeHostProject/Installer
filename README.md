# FreeZeeHost Theme Installer - Professional Edition

Premium Pterodactyl Theme Installer with Multi-Layer Security.

## ⚖️ License & Terms of Use

This software is **Proprietary**. It is NOT Open Source.

- **Usage**: You are free to run this script to install themes on your VPS.
- **Restrictions**: 
  - **DO NOT** copy, modify, or distribute the source code.
  - **DO NOT** re-brand or claim this project as your own.
  - **DO NOT** use this code for commercial gain (reselling the script).
  
**All Rights Reserved © 2026 FreeZeeHost Official.**

## 🛡️ Security Features
- **IP Whitelisting**: Real-time MongoDB check for VPS IP authorization.
- **2-Step Verification**: Mandatory secure password before accessing the installer.
- **License Key**: Unique license key required for each session.
- **Secure API Bridge**: Protects your database credentials from being exposed in the script.

## 🚀 Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/FreeZeeHostProject/installer/main/install.sh)
```

## 🛠️ Admin Setup (MongoDB & API)

1. **MongoDB**: Use the provided URI or your own Atlas cluster.
2. **API Bridge**: 
   - Located in `api/server.js`.
   - Install dependencies: `npm install express mongoose body-parser`.
   - Run: `node server.js`.
3. **Seeding Data**: Use `api/seed_db.js` to add your VPS IP to the database for testing.

---
<p align="center">Made with ❤️ by FreeZeeHost</p>
