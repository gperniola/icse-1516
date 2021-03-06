;;;;;
;; A very simple conceptualization of a family directed acyclic graph

(deffacts family-dag
        ;; parent
	(parent julian tony)
	(parent julian rose)
	(parent laura tony)
	(parent laura rose)
	(parent john julian)
	(parent john frank)
	(parent jenny julian)
	(parent jenny frank)
	(parent frank anna)
	(parent mary anna)
	(parent johna mary)
	;; male
	(male tony)
	(male julian)
	(male john)
	(male johna)
	(male frank)
	;; female
	(female rose)
	(female laura)
	(female jenny)
	(female anna)
	(female mary))


(defrule fatherhood
  "match-and-assert all father-child relationships"
  (male ?father)
  (parent ?father ?child)
  =>
  (assert (father ?father ?child)))

(defrule brother
  "matching brother relationships"
  (male ?brother)
  (parent ?parent ?child)
  (parent ?parent ?brother)
  (test (neq ?brother ?child))
  =>
  (assert (brother ?brother ?child)))

(defrule sister
  "matching sister relationships"
  (female ?sister)
  (parent ?parent ?child)
  (parent ?parent ?sister)
  (test (neq ?sister ?child))
  =>
  (assert (sister ?sister ?child)))

(defrule motherhood
  "match-and-assert all mother-child relationships"
  (female ?mother)
  (parent ?mother ?child)
  =>
  (assert (mother ?mother ?child)))

(defrule is-father
  "match-and-assert all fathers' names"
  (male ?father)
  (parent ?father ?child)
  =>
  (assert (is-father ?father)))


(defrule married
  (father ?husband ?child)
  (mother ?wife ?child)
  =>
  (assert(married ?husband ?wife)))

(defrule grandparent
  "match-and-assert all grand parent relationships"
  (parent ?grandparent ?parent)
  (parent ?parent ?child)
  =>
  (assert (grandparent ?grandparent ?child)))

(defrule grandfather
  "match-and-assert all grandfathers relationships"
  (grandparent ?gp ?child)
  (male ?gp)
  =>
  (assert (grandfather ?gp ?child)))

(defrule grandmother
  "match-and-assert all grandmothers relationships"
  (grandparent ?gp ?child)
  (female ?gp)
  =>
  (assert (grandmother ?gp ?child)))

(defrule uncle
  (brother ?uncle ?parent)
  (parent ?parent ?child)
  =>
  (assert(uncle ?uncle ?child)))

(defrule aunt
  (sister ?aunt ?parent)
  (parent ?parent ?child)
  =>
  (assert(aunt ?aunt ?child)))

(defrule uncle-married
  (aunt ?aunt ?child)
  (married ?uncle ?aunt)
  =>
  (assert(uncle ?uncle ?child)))

(defrule aunt-married
  (uncle ?uncle ?child)
  (married ?uncle ?aunt)
  =>
  (assert(aunt ?aunt ?child)))

(defrule cousins
  (or
    (uncle ?uncle ?child)
    (aunt ?uncle ?child))
  (parent ?uncle ?cousin)
  =>
  (assert(cousins ?cousin ?child)))

(defrule orphan
  (parent ?child ?subchild)
  (not (father ?f ?child))
  (not (mother ?m ?child))
  =>
  (assert(orphan ?child)))
