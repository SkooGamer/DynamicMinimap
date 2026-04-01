# DynamicMinimap System (Godot 4)

A real-time circular minimap system for Godot 4 featuring 3D world tracking, player rotation alignment, and edge clamping.

---

## ✨ Features

- 🌍 Real-time 3D world tracking
- 🧭 Player rotation alignment
- 📍 Entity tracking system (enemy, item, player, etc.)
- ⚡ Edge clamping (objects stick to border instead of disappearing)
- 🎨 Customizable colors and icons
- 📏 Scalable world-to-minimap mapping
- 🧩 Easy group-based integration

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

| Type  | Group Name |
|------|------------|
| Player | player |
| Enemy  | enemy |
| Item   | item |

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

MIT License — free to use in personal and commercial projects.

---

## 👤 Author

Created by SkooGamer
