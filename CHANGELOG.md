# Cambios

## 0.5.0 (13/11/2026)

- Ventana de ajustes (`/br open` o «Abrir ajustes» en las opciones de AddOns): 20 diseños con vista previa, el cristal esmerilado por defecto, tamaño, opacidad, ventanas visibles, lista de tiradas y posición bloqueable.
- Máximo de 3 ventanas a la vez; las demás esperan y aparecen al cerrarse una.
- Diferencia de nivel de objeto con lo que llevas puesto, aviso de «no lo puedes usar», filas compactas para las tiradas en espera, historial (`/br history`) y perfiles con exportar e importar.
- Candado en cada ventana y `/br lock`.
- Icono de clase junto al nombre de cada jugador.
- Aviso de actualización entre jugadores y traducción a los 11 idiomas.
- Dato curioso aleatorio de World of Warcraft en el pie de la ventana de ajustes.

## 0.4.0 (12/11/2026)

- Primera versión publicada en CurseForge.

## 0.1.0 (12/11/2026)

- Primera versión: ventana de tirada con nivel de objeto, pieza de armadura y lista de tiradas de todos.

## En otro PC

1. `git pull` de este repositorio.
2. Copiar la carpeta `BonusRollPlus` a `World of Warcraft\_forever_\Interface\AddOns\`, sustituyendo la anterior.
3. En el juego, `/reload` y `/br test` para comprobar. `/br lock` fija o desbloquea la ventana.
4. Antes de publicar: `luajit tests/core_tests.lua` y `luajit tests/smoke_test.lua`.
5. La subida a CurseForge se hace con la variable de usuario `CURSEFORGE_API_TOKEN`; falta el número del proyecto.

Historial completo, comandos y límites conocidos: `BonusRollPlus/README.md`.
