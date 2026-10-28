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
    (:action mover-robot
        :parameters (?r - robot ?loc-desde - ubicacion ?loc-hasta - ubicacion)
        :precondition (and (at ?r ?loc-desde) )
        :effect (and 
            (not (at ?r ?loc-desde))
            (at ?r ?loc-hasta)
        )
    )
        
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

    ;; Acciones mecánicas

    (:action aflojar-tuercas
        :parameters (?r - robot ?h - herramienta ?c - coche ?loc - ubicacion)
        :precondition (and
            (at ?r ?loc)
            (at ?c ?loc)
            (holding ?r ?h)
            (coche-en-suelo ?c)
        )
        :effect (and 
            (tuercas-flojas ?c)
        )
    )
    
    (:action levantar-coche
        :parameters (?r - robot ?h - herramienta ?c - coche ?loc - ubicacion)
        :precondition (and 
            (at ?r ?loc)
            (at ?c ?loc)
            (holding ?r ?h)
            (coche-en-suelo ?c)
            (tuercas-flojas ?c)
        )
        :effect (and 
            (not (coche-en-suelo ?c))
            (coche-elevado ?c)
        )
    )
    
    (:action quitar-rueda
        :parameters (?r - robot ?c - coche ?rueda-vieja - rueda ?loc - ubicacion)
        :precondition (and 
            (at ?r ?loc)
            (at ?c ?loc)
            (at ?rueda-vieja ?loc)
            (coche-elevado ?c)
            (tuercas-flojas ?c)
            (libre ?r)
        )
        :effect (and 
            (not (at ?rueda-vieja ?loc))
            (holding ?r ?rueda-vieja)
            (not (libre ?r))
            (rueda-quitada ?c)
        )
    )

    (:action poner-rueda-nueva
        :parameters (?r - robot ?c - coche ?rueda-nueva - rueda ?loc - ubicacion)
        :precondition (and 
            (at ?r ?loc)
            (at ?c ?loc)
            (holding ?r ?rueda-nueva)

        )
        :effect (and 
            (not (holding ?r ?rueda-nueva))
            (libre ?r)
            (rueda-puesta ?c)
        )
    )
    
    
)