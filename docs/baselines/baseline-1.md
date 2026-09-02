# Сервер с плагинами для кроссплатформенности и аутентификации
Контрольный замер VanillaBase после настройки важных плагинов концепции сервер.
Добавленные плагины: `Geyser`, `Floodgate`, `ViaVersion`, `AuthMe`, `MultiVerse` `BetterRTP`, `RTPEvents`.

**Environment**

| Параметр            |         Значение |
| ------------------- | ---------------: |
| Minecraft           |           26.1.2 |
| Purpur              |           26.1.2 |
| Java                |               25 |
| RAM                 |             8 GB |
| Plugins             |                7 |
| Players (tests A-C) |                2 |
| Startup             | **≈ 33.968 sec** |

## Test 0 — Server Idle

| Показатель                                    | Значение                           |
| --------------------------------------------- | ---------------------------------- |
| TPS (5s / 10s / 1m / 5m / 15m)                | 20.0 / 20.0 / 20.0 / 19.91 / 19.97 |
| Tick duration, 10s (min / median / 95% / max) | 0.1 / 0.8 / 1.6 / 16.4 ms          |
| Tick duration, 1m (min / median / 95% / max)  | 0.1 / 0.9 / 1.6 / 16.4 ms          |
| CPU, 10s / 1m / 15m (system)                  | 17% / 17% / 26%                    |
| CPU, 10s / 1m / 15m (process)                 | 4% / 3% / 9%                       |

## Test A — Idle Player

| Показатель                                    | Значение                          |
| --------------------------------------------- | --------------------------------- |
| TPS (5s / 10s / 1m / 5m / 15m)                | 20.0 / 20.0 / 20.0 / 20.0 / 19.84 |
| Tick duration, 10s (min / median / 95% / max) | 5.5 / 9.7 / 19.3 / 37.5 ms        |
| Tick duration, 1m (min / median / 95% / max)  | 5.4 / 8.4 / 16.9 / 87.8 ms        |
| CPU, 10s / 1m / 15m (system)                  | 32% / 30% / 38%                   |
| CPU, 10s / 1m / 15m (process)                 | 11% / 9% / 13%                    |

## Test B — Normal Gameplay

| Показатель                                    | Значение                           |
| --------------------------------------------- | ---------------------------------- |
| TPS (5s / 10s / 1m / 5m / 15m)                | 20.0 / 20.0 / 20.0 / 19.96 / 19.91 |
| Tick duration, 10s (min / median / 95% / max) | 6.2 / 8.0 / 15.1 / 22.9 ms         |
| Tick duration, 1m (min / median / 95% / max)  | 5.6 / 7.9 / 16.2 / 66.7 ms         |
| CPU, 10s / 1m / 15m (system)                  | 25% / 22% / 38%                    |
| CPU, 10s / 1m / 15m (process)                 | 7% / 8% / 15%                      |

## Test C — Chunk Generation

| Показатель                                    | Значение                           |
| --------------------------------------------- | ---------------------------------- |
| TPS (5s / 10s / 1m / 5m / 15m)                | 20.0 / 20.0 / 20.0 / 19.95 / 19.96 |
| Tick duration, 10s (min / median / 95% / max) | 8.2 / 11.6 / 22.1 / 218.0 ms       |
| Tick duration, 1m (min / median / 95% / max)  | 8.0 / 12.8 / 34.0 / 218.0 ms       |
| CPU, 10s / 1m / 15m (system)                  | 48% / 55% / 36%                    |
| CPU, 10s / 1m / 15m (process)                 | 14% / 22% / 15%                    |

## Observations
`...`


