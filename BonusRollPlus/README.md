# <img src="https://wow.zamimg.com/images/wow/icons/large/inv_scroll_03.jpg" width="36" height="36" align="absmiddle"> BonusRoll Plus 0.3.0

Documentación completa del addon: qué hace, cómo funciona por dentro, comandos, historial de cambios, lo que falta y cómo llevarlo a otro ordenador.

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_note_01.jpg" width="28" height="28" align="absmiddle"> Resumen

Sustituye la ventana de tirada de botín en grupo del juego (Necesidad, Codicia, Desencantar, Pasar) por un panel de cristal esmerilado. No cambia las reglas del botín: las tiradas siguen yendo por `RollOnLoot`, igual que con la ventana original.

- Cliente objetivo: **World of Warcraft Forever** (`_forever_`, interfaz `16001` y `11601`).
- El `.toc` declara también `120107` y `120105` (Retail), **sin probar** allí.
- Archivos: `BonusRollPlus.toc` y `Core.lua`. No usa librerías ni archivos de imagen.
- Datos guardados: `BonusRollPlusDB` (de la cuenta).

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_helmet_01.jpg" width="28" height="28" align="absmiddle"> Funcionalidad

### La ventana

- **Panel de cristal esmerilado**: fondo azul translúcido, borde claro, reflejo en la parte alta y un halo suave.
- **Nombre** con el color de calidad del objeto y **nivel de objeto entre paréntesis** a su lado. Admite dos líneas.
- **Pieza** debajo del nombre, con el formato `Hueco · Tipo` (por ejemplo `Head · Plate`). Sale del hueco de equipo y del subtipo del objeto, ya traducidos por el cliente.
- **Línea de ligadura** («Se liga al recogerlo») cuando el objeto es BoP.
- **Cuatro botones** en cuadrícula de 2x2: <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_dice_01.jpg" width="20" height="20" align="absmiddle"> Necesidad, <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_coin_01.jpg" width="20" height="20" align="absmiddle"> Codicia, <img src="https://wow.zamimg.com/images/wow/icons/large/inv_enchant_disenchant.jpg" width="20" height="20" align="absmiddle"> Desencantar, <img src="https://wow.zamimg.com/images/wow/icons/large/spell_chargenegative.jpg" width="20" height="20" align="absmiddle"> Pasar. Los que el juego no permite salen apagados y el tooltip muestra el motivo (`LOOT_ROLL_INELIGIBLE_REASON`).
- **Tooltip del objeto** al pasar el ratón por el icono.
- **Barra de tiempo** que se vacía. El tiempo sale de `GetLootRollTimeLeft`.
- Tras elegir, el botón elegido queda resaltado y los demás atenuados. La ventana se cierra cuando acaba la tirada (a los 6 segundos si ya elegiste).
- **Pila**: varios objetos a la vez se apilan hacia arriba. Posición por defecto: centro de la pantalla, sobre la barra de acción.
- La ventana original de Blizzard se **oculta** (transparencia 0), no se elimina, para no romper el sistema de botín.

### La ventanita de tiradas

- Panel translúcido al lado derecho de cada ventana.
- Una fila por jugador: icono del tipo de tirada, punto con su color de clase, nombre y número obtenido.
- Orden: Necesidad, Desencantar, Codicia, Pasar y, al final, los que aún no han elegido (solo en grupos de hasta 6).
- Icono de líder para quien va ganando, o para el ganador cuando se anuncia.
- Máximo 12 filas.
- **Cómo se rellena**: lee los mensajes de tirada del chat (`CHAT_MSG_LOOT`) usando las cadenas del propio juego (`LOOT_ROLL_NEED`, `LOOT_ROLL_ROLLED_NEED`, etc.), por lo que funciona en cualquier idioma, incluso con argumentos reordenados. Si el cliente dejara de mandar esos mensajes, la lista saldría vacía.

### Comandos

| Comando | Qué hace |
|---|---|
| `/br` | Muestra la ayuda |
| `/br test` | Tres ventanas de prueba con tus objetos equipados (cabeza, hombros, pecho, cintura, piernas, anillo o arma, el primero que tengas). Tiempo de 90 s. Las tiradas de los demás son de ejemplo y aparecen poco a poco |
| `/br scale 0.5-1.5` | Tamaño. Por defecto 1 |
| `/br rolls` | Muestra u oculta la ventanita de tiradas |
| `/br reset` | Devuelve la pila a su posición por defecto |
| `/bonusroll` | Mismo comando con otro nombre |

Mayús + arrastrar sobre una ventana mueve toda la pila. Se guarda la posición.

`/br` lo comprobé en los addons instalados de Forever y Retail: ninguno lo usa.

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
| `scale` | `1` | Tamaño de la pila |
| `showRolls` | `true` | Mostrar la ventanita de tiradas |
| `v` | `3` | Versión de los ajustes (sirve para restablecer el tamaño al actualizar) |
| `x`, `y` | sin definir | Posición, si la has movido |

Se guardan en `WTF\Account\<tu cuenta>\SavedVariables\BonusRollPlus.lua`.

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_letter_15.jpg" width="28" height="28" align="absmiddle"> Historial de cambios

### 0.3.0 (12/11/2026)

- **Estilo definitivo: Cristal Esmerilado**, elegido entre diez propuestas (cinco con UI UX Pro Max y cinco con Taste Skill).
- Eliminados el selector de estilos, el comando `/br style`, los otros nueve estilos y las fuentes que usaban.
- El addon queda en dos archivos: `BonusRollPlus.toc` y `Core.lua`.

### 0.2.0 (12/11/2026)

- Diez estilos de ventana con selector en `/br test`.
- El nombre admite dos líneas y ya no se corta.
- La corona de la ventanita de tiradas usa el icono de líder del grupo.
- El tamaño por defecto pasa a 1.

### 0.1.0 (12/11/2026)

- Primera versión: pergamino con rodillos, cuatro sellos y mecha de tiempo.
- Nombre con nivel de objeto entre paréntesis y pieza de armadura debajo.
- Ventanita de tiradas leída del chat, con color de clase y corona.
- Pila de varios objetos, escala, posición guardada y arrastre con Mayús.
- Comando `/br` (alias `/bonusroll`).

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
| Estética de WoW, con fuentes y colores del juego | Hecho: fuentes del juego y estilo Cristal Esmerilado |
| Que se pueda exportar a otro ordenador | Hecho (ver arriba) |
| Logo del addon como icono | **Pendiente**: hace falta el archivo de imagen |

### Ideas propuestas y no implementadas

Salieron en la conversación y no se han pedido de forma expresa.

- Atajos de teclado N, G, D y P sobre la ventana activa.
- Comparar el nivel de objeto con lo que llevas equipado y marcar las mejoras.
- Reglas de pasar automático (por calidad, tipo o nivel de objeto).
- Aviso de objeto o apariencia ya conocidos.
- Soporte de la tirada de Transfiguración (ahora se trata como Codicia).

## Límites conocidos

- **No comprobado dentro del juego.** Las texturas, los anclajes y las fuentes se han escrito para el cliente, pero solo se han probado con una simulación. Puede haber iconos en blanco o piezas mal colocadas.
- La ventanita de tiradas depende de que el cliente siga enviando los mensajes de tirada al chat.
- El nivel de objeto y la pieza pueden tardar una fracción de segundo si el cliente aún no tiene el objeto en caché. Se reintenta a los 0,6 s.
- El color de clase solo se conoce para quienes están en tu grupo.
- La ventana original de Blizzard sigue existiendo, solo oculta.
- Los iconos de Blizzard de las tiradas se buscan primero como atlas y después como archivo. Si ninguno existe en tu versión, los botones saldrían sin dibujo.
- El desenfoque real del cristal no existe en WoW: el efecto se consigue con transparencias.

---

Los iconos son de World of Warcraft y pertenecen a Blizzard Entertainment. Este proyecto no está afiliado a Blizzard.
