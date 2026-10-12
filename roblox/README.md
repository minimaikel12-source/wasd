# Juego de Fuerza: clubs, mentoría y duelo final

## Abrirlo en Roblox Studio (1 minuto)
1. Descarga **`roblox/JuegoFuerza.rbxlx`** de este repositorio (en GitHub: abre el archivo → botón *Download raw file*).
2. Abre **Roblox Studio** → **File → Open from File…** → elige `JuegoFuerza.rbxlx` (o arrástralo a la ventana de Studio).
3. **File → Publish to Roblox As…** para crear tu experiencia.
4. **Game Settings → Security → Enable Studio Access to API Services** = ON (para que el DataStore guarde en Studio).
5. **Game Settings → Avatar → Avatar Type = R15** (las animaciones son para R15).
6. Para probar mentoría y duelo: pestaña **Test → Clients and Servers → 2 Players → Start**.

Comandos de chat en Studio: `/fuerza 5000`, `/dias 7`, `/duelo` (fuerza la invitación al duelo).

## Dónde está cada cosa
| Ruta en Studio | Qué es |
|---|---|
| ReplicatedStorage/Config | Todos los números ajustables + tabla de IDs de animaciones y sonidos |
| ReplicatedStorage/AnimData | Keyframes para el respaldo procedural (generado) |
| ReplicatedStorage/AnimPlayer | Reproduce por ID o, si no hay ID, mueve los Motor6D |
| ReplicatedStorage/Remotes | RemoteEvents/RemoteFunction |
| ServerScriptService/Main | Servidor: Datos, Red, Entrenamiento, Habilidades, Clubs, Duelo |
| StarterPlayer/StarterPlayerScripts/Client | Cliente: UI, Efectos, Ambiente, Mentoria, Duelo |
| ServerStorage/Espadas/Espada | Tool con Handle |
| ServerStorage/Animaciones | 18 KeyframeSequence R15 |
| Workspace/Entrenamiento | 6 equipos (pesas, sacos, roca, yunque) + 4 muñecos |
| Workspace/Arena | Arena rocosa con charcos, columnas, braseros, PuntoA/PuntoB (en Z=4000) |

## Publicar las animaciones (paso a paso)
Para cada KeyframeSequence de `ServerStorage/Animaciones`:
1. Inserta un rig R15: **Avatar → Rig Builder → Block Rig (R15)**.
2. Abre **Avatar → Animation Editor** y selecciona el rig.
3. Dentro del rig crea un **ObjectValue** llamado `AnimSaves` (si no existe). Copia las KeyframeSequence de
   `ServerStorage/Animaciones` (Ctrl+C) y pégalas dentro de `AnimSaves`. En el Animation Editor: **⋯ → Load** → elige una.
4. **⋯ → Publish to Roblox** → pon nombre (ej. `Hab_OndaExpansiva`) → **Submit**.
5. Copia el ID que te da (número) y pégalo en `Config.Animaciones` así: `Hab_OndaExpansiva = "rbxassetid://123456789",`
6. Repite con las 18. Las que dejes vacías siguen funcionando con el respaldo procedural.

Si la experiencia pertenece a un grupo, publica las animaciones en ese mismo grupo (si no, no cargarán).

## Sonidos
En `Config.Sonidos` rellena `MusicaDuelo`, `Lluvia` y `Trueno` con IDs de la Creator Store (Toolbox → Audio). Si están vacíos, hay respaldos.

## Editar desde código (opcional)
`python3 tools/generar.py` regenera animaciones, mapa y espada; `rojo build -o JuegoFuerza.rbxlx` vuelve a crear el lugar (o `rojo serve` + el plugin de Rojo para sincronizar en vivo con Studio).
