(define (domain taller-mecanico)
    (:requirements :strips :typing)
    
    (:types
        ubicacion objeto - object
        herramienta rueda - objeto
        robot mecanico - object
        coche - object
    )
    
    (:predicates
        (at ?obj - objeto ?loc - ubicacion)
        (holding ?r - robot ?item - objeto)
        (libre ?r - robot)

        (coche-en-suelo ?c - coche)
        (coche-elevado ?c - coche)
        (tuercas-flojas ?c - coche)
        (rueda-quitada ?c - coche)
        (rueda-puesta ?c - coche)
    )

    ;; acciones de movimiento y manipulación
    (:action recoger 
        :parameters (?r - robot ?item - objeto ?loc - ubicacion) 
        :precondition (and (at ?r ?loc) (at ?item ?loc) (libre ?r)) 
        :effect (and 
            (not (at ?item ?loc)) 
            (holding ?r ?item) 
            (not (libre ?r))
        ) 
    )
    
    (:action Soltar
        :parameters (?r - robot ?item - objeto ?loc - ubicacion)
        :precondition (and (at ?r ?loc) (holding ?r ?item))
        :effect (and
            (not (holding ?r ?item))
            (at ?item ?loc)
            (libre ?r)    
        )
    )
    

    (:action mover-robot
        :parameters (?r - robot ?loc-desde - ubicacion ?loc-hasta - ubicacion)
        :precondition (and (at ?r ?loc-desde) )
        :effect (and 
            (not (at ?r ?loc-desde))
            (at ?r ?loc-hasta)
        )
    )
    
)