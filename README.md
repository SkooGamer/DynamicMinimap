<h1 align="center">DynamicMinimap System (Godot 4.x)</h1>

<p align="center">
  <a href="https://godotengine.org/">
    <img src="https://img.shields.io/badge/Godot-4.x-blue">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg">
  </a>
  <a href="https://github.com/SkooGamer/DynamicMinimap">
    <img src="https://img.shields.io/badge/version-1.0-green">
  </a>
</p>

<p align="center">
A real-time circular minimap system for Godot 4 featuring 3D world tracking, player rotation alignment, and edge clamping.
</p>

---

## 🆕 Version 1.1 Updates

- 🎨 Added icon system using the `IconType` feature (Color or 2D Texture)
- 📦 Added default preset icons (automatically loaded from the plugin folder)
- 🌍 Added 2D support (unified Node2D + Node3D system)
- 🧭 Player icon now supports direction rotation
- ⚡
- 📍 Objects now strictly depend on group names + IconType mapping
- 🎯 Priority rendering: Texture → Player Drawing → Color feature
- 🧠 Improved edge fixing system
- 🧩 Cleaner modular architecture for plugin use

---

## 🎨 Icon System (NEW v1.1)

The minimap now uses a **Resource-based icon system**.

Each tracked object is defined by an `IconType`, which connects:
- A **group name**
- A **fallback color**
- An optional **Texture2D icon**

### ⚙️ How it works

Every object MUST:
- Be added to a Godot Group (example: `enemy`, `item`, `player`)
- Have a matching `IconType` defined in the minimap inspector

### 🧩 IconType Structure

- `type` → Group name
- `color` → fallback color if no texture exists
- `texture` → optional Texture2D icon

### 🎯 Render Priority

1. Texture2D (if assigned)
2. Player custom triangle icon
3. Color fallback circle

---

## ⚙️ Configuração (ATUALIZADA v1.1) 

### Configuração 
- `player_node` → Referência do jogador 
- `radius` → Tamanho do minimapa 
- `world_scale` → Escala do mundo para o minimapa 

### Comportamento 
- `clamp_to_border` → Mantém os objetos na borda do minimapa 
- `rotate_with_player` → Rotaciona o minimapa com o jogador 
- `enabled_auto_register` → Escaneia grupos automaticamente 

### Ícones 
- `icons` → Array de recursos IconType 
- `icon_size` → Tamanho do ícone de textura 
- `use_default_icons` → Carrega ícones padrão integrados 

### Depuração 
- `show_debug` → Imprime informações de depuração (ausentes jogador/grupos)

---

## 📦 Installation

1. Download or clone this repository
2. Copy the folder into your project: res://addons/dynamic_minimap/
3. Enable the plugin in: Project → Project Settings → Plugins

---

## 🚀 Usage

### 1. Add the minimap to your UI

Instance the minimap scene into your HUD: Minimap.tscn

---

### 2. Assign the player

In the inspector: player_node = YourPlayerNode


---

### 3. Add objects to the system

Use Godot Groups:

| Type   | Group Name |
|--------|------------|
| Player | ⚪ `player` |
| Enemy  | 🔴 `enemy` |
| Item   | 🟢 `item` |

Example: add_to_group("enemy")

---

## ⚙️ Configuration

You can customize:

- Radius
- Border size
- Background color
- Icon colors per type
- World scale

---

## 🎯 How it works

- Converts world XZ position into 2D minimap space
- Rotates based on player direction
- Scales distance based on `world_scale`
- Clamps objects to border instead of hiding them

---

## 🧠 Notes

- Designed for top-down minimaps or RPG/FPS HUDs
- Works best with consistent world scale
- Optimized for runtime updates

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

Created by **SkooGamer**

[![YouTube](https://img.shields.io/badge/YouTube-Subscribe-red?logo=youtube&logoColor=white)](https://www.youtube.com/@SkooGamer)
[![GitHub](https://img.shields.io/badge/GitHub-SkooGamer-black?logo=github&logoColor=white)](https://github.com/SkooGamer)

---

# 👀 Preview

<p align="center">
  <img src="images/preview.png" width="600"/>
</p>

---

## 🎥 Video Demo

<p align="center">
  <a href="https://youtu.be/3KZLyM8eMgE">
    <img src="https://img.youtube.com/vi/3KZLyM8eMgE/maxresdefault.jpg" width="600"/>
  </a>
</p>
