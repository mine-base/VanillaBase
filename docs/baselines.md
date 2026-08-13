> [!NOTE] Performance Baselines
> Этот документ содержит контрольные замеры производительности VanillaBase.
> Каждый новый baseline показывает состояние проекта после определённого изменения инфраструктуры или добавления новых компонентов.

# Методика тестирования
- Каждый baseline проводится в одинаковой последовательности:

### Test 0 — Server Idle
Сервер запущен без подключённых игроков.
Тест показывает базовую нагрузку сервера без игровой активности.

### Test A — Idle Player
Один игрок подключён и находится в мире без активных действий.
Тест показывает нагрузку обычного присутствия игрока.

### Test B — Normal Gameplay
Один игрок в течение примерно 5 минут играет в обычном режиме:
перемещается, строит, взаимодействует с блоками и игровыми объектами.

### Test C — Chunk Generation
Один игрок исследует ранее не загруженную территорию в течение нескольких минут.
Тест показывает нагрузку при активной генерации новых чанков.

Для каждого теста фиксируются:

- TPS;
- Tick duration (min / median / 95th percentile / max);
- CPU usage;
- дополнительные наблюдения при необходимости.

> TPS и tick duration измеряются командой `spark tps`.

---

# Baseline 0 — Чистый сервер без плагинов

Первый контрольный замер VanillaBase после базовой настройки сервера.
Используется чистый Purpur без сторонних плагинов.

**Environment**

| Параметр            | Значение    |
| ------------------- | ----------- |
| Minecraft           | 26.1.2      |
| Purpur              | 26.1.2      |
| Java                | 25          |
| RAM                 | 8 GB        |
| Plugins             | 0           |
| Players (tests A-C) | 1           |
| Startup             | ≈ 25–35 sec |

## Test 0 — Server Idle

Сервер запущен без подключённых игроков.

| Показатель | Значение |
|---|---|
| TPS (5s / 10s / 1m / 5m / 15m) | 20.0 / 20.0 / 20.0 / 20.0 / 20.0 |
| Tick duration, 10s (min / median / 95% / max) | 0.2 / 0.5 / 1.1 / 21.0 ms |
| Tick duration, 1m (min / median / 95% / max) | 0.2 / 0.6 / 1.3 / 21.0 ms |
| CPU, 10s / 1m / 15m (system) | 67% / 57% / 58% |
| CPU, 10s / 1m / 15m (process) | 2% / 4% / 7% |

## Test A — Idle Player

Один игрок подключён и находится в мире без активных действий.

| Показатель | Значение |
|---|---|
| TPS (5s / 10s / 1m / 5m / 15m) | 20.0 / 20.0 / 20.0 / 19.81 / 19.42 |
| Tick duration, 10s (min / median / 95% / max) | 2.7 / 4.9 / 8.3 / 18.1 ms |
| Tick duration, 1m (min / median / 95% / max) | 2.7 / 5.0 / 7.9 / 52.8 ms |
| CPU, 10s / 1m / 15m (system) | 55% / 56% / 70% |
| CPU, 10s / 1m / 15m (process) | 2% / 3% / 6% |

## Test B — Normal Gameplay

Один игрок в течение примерно 5 минут перемещается, строит и взаимодействует с миром.

| Показатель | Значение |
|---|---|
| TPS (5s / 10s / 1m / 5m / 15m) | 20.0 / 20.0 / 20.0 / 20.0 / 19.89 |
| Tick duration, 10s (min / median / 95% / max) | 3.5 / 4.6 / 7.1 / 27.4 ms |
| Tick duration, 1m (min / median / 95% / max) | 3.5 / 5.3 / 7.4 / 66.8 ms |
| CPU, 10s / 1m / 15m (system) | 41% / 40% / 54% |
| CPU, 10s / 1m / 15m (process) | 4% / 3% / 6% |

## Test C — Chunk Generation

Один игрок активно исследует ранее не загруженную территорию.

| Показатель | Значение |
|---|---|
| TPS (5s / 10s / 1m / 5m / 15m) | 20.0 / 20.0 / 20.0 / 20.0 / 19.96 |
| Tick duration, 10s (min / median / 95% / max) | 4.4 / 8.9 / 15.4 / 141.7 ms |
| Tick duration, 1m (min / median / 95% / max) | 4.4 / 9.4 / 16.7 / 162.2 ms |
| CPU, 10s / 1m / 15m (system) | 57% / 57% / 59% |
| CPU, 10s / 1m / 15m (process) | 17% / 14% / 17% |

## Observations

- TPS remained approximately 20 in all tested scenarios.
- Normal gameplay showed low tick durations and no noticeable stuttering.
- Chunk generation increased the typical tick duration but remained well below the 50 ms tick budget.
- Short spikes above 50 ms were observed during chunk generation.
- Maximum observed tick duration was approximately 162 ms.
- Minecraft process CPU usage remained relatively low.
- Occasional visual/chunk rendering glitches were observed on the client.
  The same issue was reproduced in a local single-player world and is therefore
  not currently considered a VanillaBase server performance issue.