<p align="center">
  <img src="resources/branding/server-icon.png" width="128" alt="VanillaBase">
</p>
<h1 align="center">VanillaBase</h1>
<p align="center">
  Кроссплатформенный Minecraft-сервер от MineBase с упором на ванильное выживание, QoL и развитие вместе с игроками.
</p>
<strong>VanillaBase</strong> — простой игровой сервер, с которого начинается новое развитие MineBase.

Вместо создания огромного проекта до появления игроков мы начинаем с работающей основы, собираем сообщество и постепенно развиваем сервер вместе с ним.

## 🌍 Как это работает

VanillaBase поддерживает **Minecraft Java и Bedrock**.

При первом подключении игрок проходит небольшой путь:
```text
Подключение
    ↓
Lobby
    ↓
Регистрация
    ↓
Случайная точка мира (становится точкой возрождения)
    ↓
Vanilla Survival
````
## ✨ Что уже есть
- [x] Java + Bedrock
- [x] Регистрация и авторизация
- [x] Отдельное lobby
- [x] Случайный старт через RTP
- [x] Система прав
- [x] Защита областей
- [x] Логирование и откат изменений
- [x] Backup / Restore
- [x] QoL и инфраструктурные плагины

> Сервер работает на **Purpur** с использованием Geyser, Floodgate, ViaVersion, AuthMe, Multiverse, BetterRTP, LuckPerms, WorldGuard, CoreProtect и других вспомогательных компонентов.
## 🗺️ Статус
**MVP готов.**
```text
Foundation       ✅
Cross-platform   ✅
Authentication   ✅
Server MVP       ✅
Backup / Restore ✅
Closed Test      ✅
Hosting          ⏳
Deployment       ⏳
```
## 📁 Репозиторий
Runtime-сервер, резервные копии и чувствительные конфигурации не хранятся в Git.
```text
VanillaBase/
├── config/       # Шаблоны конфигурации
├── docs/         # Документация и baselines
├── resources/    # Ресурсы проекта
├── scripts/      # Запуск, backup и restore
├── backups/      # Локальные резервные копии
└── server/       # Локальный runtime сервера
```
## 🌿 MineBase

VanillaBase — часть **MineBase**, сообщества, которое развивается вокруг Minecraft, совместных проектов и идей его участников.

VanillaBase должен стать простой игровой основой, которую можно постепенно развивать вместе с сообществом.

> **Развивать сервер вместе с игроками, а не просто для игроков.**