<p align="center"><img src="assets/logo.png" width="420" alt="BonusRoll Plus"></p>

<h1 align="center">BonusRoll Plus</h1>

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
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_letter_15.jpg" width="28" height="28" align="absmiddle"> | **Aviso de actualización**: si te cruzas con alguien que tiene una versión más nueva, el addon te lo dice |
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_bag_08.jpg" width="28" height="28" align="absmiddle"> | **Traducido a los 11 idiomas del juego**: español (España y México), inglés, alemán, francés, italiano, portugués de Brasil, ruso, coreano y chino (simplificado y tradicional) |

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
| `/br open` | Abre la ventana de ajustes: 10 diseños con vista previa, tamaño, opacidad, ventanas visibles y Acerca de |
| `/br test` | Muestra tres ventanas de prueba con tus objetos equipados |
| `/br scale 0.5-1.5` | Cambia el tamaño (por defecto 1) |
| `/br rolls` | Muestra u oculta la ventanita de tiradas |
| `/br lock` | Fija o desbloquea las ventanas (igual que el candado) |
| `/br reset` | Devuelve las ventanas a su sitio |
| `/br version` | Muestra la versión instalada |
| `/bonusroll` | Es otro nombre para `/br` |

Arrastra una ventana para moverla. El candado de su esquina la fija; otro clic la desbloquea. La posición se guarda.

## Estado

Versión **0.5.0**. El estilo por defecto es **Cristal Esmerilado** y hay 10 diseños para elegir en `/br open`. La lógica está probada con LuaJIT y con una simulación del juego, pero **todavía no se ha comprobado dentro del cliente**. Todos los detalles, los límites conocidos y lo que falta están en [`BonusRollPlus/README.md`](BonusRollPlus/README.md).

## Qué hay en este repositorio

| Ruta | Contenido |
|---|---|
| `BonusRollPlus/` | El addon, listo para copiar al juego |
| `assets/` | El logo y el icono del addon |
| `index.html` | Las 16 primeras propuestas de diseño (histórico) |
| `preview-en-juego.html` | Maqueta del primer diseño sobre una pantalla de juego (histórico) |
| `tests/` | Pruebas de la lectura de mensajes y un recorrido completo con una simulación del juego |
| `tools/` | Script de subida a CurseForge y changelog en inglés de la versión |
| `docs/` | Última descripción de la página de CurseForge (HTML) |

<sub>Los iconos son de World of Warcraft y pertenecen a Blizzard Entertainment. Este proyecto no está afiliado a Blizzard.</sub>

---

# Notas para quien continúe el trabajo (otra sesión de Claude o una persona)

Este apartado resume todo lo hecho hasta el 2026-11-13, cómo está montado el addon, cómo se prueba y se publica, y qué decisiones ha tomado el autor. Léelo entero antes de tocar nada.

## Estado actual

| Cosa | Estado |
|---|---|
| **0.5.0** | Publicada en CurseForge el 2026-11-13 (proyecto **1800719**, id de archivo 9589441). Commit `290c683`. Pendiente de la revisión de CurseForge. |
| **0.4.0** | Primera versión subida a mano por el autor el 2026-11-12. |
| **0.6.0** | **En desarrollo, sin publicar.** El `.toc` sigue en 0.5.0 a propósito. No subirla hasta que la 0.5.0 esté aprobada y el autor lo pida. |
| Pruebas en el juego | **Casi nada está verificado en el cliente.** Todo se prueba con una simulación (ver «Pruebas»). Lo que el autor ha confirmado a mano: la ventana de tirada, que se oculta la de Blizzard (con ajustes posteriores) y el panel de tiradas tras varias correcciones. |

Contenido de la 0.5.0 (ya publicada): ventana de ajustes con 20 diseños, perfiles, historial `/br history`, diferencia de nivel de objeto, aviso de «no puedes usar este objeto», filas compactas, máximo de ventanas visibles, candado, icono de clase, aviso de actualización entre jugadores, textos en 11 idiomas y dato curioso en el pie de los ajustes.

Contenido pendiente de la 0.6.0 (ver `CHANGELOG.md` y `tools/changelog-en.md`): valor de venta o subasta con `*` morado de apariencia nueva, pestaña Historial con estadísticas, perfiles por especialización, avisos de sonido y parpadeo, ajuste de segundos de cierre tras el ganador (2 por defecto), diseños de 20 a 10, vistas previas cargadas poco a poco, corrección de ventanas duplicadas cuando caen varios objetos a la vez.

## Reglas del autor (obligatorias)

- **Cliente único: WoW Forever.** El addon es exclusivo de ese cliente (versión de juego 1.60.1 en CurseForge, id 17053). No hay que cuidar Retail ni Classic. El `.toc` aún lista interfaces de Retail (16001, 11601, 120107, 120105); limpiar solo si el autor lo pide.
- **Idioma:** al autor se le habla siempre en castellano. Todo mensaje que él vaya a publicar lleva debajo su traducción.
- **Commits:** autor y committer `sr.kitkat <180756772+KingKhaax@users.noreply.github.com>`. **Sin ninguna marca de Claude** ni líneas `Co-Authored-By`.
- **Versiones:** de una en una. Mientras la pendiente no esté publicada no se numera otra. Si el autor dice que ya subió una, la pendiente pasa a ser la siguiente.
- **Changelog:** solo cambios importantes. Nada de arreglos menores o textos sueltos.
- **Textos nuevos:** toda clave nueva va a los **11 idiomas** (esES, esMX, enUS, deDE, frFR, itIT, ptBR, ruRU, koKR, zhCN, zhTW), con los mismos marcadores `%s`/`%d` que el inglés. Hay una prueba que lo comprueba.
- **No tocar sin que lo pida:** otros addons, ajustes del juego, el PC. Está permitido *leer* los addons del autor para entender conflictos.
- **Nada de ventanas en pantalla al probar** y nada de terminales visibles: las tareas programadas usan `conhost --headless`.
- **Código sin comentarios** salvo lo imprescindible.

## Mapa de archivos (`BonusRollPlus/`)

El orden de carga es el del `.toc`:

| Archivo | Para qué sirve |
|---|---|
| `Locales.lua` | Textos base de la ventana y del panel, en 11 idiomas. Crea `ns.L` y `ns.Strings`. |
| `LocalesSettings.lua` | Textos de la ventana de ajustes, en 11 idiomas; reescribe la ayuda de `/br`. |
| `LocalesText.lua` | Nombres de los diseños y changelog de «Acerca de» en los 8 idiomas que no son es/en. |
| `LocalesExtra.lua` | Más textos (perfiles, historial, estadísticas, valores, avisos) y notas de versión por idioma. |
| `Themes.lua` | Los diseños de ventana (se añaden a los del Core). Cada diseño es una tabla de datos, no código. |
| `Core.lua` | Todo el motor: lectura de mensajes, ventanas, diseño, cierre, ajustes en vivo, comandos y eventos. |
| `Facts.lua`, `FactsDEFR.lua`, `FactsITPT.lua`, `FactsRUKO.lua`, `FactsZH.lua` | 200 datos curiosos de WoW; los dos primeros idiomas van en `Facts.lua` (es, en) y el resto en tablas alineadas por posición. |
| `Profiles.lua` | Perfiles: guardar, cargar, exportar e importar (`BRP1;…`), por personaje y por especialización. |
| `Settings.lua` | Ventana de ajustes (5 pestañas: Diseños, Ajustes, Perfiles, Historial, Acerca de) y el botón en las opciones de AddOns. |

Fuera del addon: `tests/` (pruebas), `tools/` (script de subida y changelog en inglés), `assets/` (logo e icono), y `index.html` / `preview-en-juego.html` (maquetas históricas).

## Cómo funciona una tirada (resumen de `Core.lua`)

1. **`START_LOOT_ROLL`** → `OnStartRoll` oculta las ventanas de Blizzard, lee `GetLootRollItemInfo`, pide una ventana con `Acquire` y la rellena con `Setup` (dentro de `pcall`: si falla, imprime el error en rojo y lo manda al gestor de errores).
2. **Ventanas:** se reutilizan desde una reserva por diseño (`pools`). `Release` es idempotente (marca `pooled`) y `Acquire` nunca devuelve una ventana que siga en `active`. Esto arregló el fallo de «cae un objeto y falta una ventana».
3. **Diseño (`Layout`):** apila hasta `maxVisible` ventanas completas; las demás esperan ocultas y, si `compact` está activo, se muestran como filas de una línea (`BuildMini`).
4. **Panel de tiradas (lista de al lado):** se alimenta de dos fuentes, ambas válidas a la vez:
   - el chat (`CHAT_MSG_LOOT`, patrones construidos a partir de los textos globales del cliente; en `esES` las tiradas usan marcadores posicionales);
   - el historial de botín del juego (`C_LootHistory`, evento `LOOT_HISTORY_UPDATE_DROP`), que es la fuente que usa ForeverPlusPlus.
   Se asocia cada mensaje con su ventana por id de objeto y, si no coincide, por **nombre del objeto** (`FindFrame`). Los valores pueden venir «secretos» (`issecretvalue`); se saltan con `Readable`.
5. **Cierre:** al elegir, la ventana se queda hasta que se anuncia el ganador (`MarkWon`) o «todos pasaron» y se cierra `closeDelay` segundos después (2 por defecto, de 0 a 15). Si la tirada acaba sin ganador anunciado, espera hasta el tiempo real de la tirada más 10 s. Cada tirada tiene un `token` propio para que los cierres programados no cierren otra tirada.
6. **Necesidad nunca se bloquea.** Si el juego dice que no puedes usar el objeto, solo se muestra el aviso rojo `CANT_USE` y el motivo del juego en el tooltip. El autor lo exige para vender BoE.
7. **Ventanas de Blizzard:** `HideBlizzard` deja invisibles `GroupLootFrame1..4` y las del contenedor con `SetAlpha(0)` y sin ratón, tras `GroupLootContainer_AddFrame`/`_Update` con `hooksecurefunc` y un retardo. **No usar `HookScript` sobre esas ventanas** y **no recorrer `UIParent`** con `GetName()`: da errores de «objeto prohibido / taint». Con el addon desactivado vuelven a verse.
8. **Valor y apariencia:** `ValueInfo` usa precio de TradeSkillMaster (`TSM_API.GetCustomPriceValue("DBMarket", "i:ID")`) si existe, si no el precio de venta. Un `*` morado marca una apariencia no coleccionada (`C_TransmogCollection`, protegido con `pcall`).
9. **Diferencia de nivel de objeto:** `UpgradeDelta` compara con lo equipado en la casilla (anillos y abalorios con el más flojo; armas ignoran huecos vacíos).
10. **Estadísticas e historial:** `db.history` (máx. 100) y `db.stats`. La pestaña Historial y `/br history` las leen.

### Diseños
`Themes.lua` define cada diseño con `Make(id, título, títuloES, parámetros)`. Las posiciones de los botones salen del `layout` (`grid`, `split`, `row`, `stack`, `ring`, `rail`). El diseño por defecto, `glass`, está en `Core.lua`. Los nombres de los diseños por idioma están en `LocalesText.lua` (`ns.ThemeNames`, un array por idioma **alineado por posición con `ns.ThemeList`**): si añades o quitas un diseño hay que tocar los 11 arrays.

### Ventana de ajustes (`Settings.lua`)
Estilo plano oscuro inspirado en los valores por defecto de ElvUI (`#1A1A1A`, borde negro, acento `#1784D1`, fuente `ARIALN`). Los controles son propios (no usa plantillas de Blizzard). Las vistas previas de los diseños se construyen con el mismo código de las ventanas reales (`ns.BuildPreview`), de 3 en 3 por fotograma. El pie muestra un dato curioso aleatorio.

### Aviso de actualización
Se envía la versión por **mensajes de addon** (prefijo `BRPLUS`, texto `V:0.5.0`) a grupo, banda, instancia y hermandad, como mucho cada 20 s. No es chat visible ni susurro. Al recibir una versión mayor, el addon escribe un aviso en el chat del jugador (`VERSION_OUTDATED`, en 11 idiomas). **No consulta CurseForge** (un addon no puede). Limitación: solo funciona si coincide con alguien que tenga la versión nueva.
Ideas pendientes (el autor aún no las ha decidido): recordar la versión más nueva vista y avisar en sesiones siguientes, y enviarla también a amigos de Battle.net.

## Datos guardados (`BonusRollPlusDB`)

`scale`, `alpha`, `theme`, `maxVisible`, `showRolls`, `showUpgrade`, `compact`, `showValue`, `sound`, `flash`, `closeDelay`, `locked`, `x`, `y`, `v`, `history`, `profiles`, `charProfile`, `specProfile`, `activeProfile`, `stats`. Los valores por defecto están en `DEFAULTS` (`Core.lua`). Los perfiles guardan solo las claves de `ORDER` en `Profiles.lua`.

Comandos: `/br open`, `/br test`, `/br scale`, `/br rolls`, `/br lock`, `/br reset`, `/br history [n|clear]`, `/br version`, `/br debug` (imprime lo que el addon lee del chat, el texto crudo y las ventanas abiertas; útil para diagnosticar el panel de tiradas).

## Pruebas

No hay cliente de WoW en el entorno de desarrollo. Hay un intérprete de **Lua 5.4** (no LuaJIT):

```
lua tests/core_tests.lua      # lectura de mensajes, comparador de versiones
lua tests/smoke_test.lua      # recorrido completo con una simulación del juego
```

`smoke_test.lua` simula el juego con objetos «comodín» (cualquier función desconocida devuelve otro comodín). Por eso **pasar las pruebas no demuestra que algo se vea bien en el juego**: solo que no hay errores de Lua en esos caminos. Comprueba además: 10 diseños, nombres de diseños y changelog en todos los idiomas, claves nuevas en todos los idiomas, mismos `%s`/`%d`, round trip de perfiles, valores fuera de rango, historial y estadísticas.
Consejos: lanza la prueba 40 veces seguidas para detectar fallos intermitentes (hubo uno por recorrer una tabla mientras se modificaba); en Windows, `lua.exe` no entiende rutas `/tmp`, usa rutas `C:/...`.

## Cómo publicar una versión

1. Sube el número en `BonusRollPlus/BonusRollPlus.toc`, `README.md`, `BonusRollPlus/README.md` y `CHANGELOG.md`; añade la entrada en `CHANGES` de `Settings.lua` y las notas por idioma en `LocalesText.lua`/`LocalesExtra.lua`.
2. Escribe el changelog en inglés en `tools/changelog-en.md` (secciones New, Improvement, Fix).
3. Pasa las pruebas. Haz commit como `sr.kitkat`, sin marca de Claude, y `git push origin main`.
4. Crea el zip `Desktop\BonusRollPlus-X.Y.Z.zip` con **una carpeta `BonusRollPlus`** dentro, entradas con `/` y **sin** la carpeta `.omc` (a veces aparece dentro del addon; bórrala antes).
5. Sube con la API: `powershell -NoProfile -ExecutionPolicy Bypass -File tools/upload_curseforge.ps1 -ProjectId 1800719 [-Upload]` (sin `-Upload` es una prueba en seco). El token está en la variable de entorno de usuario `CURSEFORGE_API_TOKEN`; nunca lo escribas en archivos ni lo subas.
6. La **descripción de la página se pone a mano** en CurseForge. La última está en `docs/descripcion-curseforge.html` (inglés, con la parte en español debajo). Las capturas las pone el autor: pendientes, ver abajo.

## Entorno del autor (para no pisarlo)

- La carpeta del addon en el juego es un **enlace** (`junction`) a `BonusRollPlus/` de este repo: lo que cambias aquí se ve en el juego tras `/reload` (o reiniciando si añades archivos nuevos).
- Usa WoW Forever con muchos addons. **EllesmereUIBlizzardSkin** pone skin a las ventanas de tirada de Blizzard; **ForeverPlusPlus** (módulo Loot Rolls, desactivado por defecto) las recoloca. Ninguno crea ventanas de tirada propias.
- Los errores de Lua de la sesión se ven en BugSack; el archivo de datos solo se escribe al recargar o salir.
- Hay tareas programadas en su PC (vigilancia de otro addon, copia de configuración de WoW y la subida de Voidcore Advisor Reborn del 1 de diciembre). No son de este repo; no las toques.
- El proyecto hermano **VoidcoreAdvisor Reborn** (repo `KingKhaax/VoidcoreAdvisorReborn`, CurseForge 1757601) comparte estas reglas.

## Trampas ya conocidas

- En PowerShell, `R` es un alias de `Invoke-History`: no lo uses de nombre de función.
- Los *heredocs* de Bash pierden las barras invertidas de las cadenas de Lua: escribe los scripts con una herramienta de archivos y no con `cat <<EOF`.
- `string.format` con `%d` falla con decimales; los valores de los controles se redondean antes.
- Los textos con ruso, coreano y chino necesitan la fuente del cliente (`STANDARD_TEXT_FONT`); el código ya la usa.
- No uses `HookScript` ni explores marcos de Blizzard desde código «manchado» (ver «Ventanas de Blizzard»).
- Quitar un diseño exige tocar `Themes.lua`, `ns.ThemeNames` (11 arrays) y la prueba `smoke_test.lua`.

## Pendiente

1. **Capturas para la descripción de la 0.6.0.** Las tiene que hacer el autor en el juego. Lista acordada: `01-ventana`, `02-mejora-valor`, `03-no-usable`, `04-filas-compactas`, `05-diseños`, `06-ajustes`, `07-perfiles`, `08-historial`, `09-galeria` y, opcional, `10-exportar`. Cuando las entregue: guardarlas en `assets/`, subirlas y enlazarlas desde `docs/descripcion-curseforge.html`.
2. **Publicar la 0.6.0** cuando la 0.5.0 esté aprobada (seguir «Cómo publicar una versión» y actualizar el `.toc`).
3. Decidir si se mejora el **aviso de actualización** (versión recordada, amigos de Battle.net).
4. Verificar en el juego lo que solo se ha probado con la simulación, sobre todo: ventanas con varios objetos a la vez, el panel de tiradas, el valor y el `*` de apariencia, las filas compactas y la pestaña Historial.
5. Decidir si se limpian del `.toc` las interfaces de Retail.

Descartado por el autor: **atajos de teclado** para las tiradas y la **compatibilidad con otros clientes**.
