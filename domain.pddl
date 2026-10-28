(define (domain taller-mecanico-completo)
    (:requirements :strips :typing)
    
    (:types
        ubicacion - object
        locatable - object
        robot mecanico coche - locatable
        portatil - locatable
        herramienta rueda - portatil
    )
    
    (:predicates
        (at ?obj - locatable ?loc - ubicacion)
        (holding ?r - robot ?item - locatable)
        (libre ?r - robot)

        (coche-en-suelo ?c - coche)
        (coche-elevado ?c - coche)
        (tuercas-aflojadas ?c - coche)
        (rueda-quitada ?c - coche)
        (rueda-puesta ?c - coche)
    )

    ;; acciones de movimiento y manipulacion
    (:action mover-robot
        :parameters (?r - robot ?loc-desde - ubicacion ?loc-hasta - ubicacion)
        :precondition (and (at ?r ?loc-desde) )
        :effect (and 
            (not (at ?r ?loc-desde))
            (at ?r ?loc-hasta)
        )
    )
        
    (:action recoger 
        :parameters (?r - robot ?item - portatil ?loc - ubicacion) 
        :precondition (and (at ?r ?loc) (at ?item ?loc) (libre ?r)) 
        :effect (and 
            (not (at ?item ?loc)) 
            (holding ?r ?item) 
            (not (libre ?r))
        ) 
    )
    
    (:action soltar
        :parameters (?r - robot ?item - portatil ?loc - ubicacion)
        :precondition (and (at ?r ?loc) (holding ?r ?item))
        :effect (and
            (not (holding ?r ?item))
            (at ?item ?loc)
            (libre ?r)    
        )
    )

    ;; Acciones mecanicas

    (:action aflojar-tuercas
        :parameters (?r - robot ?llave - herramienta ?c - coche ?loc - ubicacion)
        :precondition (and
            (at ?r ?loc)
            (at ?c ?loc)
            (holding ?r ?llave)
            (coche-en-suelo ?c)
        )
        :effect (and 
            (tuercas-aflojadas ?c)
        )
    )
    
    (:action levantar-coche
        :parameters (?r - robot ?gato - herramienta ?c - coche ?loc - ubicacion)
        :precondition (and 
            (at ?r ?loc)
            (at ?c ?loc)
            (holding ?r ?gato)
            (coche-en-suelo ?c)
            (tuercas-aflojadas ?c)
        )
        :effect (and 
            (not (coche-en-suelo ?c))
            (coche-elevado ?c)
        )
    )
    
    (:action quitar-rueda-vieja
        :parameters (?r - robot ?c - coche ?rueda-vieja - rueda ?loc - ubicacion)
        :precondition (and 
            (at ?r ?loc)
            (at ?c ?loc)
            (at ?rueda-vieja ?loc)
            (coche-elevado ?c)
            (tuercas-aflojadas ?c)
            (libre ?r)
        )
        :effect (and
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
            (coche-elevado ?c)
            (rueda-quitada ?c)

        )
        :effect (and 
            (not (holding ?r ?rueda-nueva))
            (libre ?r)
            (rueda-puesta ?c)
        )
    )
    
    
)