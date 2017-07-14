;;;
;; Conceptualizing the same family dag with deftemplated facts

(deftemplate person
  (slot name (type STRING))
  (slot gender (allowed-symbols male female))
  (multislot spouses (type STRING))
  (multislot children (type STRING))
  (slot father (type STRING))
  (slot mother (type STRING))
  (multislot brothers (type STRING))
  (multislot sisters (type STRING))
  (multislot grandparents (type STRING))
  (multislot uncles (type STRING))
  (multislot cousins (type STRING))
  (slot is-orphan (allowed-symbols TRUE FALSE)(default FALSE)))


(deffacts templated-family-dag
  (person (name "Antonio1") (gender male) (children "Nicola" "Rosa"))
  (person (name "Marianna") (gender female) (children "Nicola" "Rosa"))
  (person (name "Nicola") (gender male))
  (person (name "Rosa") (gender female) (children "Giuseppe2" "Antonio2"))
  (person (name "Gennaro") (gender male) (children "Giuseppe2" "Antonio2"))
  (person (name "Giuseppe1") (gender male) (children "Gennaro" "Mario"))
  (person (name "Teresa1") (gender female) (children "Gennaro" "Mario"))
  (person (name "Mario") (gender male) (children "Raffaele" "Teresa2" "Giuseppe3" "Mr X"))
  (person (name "Giuseppina") (gender female) (children "Raffaele" "Teresa2" "Giuseppe3"))
  (person (name "Giuseppe2") (gender male))
  (person (name "Giuseppe3") (gender male))
  (person (name "Antonio2") (gender male))
  (person (name "Teresa2") (gender female))
  (person (name "Raffaele") (gender male))
  (person (name "Mrs Y") (gender female) (children "Mr X"))
  (person (name "Mr X") (gender male))
  )

(defrule find-father
  ?q <- (person (name ?person))
  (person (name ?father) (gender male) (children $?c1 ?person $?c2))
  (not (person (name ?person) (father ?father)))
  =>
  (modify ?q (father ?father)))

(defrule find-mother
  ?q <- (person (name ?person))
  (person (name ?mother) (gender female) (children $?c1 ?person $?c2))
  (not (person (name ?person) (mother ?mother)))
  =>
  (modify ?q (mother ?mother)))

(defrule find-brothers
  ?q <- (person (name ?person) (brothers $?brs))    ;get the list
  (person (name ?parent)(children $?c1 ?person $?c2))     ;find child
  (person (name ?parent)(children $?c3 ?brother $?c4))   ;find a brother from the same parent
  (test(neq ?person ?brother))                         ;check that child and brother are not the same 
  (person (name ?brother) (gender male))              ;check gender
  (not (person (name ?person) (brothers $?brs1 ?brother $?brs2))) ;check that brother is not already in the list
  =>
  (modify ?q (brothers ?brother ?brs)))              ;modify the list to add new brother

(defrule find-sisters
  ?q <- (person (name ?person) (sisters $?srs))    ;get the list
  (person (name ?parent)(children $?c1 ?person $?c2))     ;find child
  (person (name ?parent)(children $?c3 ?sister $?c4))   ;find a brother from the same parent
  (test(neq ?person ?sister))                         ;check that child and brother are not the same 
  (person (name ?sister) (gender female))              ;check gender
  (not (person (name ?person) (sisters $?srs1 ?brother $?srs2))) ;check that brother is not already in the list
  =>
  (modify ?q (sisters ?sister ?srs)))              ;modify the list to add new brother

(defrule find-grandparents
  (or 
    ?q <- (person (name ?person) (father ?parent) (grandparents $?gprts))  
    ?q <- (person (name ?person) (mother ?parent) (grandparents $?gprts)))  ;get the list
  (person (name ?grandparent)(children $?c3 ?parent $?c4)) ;find a parent of parent
  (not (person (name ?person) (grandparents $?gprts1 ?grandparent $?gprts2))) ;check that grandparent is not already in the list
   =>
  (modify ?q (grandparents ?grandparent ?gprts)))              ;modify the list to add new grandparent

(defrule find-spouses
  ?q <- (person (name ?person) (spouses $?sps) (children $?c1 ?child $?c2))
  (person (name ?spouse) (children $?c3 ?child $?c4))
  (test(neq ?person ?spouse))   
  (not (person (name ?person) (spouses $?sps1 ?spouse $?sps2)))
  =>
  (modify ?q (spouses ?spouse ?sps )))

(defrule find-uncles
  (or 
    ?q <- (person (name ?person) (father ?parent) (uncles $?uncs))  
    ?q <- (person (name ?person) (mother ?parent) (uncles $?uncs)))  ;get the list
  (or 
    (person (name ?parent) (brothers $?sbs1 ?uncle $?sbs2))  
    (person (name ?parent) (sisters $?sbs1 ?uncle $?sbs2)))  ;get the list
  (not (person (name ?person) (uncles $?uncs1 ?uncle $?uncs2)))
  (person (name ?uncle) (spouses $?uncle-spouses))
  (not (person (name ?person) (uncles $?uncle-spouses)))
  =>
  (modify ?q (uncles ?uncle ?uncle-spouses ?uncs )))

(defrule find-cousins
  ?q <- (person (name ?person) (uncles $?uncs1 ?uncle $?uncs2) (cousins $?csns))
  (person (name ?uncle) (children $?c1 ?cousin $?c2))
  (not (person (name ?person) (cousins $?csns1 ?cousin $?csns2)))
  =>
  (modify ?q (cousins ?cousin ?csns )))

(defrule is-orphan
  (or 
    ?q <- (person (name ?person) (father "") (is-orphan FALSE))
    ?q <- (person (name ?person) (mother "") (is-orphan FALSE)))
  =>
    (modify ?q (is-orphan TRUE)))

;;; more rules...