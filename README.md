<h1 align="center"><img src="https://wow.zamimg.com/images/wow/icons/large/inv_scroll_03.jpg" width="64" height="64" align="absmiddle"><br>BonusRoll Plus</h1>

<p align="center"><b>La ventana de tirada de botín de WoW, en cristal esmerilado.</b><br>
Un addon para World of Warcraft Forever que sustituye la ventana de Necesidad, Codicia, Desencantar y Pasar por un panel translúcido con el nivel de objeto, la pieza y la lista de tiradas de todos al lado.</p>

<p align="center"><img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_dice_01.jpg" width="40" height="40" align="absmiddle"> <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_coin_01.jpg" width="40" height="40" align="absmiddle"> <img src="https://wow.zamimg.com/images/wow/icons/large/inv_enchant_disenchant.jpg" width="40" height="40" align="absmiddle"> <img src="https://wow.zamimg.com/images/wow/icons/large/spell_chargenegative.jpg" width="40" height="40" align="absmiddle"></p>

---

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_helmet_01.jpg" width="28" height="28" align="absmiddle"> Para qué sirve

La ventana de tirada que trae el juego es pequeña y no te dice casi nada. Con BonusRoll Plus, al caer un objeto en grupo ves de un vistazo:

| | |
|---|---|
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_helmet_01.jpg" width="28" height="28" align="absmiddle"> | **El nombre del objeto** con el color de su calidad, y a su lado **el nivel de objeto entre paréntesis** |
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_shoulder_01.jpg" width="28" height="28" align="absmiddle"> | **La pieza a la que pertenece**, por ejemplo `Head · Plate` o `Shoulder · Mail` |
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_dice_01.jpg" width="28" height="28" align="absmiddle"> | **Necesidad**, <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_coin_01.jpg" width="28" height="28" align="absmiddle"> **Codicia**, <img src="https://wow.zamimg.com/images/wow/icons/large/inv_enchant_disenchant.jpg" width="28" height="28" align="absmiddle"> **Desencantar** y <img src="https://wow.zamimg.com/images/wow/icons/large/spell_chargenegative.jpg" width="28" height="28" align="absmiddle"> **Pasar** en cuatro botones con su nombre. Los que no puedes elegir salen apagados y el tooltip dice por qué |
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_note_01.jpg" width="28" height="28" align="absmiddle"> | **Una ventanita al lado con las tiradas de cada jugador**, con su color de clase y una corona para quien va ganando |
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_gear_01.jpg" width="28" height="28" align="absmiddle"> | **Una barra de tiempo** que se vacía mientras decides |

Si caen varios objetos a la vez, las ventanas se apilan hacia arriba sobre la barra de acción.

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_letter_15.jpg" width="28" height="28" align="absmiddle"> Instalación

1. Copia la carpeta **`BonusRollPlus`** de este repositorio (no el repositorio entero) dentro de:
   ```
   World of Warcraft\_forever_\Interface\AddOns\
   ```
2. Abre el juego y, en la pantalla de personajes, comprueba en **AddOns** que aparece *BonusRoll Plus*.
3. Dentro del juego escribe `/br test` para verlo sin esperar a un botín.

Si el juego ya estaba abierto, escribe `/reload` antes.

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_bag_08.jpg" width="28" height="28" align="absmiddle"> Comandos

| Comando | Qué hace |
|---|---|
| `/br test` | Muestra tres ventanas de prueba con tus objetos equipados |
| `/br scale 0.5-1.5` | Cambia el tamaño (por defecto 1) |
| `/br rolls` | Muestra u oculta la ventanita de tiradas |
| `/br reset` | Devuelve las ventanas a su sitio |
| `/bonusroll` | Es otro nombre para `/br` |

Mayús + arrastrar sobre una ventana la mueve. La posición se guarda.

## Estado

Versión **0.3.0**. El estilo es **Cristal Esmerilado**, elegido entre diez propuestas hechas con UI UX Pro Max y Taste Skill. La lógica está probada con LuaJIT y con una simulación del juego, pero **todavía no se ha comprobado dentro del cliente**. Todos los detalles, los límites conocidos y lo que falta están en [`BonusRollPlus/README.md`](BonusRollPlus/README.md).

## Qué hay en este repositorio

| Ruta | Contenido |
|---|---|
| `BonusRollPlus/` | El addon, listo para copiar al juego |
| `index.html` | Las 16 primeras propuestas de diseño (histórico) |
| `preview-en-juego.html` | Maqueta del primer diseño sobre una pantalla de juego (histórico) |
| `tests/` | Pruebas de la lectura de mensajes y un recorrido completo con una simulación del juego |

<sub>Los iconos son de World of Warcraft y pertenecen a Blizzard Entertainment. Este proyecto no está afiliado a Blizzard.</sub>
