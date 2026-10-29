# Taller mecánico cooperativo en PDDL

Un robot ayuda a cambiar una rueda pinchada en un taller. Está modelado en PDDL clásico (STRIPS + tipos) y resuelto con varios planificadores.

Nació como trabajo para comprender la programación en PDDL, es un ejemplo pequeño y completo de PDDL: **un dominio, tres problemas, los planes ya resueltos** y validados.

## Qué hay aquí

```
.
├── domain.pddl
├── p1-cambiar-rueda.pddl
├── p2-entregar-herramientas.pddl
├── p3-aflojar-tuercas.pddl
├── README.md            
└── plans/
    ├── P1/
    │   ├── p1-astar-cambiar-rueda.pddl.soln
    │   ├── p1-bfs-cambiar-rueda.pddl.soln
    │   ├── p1-cambiar-rueda.plan
    │   └── p1-gbf-cambiar-rueda.pddl.soln
    ├── P2/
    │   ├── p2-astar-entregar-herramientas.pddl.soln
    │   ├── p2-bfs-entregar-herramientas.pddl.soln
    │   ├── p2-entregar-herramientas.plan
    │   └── p2-gbf-entregar-herramientas.pddl.soln
    └── P3/
        ├── p3-aflojar-tuercas.plan
        ├── p3-astar-aflojar-tuercas.pddl.soln
        ├── p3-bfs-aflojar-tuercas.pddl.soln
        └── p3-gbf-aflojar-tuercas.pddl.soln
```

Un solo dominio y varios problemas: lo único que cambia entre ellos son los objetos, el estado inicial y el objetivo.

## Probarlo en 5 minutos

**Opción A: VS Code.** Instala la extensión *PDDL* de Jan Dolejsi, abre `domain.pddl` y un problema, y ejecuta el planificador (`PDDL: Run the planner and display the plan`). En este proyecto se usó `dual-bfws-ffparser` del servicio *planning.domains*; necesita internet y tarda unos 3-4s por la red, aunque la búsqueda en sí son milisegundos.

**Opción B: local con pyperplan.** Más simple y reproducible:

```bash
pip install pyperplan
pyperplan -l info -s bfs   -H blind domain.pddl p1-cambiar-rueda.pddl   # óptimo
pyperplan -l info -s astar -H lmcut domain.pddl p1-cambiar-rueda.pddl   # óptimo
PYTHONHASHSEED=0 pyperplan -l info -s gbf -H hff domain.pddl p1-cambiar-rueda.pddl
```

En PowerShell, la semilla se fija con `$env:PYTHONHASHSEED = "0"` antes del comando.

## El modelo

La idea: todo lo que tiene posición cuelga de `locatable`, y solo lo que el robot puede cargar (`portatil`) puede recogerse. Así el coche no se puede coger.

```
ubicacion
locatable ── robot
          ├─ mecanico
          ├─ coche
          └─ portatil ── rueda
                    └─ herramienta ── llave, gato
```

Hay 10 tipos, 10 predicados y 10 acciones, y el dominio no declara constantes. Los predicados cubren tres cosas: dónde está cada objeto y qué lleva la pinza
(`at`, `holding`, `libre`); el estado del coche (`coche-en-suelo`, `coche-elevado`, `tuercas-aflojadas`, `tuercas-apretadas`); y qué rueda está montada (`montada`, `hueco-libre`), más `tiene` para lo entregado al mecánico.

| Acción | Qué hace | Necesita |
|---|---|---|
| `mover-robot`, `recoger`, `soltar`, `entregar` | Mover, coger, dejar y dar al mecánico | Estar en el mismo sitio; pinza libre para recoger |
| `aflojar-tuercas` | Afloja con la llave | Llave en la pinza, coche en el suelo |
| `levantar-coche` | Eleva con el gato | Gato en la pinza, tuercas aflojadas |
| `quitar-rueda` | Saca la rueda montada | Pinza libre, rueda montada, coche elevado |
| `montar-rueda` | Pone la rueda en el hueco | Rueda en la pinza, hueco libre |
| `bajar-coche` | Baja con el gato | Gato en la pinza, coche elevado |
| `apretar-tuercas` | Aprieta con la llave | Llave en la pinza, rueda montada, coche en el suelo |

El orden del cambio de rueda no está programado: sale solo de las precondiciones. Cada acción mecánica consume un estado del coche y produce el siguiente.

**Una sola pinza.** El robot lleva un objeto a la vez. Es una simplificación (el enunciado hablaba de un robot de dos brazos) y explica los viajes de ida y vuelta que verás en los planes.

## Los problemas

| Problema | Qué pasa | Objetivo |
|---|---|---|
| P1 | El robot lo hace todo él | Rueda nueva montada, coche en el suelo, tuercas apretadas |
| P2 | El robot trae herramientas al mecánico, que espera junto al coche | El mecánico tiene la llave y el gato |
| P3 | Sin mecánico ni gato | Tuercas aflojadas |

## Resultados

Longitud de los planes (pasos). Los tres planes de dual-bfws están **validados con VAL** (`Plan valid`, valores 24, 7 y 3).

| Planificador | P1 | P2 | P3 | ¿Óptimo? | Búsqueda P1 | Nodos P1 |
|---|---|---|---|---|---|---|
| dual-bfws-ffparser | 24 | 7 | 3 | no | 0,00086 s | 62 |
| pyperplan, BFS | 20 | 7 | 3 | sí | 0,016 s | 387 |
| pyperplan, A\* + lmcut | 20 | 7 | 3 | sí | 0,44 s | 137 |
| pyperplan, GBFS + hff | 22 | 7 | 3 | no | 0,078 s | 127 |

Los tiempos los mide cada planificador por su cuenta (uno en C++ y otro en Python), así que **no son comparables entre sí**. Las ejecuciones de pyperplan no se validaron con VAL.

## Comparativa: qué se ve y por qué

- **P2 y P3 salen igual en todos** (7 y 3 pasos): son tan pequeños que no hay holgura. Todo el interés está en P1.
- **dual-bfws da 24 pasos y el óptimo es 20.** No es un error: BFWS busca *una* solución rápida, no la más corta. La diferencia es un rodeo inútil: lleva el gato al almacén y lo trae de vuelta. BFS y A\* garantizan el óptimo.
- **A\* expande menos nodos que BFS pero tarda más** (137 frente a 387 nodos, 0,44 s frente a 0,016 s). En un problema tan pequeño, calcular `lmcut` en cada nodo cuesta más de lo que ahorra. Con problemas grandes la historia sería otra.
- **GBFS con `hff` da 22**, entre los dos. Es rápido pero no garantiza el óptimo.
- **En P1, dual-bfws necesita dos etapas:** la primera (1-BFWS) no encuentra plan y pasa a la segunda, con landmarks. Que salga `Plan found with cost: NOTFOUND` en la primera no es un fallo.

Esto es solo una muestra pequeña. No sacamos conclusiones generales.

## Lo que me enseñaron los errores

El modelo no salió bien a la primera. Cada plan «válido pero absurdo» señaló un hueco:

| Versión | Qué pasó | Corrección |
|---|---|---|
| V0 | Plan de 3 pasos; sirvió para probar sintaxis y planificador | — |
| V1 | Tipos laxos: el robot **recogía el coche** (12 pasos) | `llave` y `gato` como tipos propios; coche fuera de `portatil` |
| V2 | Banderas genéricas: el plan **quitaba la rueda nueva** y la volvía a poner (15 pasos) | `montada ?w ?c` y `hueco-libre`; objetivo con la rueda concreta |
| V3 | Modelo actual | — |

La lección: un plan que pasa el validador puede estar mal si el modelo no lo restringe lo suficiente. **Validar no basta; hay que leer el plan.**

## Lo que no hace (y por dónde seguir)

- **Mecánico pasivo.** En P2 solo recibe herramientas; no ejecuta nada. Para un taller de verdad cooperativo haría falta un tipo común (por ejemplo `agente`) con su propio inventario, de modo que robot y mecánico puedan usar las mismas acciones.
- **Una pinza, no dos.** Pasar a dos brazos exige duplicar `holding` y `libre`.
- **Sin tiempo ni recursos.** Las acciones son instantáneas. Con duraciones necesitarías un planificador temporal (OPTIC, por ejemplo); con números
  (batería, par de apriete), uno numérico como ENHSP.
- **Sin invención de herramientas.** Usar una herramienta alternativa cuando falta la adecuada queda fuera. Es la extensión que propone el enunciado.
- **Un solo coche y dos ubicaciones.** Escalar a más objetos es fácil, pero habría que revisar cómo se comportan los planificadores.

## Para usarlo con tus propios problemas

1. Copia un problema de `pddl/problems/` y cámbiale `objects`, `init` y `goal`.
2. Declara cada objeto con su tipo.
3. Pon objetivos que nombren **objetos concretos**, como `montada rueda-nueva coche1`, en vez de banderas genéricas.

## Trucos y avisos

- **`unknown or empty type` no es un error.** Sale cuando un problema no declara objetos de algún tipo (por ejemplo P3 sin mecánico): el planificador descarta las acciones que no puede usar.
- **pyperplan sobrescribe el plan.** Escribe`<problema>.soln` junto al problema cada vez que corre. Renómbralo antes de lanzar otra configuración.
- **`gbf` + `hff` no es determinista.** El resultado depende de la semilla de hash de Python: sin fijar `PYTHONHASHSEED` puedes obtener 22 o 24 pasos en P1.
- **Para validar en VS Code,** el plan debe empezar con dos líneas que dicen a la extensión qué dominio y problema usar:
  ```
  ;;!domain: taller-mecanico-completo
  ;;!problem: resolver-pinchazo
  ```
  Luego `Ctrl+Shift+P` → `PDDL: Validate plan`.
- **pyperplan** también valida solo, si tienes `validate` (VAL) en el `PATH`.