;;;
;; Conceptualizing the same family dag with deftemplated facts

(deftemplate person
  (slot name
	(type STRING))
  (slot gender
	(allowed-symbols male female))
  (multislot children
	(type STRING)))

(deffacts templated-family-dag
  (person (name "Antonio1") (gender male) (children "Nicola" "Rosa"))
  (person (name "Marianna") (gender female) (children "Nicola" "Rosa"))
  (person (name "Nicola") (gender male))
  (person (name "Rosa") (gender female) (children "Giuseppe2" "Antonio2"))
  (person (name "Gennaro") (gender male) (children "Giuseppe2" "Antonio2"))
  (person (name "Giuseppe1") (gender male) (children "Gennaro" "Mario"))
  (person (name "Teresa1") (gender female) (children "Gennaro" "Mario"))
  (person (name "Mario") (gender male) (children "Raffaele" "Teresa2" "Giuseppe3"))
  (person (name "Giuseppina") (gender female) (children "Raffaele" "Teresa2" "Giuseppe3"))
  (person (name "Giuseppe2") (gender male))
  (person (name "Giuseppe3") (gender male))
  (person (name "Antonio2") (gender male))
  (person (name "Teresa2") (gender female))
  (person (name "Raffaele") (gender male))
  )


(deftemplate father
  (slot name
	(type STRING))
  (multislot children
	(type STRING)))

(deftemplate mother
  (slot name
	(type STRING))
  (multislot children
	(type STRING)))

(deftemplate parent
  (slot name
	(type STRING))
  (multislot children
	(type STRING)))

(deftemplate brothers
  (slot name
	(type STRING))
  (multislot brother
	(type STRING)))

(deftemplate sisters
  (slot name
  (type STRING))
  (multislot sister
  (type STRING)))

(deftemplate parents
  (slot name (type STRING))
  (slot father (type STRING))
  (slot mother (type STRING)))

(deftemplate grandparents
  (slot name (type STRING))
  (multislot grandparent (type STRING)))



(defrule is-father-of
  "asserting fatherhood"
  (person (name ?father) (gender male) (children ?child1 $?children))
  =>
  (assert (father (name ?father) (children ?child1 ?children))))

(defrule is-mother-of
  "asserting motherhood"
  (person (name ?mother) (gender female) (children ?child1 $?children))
  =>
  (assert (mother (name ?mother) (children ?child1 ?children))))

(defrule is-parent-of
  "asserting parenthood"
  (or
  (mother (name ?parent)(children $?children))
  (father (name ?parent)(children $?children)))
  =>
  (assert (parent (name ?parent) (children ?children))))

(defrule brothers-are
  "asserting first brother of child (list not yet created)"
  (parent (name ?par)(children $?c1 ?child $?c2))     ;find child
  (parent (name ?par)(children $?c3 ?brother $?c4))   ;find a brother from the same parent
  (test(neq ?child ?brother))                         ;check that child and brother are not the same
  (person (name ?brother) (gender male))              ;check gender
  (not (brothers (name ?child) (brother $?brs)))      ;check if there is not a list of brothers already
  =>
  (assert (brothers (name ?child) (brother ?brother)))) ;create list of brothers with first brother

(defrule brothers-are-list
  "asserting other brothers of child (first brother already found and list created)"
  (parent (name ?par)(children $?c1 ?child $?c2))     ;find child
  (parent (name ?par)(children $?c3 ?brother $?c4))   ;find a brother from the same parent
  (test(neq ?child ?brother))                         ;check that child and brother are not the same 
  (person (name ?brother) (gender male))              ;check gender
  (not (brothers (name ?child) (brother $?brs1 ?brother $?brs2))) ;check that brother is not already in the list
  ?list <- (brothers (name ?child) (brother $?brs))    ;get the list
  =>
  (modify ?list (brother ?brother ?brs)))              ;modify the list to add new brother

(defrule sisters-are
  "asserting first sister of child (list not yet created)"
  (parent (name ?par)(children $?c1 ?child $?c2))     ;find child
  (parent (name ?par)(children $?c3 ?sister $?c4))   ;find a sister from the same parent
  (test(neq ?child ?sister))                         ;check that child and sister are not the same
  (person (name ?sister) (gender female))              ;check gender
  (not (sisters (name ?child) (sister $?srs)))      ;check if there is not a list of sisters already
  =>
  (assert (sisters (name ?child) (sister ?sister)))) ;create list of sisters with first sister

(defrule sisters-are-list
  "asserting other sisters of child (first sister already found and list created)"
  (parent (name ?par)(children $?c1 ?child $?c2))     ;find child
  (parent (name ?par)(children $?c3 ?sister $?c4))   ;find a sister from the same parent
  (test(neq ?child ?sister))                         ;check that child and sister are not the same 
  (person (name ?sister) (gender female))              ;check gender
  (not (sisters (name ?child) (sister $?srs1 ?sister $?srs2))) ;check that sister is not already in the list
  ?list <- (sisters (name ?child) (sister $?srs))    ;get the list
  =>
  (modify ?list (sister ?sister ?srs)))              ;modify the list to add new siste

(defrule parents-are
  (father (name ?father) (children $?c1 ?child $?c2))
  (mother (name ?mother) (children $?c3 ?child $?c4))
  =>
  (assert (parents (name ?child) (father ?father) (mother ?mother))))

(defrule grandparents-are
  (father (name ?father) (children $?c1 ?child $?c2))
  (father (name ?gfather1) (children $?c3 ?father $?c4))
  (mother (name ?gmother1) (children $?c5 ?father $?c6))
  (mother (name ?mother) (children $?c7 ?child $?c8))
  (father (name ?gfather2) (children $?c9 ?mother $?c10))
  (mother (name ?gmother2) (children $?c11 ?mother $?c12))
  =>
  (assert (grandparents (name ?child) (grandparent ?gfather1 ?gmother1 ?gfather2 ?gmother2))))



(defrule ret
  (declare (salience -99))
  (or
    ?q <- (father)
    ?q <- (mother)
    ?q <- (parent))
  =>
  (retract ?q))

;;; more rules...