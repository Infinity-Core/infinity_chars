# infinity_chars - RedM Multi-Character Selector

Advanced multi-character selection and management module for RedM, developed by Shepard & iiRedDev (ALTITUDE-DEV.COM). Designed to work seamlessly with Infinity Core and Infinity Skin.

## ✨ Main Features

- Multi-character selection menu (UI-based, modern design)
- Full synchronization with Infinity Core and Infinity Skin
- Character switching, skin and outfit loading
- Server/client sync for character data
- Database integration (requires oxmysql)
- Easy integration with existing frameworks

## 📦 Installation

1. Place this folder in your server's `resources` directory.
2. Add the resource to your `server.cfg`:
   ```
   ensure oxmysql              # SQL module
   ensure infinity_core        # Framework core module
   ensure infinity_skin        # Skin system module
   ensure infinity_chars
   ```
3. Make sure [oxmysql](https://github.com/overextended/oxmysql) is installed and started before this script.
4. Configure the files as needed.

## ⚙️ Configuration

- Main scripts:
  - `client.lua` (client logic)
  - `server.lua` (server logic)
  - `clothes-skin.lua` (skin/outfit data)
- User interface: `html/`

## 🛠 Contribution

Contributions are welcome!
Please create an issue or pull request for any suggestion or improvement.

## 🤝 Support & Links

- Documentation: [https://altitude-dev.gitbook.io/doc/](https://altitude-dev.gitbook.io/doc/)
- Discord support: [https://discord.gg/ncH7GX3XJd](https://discord.gg/ncH7GX3XJd)
- Authors: Shepard, iiRedDev

---

> Module licensed by ALTITUDE-DEV.COM. Any unauthorized reproduction or distribution is prohibited.
