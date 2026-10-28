(define (problem resolver-pinchazo) 
    (:domain taller-mecanico)
    (:objects
        almacen zona-coche - ubicacion

        robot1 - robot
        coche1 - coche

        llave gato - herramienta
        rueda-vieja rueda-nueva - rueda
    )

    (:init
        ;; Posicion inicial de los elementos
        (at robot1 almacen)
        (at llave almacen)
        (at gato almacen)
        (at rueda-nueva almacen)

        (at coche1 zona-coche)
        (at rueda-vieja zona-coche)

        ;; estado inicial del robot y coche
        (libre robot1)
        (coche-en-suelo coche1)

    )

    (:goal (and
        (rueda-puesta coche1)
    ))

)
