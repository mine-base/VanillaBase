# Чистый сервер без плагинов
Первый контрольный замер VanillaBase после базовой настройки сервера.
Используется чистый Purpur без сторонних плагинов.

**Environment**

| Параметр            |        Значение |
| ------------------- | --------------: |
| Minecraft           |          26.1.2 |
| Purpur              |          26.1.2 |
| Java                |              25 |
| RAM                 |            8 GB |
| Plugins             |               0 |
| Players (tests A-C) |               1 |
| Startup             | **≈ 25–35 sec** |

## Test 0 — Server Idle

| Показатель | Значение |
|---|---|
| TPS (5s / 10s / 1m / 5m / 15m) | 20.0 / 20.0 / 20.0 / 20.0 / 20.0 |
| Tick duration, 10s (min / median / 95% / max) | 0.2 / 0.5 / 1.1 / 21.0 ms |
| Tick duration, 1m (min / median / 95% / max) | 0.2 / 0.6 / 1.3 / 21.0 ms |
| CPU, 10s / 1m / 15m (system) | 67% / 57% / 58% |
| CPU, 10s / 1m / 15m (process) | 2% / 4% / 7% |

## Test A — Idle Player

| Показатель | Значение |
|---|---|
| TPS (5s / 10s / 1m / 5m / 15m) | 20.0 / 20.0 / 20.0 / 19.81 / 19.42 |
| Tick duration, 10s (min / median / 95% / max) | 2.7 / 4.9 / 8.3 / 18.1 ms |
| Tick duration, 1m (min / median / 95% / max) | 2.7 / 5.0 / 7.9 / 52.8 ms |
| CPU, 10s / 1m / 15m (system) | 55% / 56% / 70% |
| CPU, 10s / 1m / 15m (process) | 2% / 3% / 6% |

## Test B — Normal Gameplay

| Показатель | Значение |
|---|---|
| TPS (5s / 10s / 1m / 5m / 15m) | 20.0 / 20.0 / 20.0 / 20.0 / 19.89 |
| Tick duration, 10s (min / median / 95% / max) | 3.5 / 4.6 / 7.1 / 27.4 ms |
| Tick duration, 1m (min / median / 95% / max) | 3.5 / 5.3 / 7.4 / 66.8 ms |
| CPU, 10s / 1m / 15m (system) | 41% / 40% / 54% |
| CPU, 10s / 1m / 15m (process) | 4% / 3% / 6% |

## Test C — Chunk Generation

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


