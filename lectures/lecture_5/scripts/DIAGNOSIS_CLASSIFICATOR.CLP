
;;;======================================================
;;;   Backward Chaining Program
;;;
;;;     This program was introduced in Section 12.4.
;;;     It tries to select the best color of wine
;;;     to serve with a meal.
;;;
;;;     CLIPS Version 6.0 Example
;;;
;;;     To execute, merely load, reset and run. The
;;;     correct wine color is not printed, but can
;;;     be determined by viewing the facts.
;;;======================================================

(defmodule BC 
   (export deftemplate rule goal attribute))

(deftemplate BC::rule
   (multislot if)
   (multislot then))

(deftemplate BC::attribute 
   (slot name)
   (slot value))

(deftemplate BC::goal 
    (slot attribute)
    (slot final (default false)))

(defrule BC::attempt-rule
  (declare (salience 500))
   (goal (attribute ?g-name))
   (rule (if ?a-name $?)
         (then ?g-name $?))
   (not (attribute (name ?a-name)))
   (not (goal (attribute ?a-name)))
   =>
   (assert (goal (attribute ?a-name))))

(defrule BC::ask-attribute-value
  (declare (salience 50))
   ?goal <- (goal (attribute ?g-name))
   (not (attribute (name ?g-name)))
   (not (rule (then ?g-name $?)))
   =>
   (retract ?goal)
   (printout t "What is the value of " ?g-name "? ")
   (assert (attribute (name ?g-name) 
                      (value (read)))))

(defrule BC::goal-satisfied
   (declare (salience 200))
   ?goal <- (goal (attribute ?g-name) (final false))
   (attribute (name ?g-name))
   =>
   (retract ?goal))

(defrule BC::final-goal-satisfied
   (declare (salience 500))
   ?goal <- (goal (attribute ?g-name) (final true))
   (attribute (name ?g-name) (value ?g-value))
   =>
   (printout t "CONCLUSION: The value of " ?g-name " is " ?g-value crlf)
   (halt))

(defrule BC::rule-satisfied
   (declare (salience 200))
   (goal (attribute ?g-name))
   (attribute (name ?a-name)
              (value ?a-value))
   ?rule <- (rule (if ?a-name is ?a-value) 
                  (then ?g-name is ?g-value))
   =>
   (retract ?rule)
   (assert (attribute (name ?g-name) 
                      (value ?g-value))))

(defrule BC::modify-rule-satisfied
   (declare (salience 200))
   (goal (attribute ?g-name))
   (attribute (name ?a-name)
              (value ?a-value))
   ?rule <- (rule (if ?a-name is ?a-value) 
                  (then ?g-name is ?g-value and $?rest-then))
   =>
   (modify ?rule (then ?rest-then))
   (assert (attribute (name ?g-name) 
                      (value ?g-value))))

(defrule BC::remove-rule-no-match
   (declare (salience 200))
   (goal (attribute ?g-name))
   (attribute (name ?a-name) (value ?a-value))
   ?rule <- (rule (if ?a-name is ~?a-value) 
                  (then ?g-name $?rest))
   =>
   (retract ?rule))

(defrule BC::modify-rule-match
   (declare (salience 200))
   (goal (attribute ?g-name))
   (attribute (name ?a-name) (value ?a-value))
   ?rule <- (rule (if ?a-name is ?a-value and 
                      $?rest-if) 
                  (then ?g-name $?rest))
   =>
   (modify ?rule (if $?rest-if)))

(defmodule MAIN (import BC deftemplate rule goal))

(deffacts MAIN::diagnosis-rules

        (rule (if scleral-icterus is true and
                fever is false and
                pre-gilbert is true)
        (then diagnosis is gilbert-syndrome))

        (rule (if is-stressed is true) (then pre-gilbert is true))
        (rule (if without-food is true) (then pre-gilbert is true))

        (rule (if icterus is true and
                fever is true and
                young is true and
                tired is true and
                dyspepsia is true and
                enlarged-liver is true)
                (then  diagnosis is acute-viral-hepatitis))

        (rule (if icterus is true and 
                fever is true and 
                young is false and 
                recurrent-pain is true and 
                cholecyst-pain is true)
                (then diagnosis is cholecystis))

        (rule (if icterus is true and 
                fever is true and 
                young is false and 
                alcohol-abus is true and 
                enlarged-liver is true and 
                enlarged-spleen is true)
                (then diagnosis is alcoholic-cirrhosis))

        (rule (if yellowish-eyes is true and 
                yellowish-skin is true)
                (then icterus is true and scleral-icterus is false))

        (rule (if yellowish-eyes is true and 
                yellowish-skin is false)
                (then scleral-icterus is true and icterus is false)))


(deffacts MAIN::initial-goal
   (goal (attribute diagnosis) (final true)))

(defrule MAIN::start-BC
   =>
   (focus BC))


