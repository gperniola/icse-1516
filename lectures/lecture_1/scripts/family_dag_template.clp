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
  (person (name "tony") (gender male))
  (person (name "julian") (gender male) (children "tony" "rose"))
  (person (name "john") (gender male) (children "julian" "frank"))
  (person (name "johna") (gender male) (children "mary"))
  (person (name "frank") (gender male) (children "anna"))
  (person (name "rose") (gender female))
  (person (name "laura") (gender female) (children "tony" "rose"))
  (person (name "jenny") (gender female) (children "julian" "frank"))
  (person (name "anna") (gender female))
  (person (name "mary") (gender female) (children "anna")))

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

(deftemplate brother
  (slot name
	(type STRING))
  (multislot siblings
	(type STRING)))



(defrule is-father
  "asserting fatherhood"
  (person (name ?father) (gender male) (children $?children))
  =>
  (assert (father (name ?father) (children $?children))))

(defrule is-mother
  "asserting motherhood"
  (person (name ?mother) (gender female) (children $?children))
  =>
  (assert (mother (name ?mother) (children $?children))))

(defrule is-parent
  "asserting parenthood"
  (or
  (mother (name ?parent)(children $?children))
  (father (name ?parent)(children $?children)))
  =>
  (assert (parent (name ?parent) (children $?children))))



;;; more rules...