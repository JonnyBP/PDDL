(define (domain taller-mecanico-completo)
    (:requirements :strips :typing)

    (:types
        ubicacion locatable - object
        robot mecanico coche portatil - locatable
        herramienta rueda - portatil
        llave gato - herramienta
    )

    (:predicates
        (at ?obj - locatable ?loc - ubicacion)
        (holding ?r - robot ?item - portatil)
        (libre ?r - robot)

        (montada ?w - rueda ?c - coche)
        (coche-en-suelo ?c - coche)
        (coche-elevado ?c - coche)
        (tuercas-apretadas ?c - coche)
        (tuercas-aflojadas ?c - coche)
        (hueco-libre ?c - coche)        ; no hay rueda montada
    )

    (:action mover-robot
        :parameters (?r - robot ?desde ?hasta - ubicacion)
        :precondition (at ?r ?desde)
        :effect (and (not (at ?r ?desde)) (at ?r ?hasta))
    )

    (:action recoger
        :parameters (?r - robot ?item - portatil ?loc - ubicacion)
        :precondition (and (at ?r ?loc) (at ?item ?loc) (libre ?r))
        :effect (and (not (at ?item ?loc)) (holding ?r ?item) (not (libre ?r)))
    )

    (:action soltar
        :parameters (?r - robot ?item - portatil ?loc - ubicacion)
        :precondition (and (at ?r ?loc) (holding ?r ?item))
        :effect (and (not (holding ?r ?item)) (at ?item ?loc) (libre ?r))
    )

    (:action aflojar-tuercas
        :parameters (?r - robot ?l - llave ?c - coche ?loc - ubicacion)
        :precondition (and (at ?r ?loc) (at ?c ?loc) (holding ?r ?l)
                            (coche-en-suelo ?c) (tuercas-apretadas ?c))
        :effect (and (not (tuercas-apretadas ?c)) (tuercas-aflojadas ?c))
    )

    (:action levantar-coche
        :parameters (?r - robot ?g - gato ?c - coche ?loc - ubicacion)
        :precondition (and (at ?r ?loc) (at ?c ?loc) (holding ?r ?g)
                            (coche-en-suelo ?c) (tuercas-aflojadas ?c))
        :effect (and (not (coche-en-suelo ?c)) (coche-elevado ?c))
    )

    (:action quitar-rueda
        :parameters (?r - robot ?w - rueda ?c - coche ?loc - ubicacion)
        :precondition (and (at ?r ?loc) (at ?c ?loc) (libre ?r)
                            (montada ?w ?c) (coche-elevado ?c) (tuercas-aflojadas ?c))
        :effect (and (not (montada ?w ?c)) (hueco-libre ?c)
                    (holding ?r ?w) (not (libre ?r)))
    )

    (:action montar-rueda
        :parameters (?r - robot ?w - rueda ?c - coche ?loc - ubicacion)
        :precondition (and (at ?r ?loc) (at ?c ?loc) (holding ?r ?w)
                            (hueco-libre ?c) (coche-elevado ?c))
        :effect (and (not (hueco-libre ?c)) (montada ?w ?c)
                    (not (holding ?r ?w)) (libre ?r))
    )

    (:action bajar-coche
        :parameters (?r - robot ?g - gato ?c - coche ?loc - ubicacion)
        :precondition (and (at ?r ?loc) (at ?c ?loc) (holding ?r ?g)
                            (coche-elevado ?c))
        :effect (and (not (coche-elevado ?c)) (coche-en-suelo ?c))
    )

    (:action apretar-tuercas
        :parameters (?r - robot ?l - llave ?w - rueda ?c - coche ?loc - ubicacion)
        :precondition (and (at ?r ?loc) (at ?c ?loc) (holding ?r ?l)
                            (montada ?w ?c) (coche-en-suelo ?c) (tuercas-aflojadas ?c))
        :effect (and (not (tuercas-aflojadas ?c)) (tuercas-apretadas ?c))
    )
)