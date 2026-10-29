(define (problem entregar-herramientas)
    (:domain taller-mecanico-completo)
    (:objects
        almacen zona-coche - ubicacion
        robot1 - robot
        mecanico1 - mecanico
        llave1 - llave
        gato1 - gato
    )
    (:init
        (at robot1 almacen)
        (at mecanico1 zona-coche)
        (at llave1 almacen)
        (at gato1 almacen)
        (libre robot1)
    )
    (:goal (and (tiene mecanico1 llave1) (tiene mecanico1 gato1)))
)