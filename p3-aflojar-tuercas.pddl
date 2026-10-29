(define (problem aflojar-tuercas-simple)
    (:domain taller-mecanico-completo)
    (:objects
        almacen zona-coche - ubicacion
        robot1 - robot
        coche1 - coche
        llave1 - llave
        rueda-vieja - rueda
    )
    (:init
        (at robot1 almacen)
        (at llave1 almacen)
        (at coche1 zona-coche)
        (libre robot1)
        (coche-en-suelo coche1)
        (tuercas-apretadas coche1)
        (montada rueda-vieja coche1)
    )
    (:goal (tuercas-aflojadas coche1))
)