(define (problem resolver-pinchazo)
    (:domain taller-mecanico-completo)
    (:objects
        almacen zona-coche - ubicacion
        robot1 - robot
        coche1 - coche
        llave1 - llave
        gato1 - gato
        rueda-vieja rueda-nueva - rueda
    )

    (:init
        (at robot1 almacen)
        (at llave1 almacen)
        (at gato1 almacen)
        (at rueda-nueva almacen)
        (at coche1 zona-coche)

        (libre robot1)
        (coche-en-suelo coche1)
        (tuercas-apretadas coche1)
        (montada rueda-vieja coche1)
    )

    (:goal (and
        (montada rueda-nueva coche1)
        (coche-en-suelo coche1)
        (tuercas-apretadas coche1)
    ))
)