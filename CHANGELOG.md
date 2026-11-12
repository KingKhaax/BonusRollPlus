# Cambios

## 0.5.0 (12/11/2026)

- Candado en cada ventana (esquina superior derecha) y comando `/br lock`. Desbloqueada se arrastra sin Mayús; fija no se mueve. Se guarda en `BonusRollPlusDB.locked` (por defecto desbloqueada).
- Al salir el ganador, o al terminar la tirada con tiradas ya en el panel, el objeto se queda 4 segundos y desaparece (antes 6).
- Textos nuevos `LOCKED_TIP` y `UNLOCKED_TIP` en los 11 idiomas; el texto de `/br` incluye `lock`.
- El panel lateral sigue leyendo las tiradas del chat (`CHAT_MSG_LOOT`) con los textos globales del cliente.

## 0.4.0 (12/11/2026)

- Logo e icono, aviso de actualización entre jugadores, traducción a 11 idiomas y `/br version`.

## En otro PC

1. `git pull` de este repositorio.
2. Copiar la carpeta `BonusRollPlus` a `World of Warcraft\_forever_\Interface\AddOns\`, sustituyendo la anterior.
3. En el juego, `/reload` y `/br test` para comprobar. `/br lock` fija o desbloquea la ventana.
4. Antes de publicar: `luajit tests/core_tests.lua` y `luajit tests/smoke_test.lua`.
5. La subida a CurseForge se hace con la variable de usuario `CURSEFORGE_API_TOKEN`; falta el número del proyecto.

Historial completo, comandos y límites conocidos: `BonusRollPlus/README.md`.
