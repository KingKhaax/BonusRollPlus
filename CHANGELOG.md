# Cambios

## Pendiente (sin publicar)

- Tooltips: nuevas líneas, cada una con su ajuste: comparación con lo que llevas puesto (+12 / -3) y valor en subasta y al desencantar (con TSM).
- Chat: el nivel del objeto aparece dentro de los enlaces de objetos (botín, grupo, banda, hermandad y decir).
- Ventana de tirada: avisa de objetos que se ligan al equiparlos y de armadura más pesada de la que puedes llevar.
- Al ganar un objeto: sonido y mensaje, aviso de que puedes intercambiarlo con el grupo durante 2 horas y, si pierdes por 3 puntos o menos, un mensaje de "por poco".
- Historial: nuevo filtro para ver solo tus victorias. El filtro por calidad y la exportación a texto ya existían.
- Nuevo ajuste: el nivel del objeto, entre paréntesis y con el color del objeto, también sale a la izquierda del nombre en los tooltips del juego de cualquier objeto equipable (activado por defecto; se apaga en ajustes).
- El nivel del objeto, entre paréntesis, solo sale en piezas de equipo (armas, armaduras, anillos, abalorios, de cualquier clase; no en materiales ni objetos de vender), a la izquierda del nombre y con el color de la calidad del objeto (antes salía en crema) y con la misma fuente que el nombre.

## 0.9.2

- Arreglo: el chat de botín llega sin enlace y con el prefijo [Botín]; ahora se lee igual (nombre del objeto, jugador y tirada se identifican por su forma, no por su orden), así que las tiradas vuelven a aparecer y las ventanas ya no se quedan colgadas.
- La lista de tiradas se rellena solo con el chat y cada objeto empieza con la lista vacía; ya no se usa el historial de botín, que mezclaba tiradas de repartos anteriores del mismo objeto.

## 0.9.1

- Cuando el mismo objeto sale varias veces, cada ventana muestra solo las tiradas de su propio reparto, sin las de repartos anteriores.
- Si el tiempo de una tirada se acaba y el juego no anuncia ganador, la ventana se cierra sola a los 12 segundos en vez de quedarse bloqueada.
- Línea de valor más limpia: el asterisco morado de apariencias desconocidas ya no sale y las monedas quedan a la altura de los números.

## 0.9.0

- Ctrl + clic en el icono del objeto abre el probador del juego (transmog) con esa pieza.
- Nueva opción en Ajustes (desactivada por defecto) para ocultar el aviso del juego «Has recibido» que sale abajo al ganar un objeto. Se guarda en los perfiles.
- Los diseños Vacío violeta y Escarcha ya no llevan círculos decorativos.
- Las monedas de la línea de valor ya no se pisan con los iconos de subasta y desencantar y quedan alineadas con el texto.

## 0.8.0

- Nueva opción para usar la ventana de tirada del propio juego: BonusRoll Plus oculta la suya pero mantiene a la derecha la lista con lo que ha tirado cada jugador.
- Nueva regla automática (apagada por defecto): pedir Necesidad en las recetas de tus profesiones que aún no has aprendido. Te dice en el chat lo que ha hecho.

## 0.7.0

- Reglas automáticas (apagadas por defecto): pasar automáticamente objetos que bajan tu nivel de objeto y codicia automática en BoE baratos. Siempre te lo dicen en el chat y nunca piden Necesidad.
- Valor de venta, de la casa de subastas y de desencantar (TradeSkillMaster) en cada tirada, cada uno con su icono y con las monedas del juego; «No se puede vender» si el objeto no vale nada.
- Etiqueta BiS dorada junto al valor cuando el objeto es una de tus elecciones en NaowhForever_BiS.
- Segundos restantes sobre la barra de tiempo, con colores.
- Dirección de apilado y espacio entre ventanas, tamaño del texto y modo de filas compactas siempre activas.
- Perfiles por tipo de contenido: bandas, mazmorras y mundo abierto.
- Historial: resumen de la sesión con el valor total, filtro por calidad y exportar como texto.
- La ventana de ajustes se organiza en secciones y tiene scroll.

## 0.7.0

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
