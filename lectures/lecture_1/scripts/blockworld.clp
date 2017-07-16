

(deftemplate goal (slot move) (slot on-top-of))

(deffacts initial-state
(stack A B C )
(stack D E F )
(stack ) ;; why is this useful?
(goal (move C) ( on-top-of F))) ;; why is an explicit fact?

(defrule move-top-to-top
        ?goal <- (goal (move ?block1) (on-top-of ?block2))
        ?stack1 <- (stack ?block1 $?rest1)
        ?stack2 <- (stack ?block2 $?rest2)
        =>
        (retract ?goal ?stack1 ?stack2)
        (assert (stack ?block1 ?block2 ?rest2))
        (assert (stack ?rest1))
        (printout t "Moved " ?block1 " on top of " ?block2 crlf))

(defrule move-top-to-floor
        ?goal <- (goal (move ?block) (on-top-of floor))
        ?stack <- (stack ?block $?rest)
        =>
        (retract ?goal ?stack)
        (assert (stack ?block))
        (assert (stack ?rest))
        (printout t "Moved " ?block " on the floor" crlf))

(defrule clear-block 
        (or
                (goal(move ?block))
                (goal(on-top-of ?block)))
        ?stack <- (stack ?top $?rest1 ?block $?rest2)
        =>
        (retract ?stack)
        (assert (stack ?top))
        (assert (stack ?rest1 ?block ?rest2))
        (printout t "Moved " ?top " on the floor" crlf))
