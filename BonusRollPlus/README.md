# <img src="https://wow.zamimg.com/images/wow/icons/large/inv_scroll_03.jpg" width="36" height="36" align="absmiddle"> BonusRoll Plus 0.1.0

Documentación completa del addon: qué hace, cómo funciona por dentro, comandos, historial de cambios, lo que falta y cómo llevarlo a otro ordenador.

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_note_01.jpg" width="28" height="28" align="absmiddle"> Resumen

Sustituye la ventana de tirada de botín en grupo del juego (Necesidad, Codicia, Desencantar, Pasar) por un pergamino enrollado. No cambia las reglas del botín: las tiradas siguen yendo por `RollOnLoot`, igual que con la ventana original.

- Cliente objetivo: **World of Warcraft Forever** (`_forever_`, interfaz `16001` y `11601`).
- El `.toc` declara también `120107` y `120105` (Retail), **sin probar** allí.
- Archivos: `BonusRollPlus.toc` y `Core.lua`. No usa librerías.
- Datos guardados: `BonusRollPlusDB` (de la cuenta).

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_helmet_01.jpg" width="28" height="28" align="absmiddle"> Funcionalidad

### La ventana

- **Pergamino** con rodillos arriba y abajo, bordes oscurecidos y una cinta oscura con el objeto.
- **Nombre** con el color de calidad del objeto, fuente Morpheus del juego, y **nivel de objeto entre paréntesis** a su lado.
- **Pieza** debajo del nombre, con el formato `Hueco · Tipo` (por ejemplo `Head · Plate`). Sale del hueco de equipo y del subtipo del objeto, ya traducidos por el cliente.
- **Línea de ligadura** («Se liga al recogerlo») cuando el objeto es BoP.
- **Cuatro sellos de lacre**: <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_dice_01.jpg" width="20" height="20" align="absmiddle"> Necesidad, <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_coin_01.jpg" width="20" height="20" align="absmiddle"> Codicia, <img src="https://wow.zamimg.com/images/wow/icons/large/inv_enchant_disenchant.jpg" width="20" height="20" align="absmiddle"> Desencantar, <img src="https://wow.zamimg.com/images/wow/icons/large/spell_chargenegative.jpg" width="20" height="20" align="absmiddle"> Pasar. Los que el juego no permite salen apagados. El tooltip muestra el motivo (`LOOT_ROLL_INELIGIBLE_REASON`).
- **Tooltip del objeto** al pasar el ratón por el icono.
- **Mecha de tiempo** que se consume con una chispa en la punta. El tiempo sale de `GetLootRollTimeLeft`.
- Tras elegir, el sello elegido queda resaltado y los demás atenuados. El pergamino se cierra cuando acaba la tirada (a los 6 segundos si ya elegiste).
- **Pila**: varios objetos a la vez se apilan hacia arriba. Posición por defecto: centro de la pantalla, sobre la barra de acción.
- La ventana original de Blizzard se **oculta** (transparencia 0), no se elimina, para no romper el sistema de botín.

### La ventanita de tiradas

- Pergamino pequeño al lado derecho de cada ventana.
- Una fila por jugador: icono del tipo de tirada, nombre con su color de clase, número obtenido.
- Orden: Necesidad, Desencantar, Codicia, Pasar y, al final, los que aún no han elegido (solo en grupos de hasta 6).
- Corona para quien va ganando, o para el ganador cuando se anuncia.
- Máximo 12 filas.
- **Cómo se rellena**: lee los mensajes de tirada del chat (`CHAT_MSG_LOOT`) usando las cadenas del propio juego (`LOOT_ROLL_NEED`, `LOOT_ROLL_ROLLED_NEED`, etc.), por lo que funciona en cualquier idioma, incluso con argumentos reordenados. Si el cliente dejara de mandar esos mensajes, la lista saldría vacía.

### Comandos

| Comando | Qué hace |
|---|---|
| `/br` | Muestra la ayuda |
| `/br test` | Tres pergaminos de prueba con tus objetos equipados (cabeza, hombros, pecho, cintura, piernas, anillo o arma, el primero que tengas). Tiempo de 45 s. Las tiradas de los demás son de ejemplo y aparecen poco a poco |
| `/br scale 0.5-1.5` | Tamaño. Por defecto 0.85 |
| `/br rolls` | Muestra u oculta la ventanita de tiradas |
| `/br reset` | Devuelve la pila a su posición por defecto |
| `/bonusroll` | Mismo comando con otro nombre |

Mayús + arrastrar sobre un pergamino mueve toda la pila. Se guarda la posición.

`/br` lo comprobé en los addons instalados de Forever y Retail: ninguno lo usa. Antes se llamó `/brp`.

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_gear_01.jpg" width="28" height="28" align="absmiddle"> Cómo funciona por dentro

| Tema | Detalle |
|---|---|
| Eventos | `ADDON_LOADED`, `PLAYER_LOGIN`, `START_LOOT_ROLL`, `CANCEL_LOOT_ROLL`, `CHAT_MSG_LOOT` |
| Datos de la tirada | `GetLootRollItemInfo`, `GetLootRollItemLink`, `GetLootRollTimeLeft` |
| Tirar | `RollOnLoot(rollID, 0 pasar / 1 necesidad / 2 codicia / 3 desencantar)` |
| Datos del objeto | `C_Item.GetItemInfo`, `C_Item.GetDetailedItemLevelInfo` |
| Iconos de las tiradas | Atlas `lootroll-toast-icon-*` si existen, y si no `Interface\Buttons\UI-GroupLoot-*` |
| Dibujo | Todo con texturas de color y degradados, sin archivos de imagen propios |
| Ventana de Blizzard | `GroupLootContainer:SetAlpha(0)` |

### Ajustes guardados (`BonusRollPlusDB`)

| Clave | Por defecto | Significado |
|---|---|---|
| `scale` | `0.85` | Tamaño de la pila |
| `showRolls` | `true` | Mostrar la ventanita de tiradas |
| `x`, `y` | sin definir | Posición, si la has movido |

Se guardan en `WTF\Account\<tu cuenta>\SavedVariables\BonusRollPlus.lua`.

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_letter_15.jpg" width="28" height="28" align="absmiddle"> Historial de cambios

### 0.1.0 (12/11/2026)

- Primera versión: pergamino con rodillos, cinta del objeto, cuatro sellos y mecha de tiempo.
- Nombre con nivel de objeto entre paréntesis y pieza de armadura debajo.
- Ventanita de tiradas leída del chat, con color de clase y corona.
- Pila de varios objetos, escala, posición guardada y arrastre con Mayús.
- Comando `/br` (alias `/bonusroll`) con `test`, `scale`, `rolls` y `reset`.
- Pruebas: lectura de mensajes en inglés y con argumentos reordenados, y un recorrido completo con una simulación del juego.

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_bag_08.jpg" width="28" height="28" align="absmiddle"> Llevarlo a otro ordenador

1. Copia la carpeta **`BonusRollPlus`** entera, con `BonusRollPlus.toc`, `Core.lua` y este `README.md`.
2. Pégala en la carpeta de addons del otro PC:
   - Forever: `World of Warcraft\_forever_\Interface\AddOns\`
   - Retail (sin probar): `World of Warcraft\_retail_\Interface\AddOns\`
3. La carpeta debe llamarse exactamente `BonusRollPlus`, o el juego no encontrará el `.toc`.
4. Si bajas el repositorio como ZIP, copia la carpeta de **dentro** (`BonusRollPlus-main\BonusRollPlus`), no la del ZIP.
5. Para llevarte también tus ajustes (tamaño y posición), copia `BonusRollPlus.lua` de `WTF\Account\<cuenta>\SavedVariables\`. Si no, empezará con los valores por defecto.
6. Abre el juego y prueba con `/br test`.

No hace falta instalar nada más.

## Probar el código (opcional)

Con LuaJIT, desde la raíz del repositorio:

```
luajit tests/core_tests.lua
luajit tests/smoke_test.lua
```

Los dos deben terminar con `passed`.

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_dice_01.jpg" width="28" height="28" align="absmiddle"> Lo que se pidió y su estado

| Petición | Estado |
|---|---|
| Sustituir la ventana de Necesidad, Codicia, Desencantar y Pasar | Hecho |
| Ventanita con las tiradas de la gente al elegir Necesidad o Codicia | Hecho, con la limitación de abajo |
| Nombre con el color de calidad del objeto | Hecho |
| Nivel de objeto entre paréntesis y pieza de armadura junto al nombre | Hecho |
| Estética de WoW Classic, con fuentes y colores del juego | Hecho en parte: fuentes del juego, texturas dibujadas con colores |
| Que se pueda exportar a otro ordenador | Hecho (ver arriba) |

### Ideas propuestas y no implementadas

Salieron en la conversación y no se han pedido de forma expresa.

- Atajos de teclado N, G, D y P sobre el pergamino activo.
- Comparar el nivel de objeto con lo que llevas equipado y marcar las mejoras.
- Reglas de pasar automático (por calidad, tipo o nivel de objeto).
- Aviso de objeto o apariencia ya conocidos.
- Elegir entre los 16 diseños de `index.html` desde un ajuste del addon (ahora solo existe el pergamino).
- Soporte de la tirada de Transfiguración (ahora se trata como Codicia).

## Límites conocidos

- **No comprobado dentro del juego.** Las texturas, los anclajes y las fuentes se han escrito para el cliente, pero solo se han probado con una simulación. Puede haber iconos en blanco o piezas mal colocadas.
- La ventanita de tiradas depende de que el cliente siga enviando los mensajes de tirada al chat.
- El nivel de objeto y la pieza pueden tardar una fracción de segundo si el cliente aún no tiene el objeto en caché. Se reintenta a los 0,6 s.
- El color de clase solo se conoce para quienes están en tu grupo.
- La ventana original de Blizzard sigue existiendo, solo oculta.
- Los iconos de Blizzard de las tiradas se buscan primero como atlas y después como archivo. Si ninguno existe en tu versión, los sellos saldrían sin dibujo.

---

Los iconos son de World of Warcraft y pertenecen a Blizzard Entertainment. Este proyecto no está afiliado a Blizzard.
