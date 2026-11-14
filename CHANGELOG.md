# Cambios

## 0.7.0 (pendiente de publicar)

- Reglas automáticas (apagadas por defecto): pasar automáticamente objetos que bajan tu nivel de objeto y codicia automática en BoE baratos. Siempre te lo dicen en el chat y nunca piden Necesidad.
- Valor de venta, de la casa de subastas y de desencantar (TradeSkillMaster) en cada tirada, cada uno con su icono y con las monedas del juego; «No se puede vender» si el objeto no vale nada.
- Etiqueta BiS dorada junto al valor cuando el objeto es una de tus elecciones en NaowhForever_BiS.
- Segundos restantes sobre la barra de tiempo, con colores.
- Dirección de apilado y espacio entre ventanas, tamaño del texto y modo de filas compactas siempre activas.
- Perfiles por tipo de contenido: bandas, mazmorras y mundo abierto.
- Historial: resumen de la sesión con el valor total, filtro por calidad y exportar como texto.
- La ventana de ajustes se organiza en secciones y tiene scroll.

## 0.7.0 (pendiente de publicar)

- Reglas automáticas (apagadas por defecto): pasar automáticamente objetos que bajan tu nivel de objeto y codicia automática en BoE baratos. Siempre te lo dicen en el chat y nunca piden Necesidad.
- Valor de venta, de la casa de subastas y de desencantar (TradeSkillMaster) en cada tirada, cada uno con su icono y con las monedas del juego; «No se puede vender» si el objeto no vale nada.
- Etiqueta BiS dorada junto al valor cuando el objeto es una de tus elecciones en NaowhForever_BiS.
- Segundos restantes sobre la barra de tiempo, con colores.
- Dirección de apilado y espacio entre ventanas, tamaño del texto y modo de filas compactas siempre activas.
- Perfiles por tipo de contenido: bandas, mazmorras y mundo abierto.
- Historial: resumen de la sesión con el valor total, filtro por calidad y exportar como texto.
- La ventana de ajustes se organiza en secciones y tiene scroll.

## 0.6.0 (13/11/2026)

- Valor de venta o de subasta (precio de TradeSkillMaster si lo tienes) en cada tirada, con un * morado cuando el objeto tiene una apariencia que no posees.
- Avisos opcionales: sonido al aparecer una tirada y parpadeo del marco cuando queda poco tiempo.
- Pestaña Historial con estadísticas: tiradas en las que has participado, ganadas, con Necesidad y con Codicia, y ganadas en los últimos 7 días.
- Perfiles por especialización, además de por personaje.
- De 20 a 10 diseños de ventana, los más cuidados: cristal esmerilado, pergamino arcano, forja de acero, vacío violeta, cofre dorado, piedra rúnica, escarcha, minimal oscuro, Alianza y Horda.
- La ventana de ajustes carga las vistas previas poco a poco y abre más rápido.
- Ajuste para elegir cuántos segundos se queda la ventana tras anunciarse el ganador (2 por defecto, de 0 a 15).
- El historial muestra el nivel de objeto de cada pieza, sigue el idioma del juego y enseña el tooltip al pasar el ratón o hacer clic.
- El addon es exclusivo de WoW Forever.
- Corregido: cuando caían dos o más objetos a la vez, podía faltar una de las ventanas de tirada.

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
