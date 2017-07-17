(deffunction ask-question (?question $?allowed-values)
     (printout t ?question)
     (bind ?answer (read))
     (if (lexemep ?answer) ;; TRUE is ?answer is a STRING or SYMBOL
            then (bind ?answer (lowcase ?answer)))
     (while (not (member ?answer ?allowed-values)) do
               (printout t ?question)
               (bind ?answer (read))
               (if (lexemep ?answer) 
                   then (bind ?answer (lowcase ?answer))))
     ?answer)

(deffunction yes-or-no-p (?question)
  (bind ?question (sym-cat ?question " (yes/y/no/n): "))
     (bind ?response (ask-question ?question yes no y n))
     (if (or (eq ?response yes) (eq ?response y))
         then TRUE 
         else FALSE))


(defrule ask-yellow-eyes
        (not (symptom yellow-eyes ?))
        =>
        (bind ?value (yes-or-no-p "Has the patient got yellowish eyes?"))
        (assert(symptom yellow-eyes ?value)))

(defrule ask-yellow-skin
        (not (symptom yellow-skin ?))
        =>
        (bind ?value (yes-or-no-p "Has the patient got yellowish skin?"))
        (assert(symptom yellow-skin ?value)))

(defrule ask-fever
        (not (symptom fever ?))
        =>
        (bind ?value (yes-or-no-p "Has the patient got fever?"))
        (assert(symptom fever ?value)))

(defrule ask-stressed
        (not (symptom stressed ?))
        =>
        (bind ?value (yes-or-no-p "Is the patient stressed?"))
        (assert(symptom stressed ?value)))

(defrule ask-starving
        (not (symptom starving ?))
        =>
        (bind ?value (yes-or-no-p "Is the patient starving?"))
        (assert(symptom starving ?value)))

(defrule ask-patient-age
        (not (patient-age ?))
        =>
        (bind ?value (ask-question "Age of patient?" young adult old))
        (assert(patient-age ?value)))

(defrule ask-tired
        (not (symptom tired ?))
        =>
        (bind ?value (yes-or-no-p "Is the patient tired?"))
        (assert(symptom tired ?value)))

(defrule ask-enlarged-liver
        (not (symptom enlarged-liver ?))
        =>
        (bind ?value (yes-or-no-p "Has the patient got an enlarged liver?"))
        (assert(symptom enlarged-liver ?value)))

(defrule ask-enlarged-spleen
        (not (symptom enlarged-spleen ?))
        =>
        (bind ?value (yes-or-no-p "Has the patient got an enlarged spleen?"))
        (assert(symptom enlarged-spleen ?value)))

(defrule ask-dyspepsia
        (not (partial-diagnosis dyspepsia ?))
        =>
        (bind ?value (yes-or-no-p "Has the patient got dyspepsia?"))
        (assert(partial-diagnosis dyspepsia ?value)))

(defrule ask-cholecyst-pains
        (not (symptom cholecyst-pains ?))
        =>
        (bind ?value (yes-or-no-p "Has the patient got cholecyst pains?"))
        (assert(symptom cholecyst-pains ?value)))

(defrule ask-recurrent-pains
        (not (symptom recurrent-pains ?))
        =>
        (bind ?value (yes-or-no-p "Has the patient got recurrent pains?"))
        (assert(symptom recurrent-pains ?value)))

(defrule ask-abuses-alchool
        (not (symptom abuses-alchool ?))
        =>
        (bind ?value (yes-or-no-p "Do the patient abuses alchool?"))
        (assert(symptom abuses-alchool ?value)))



(defrule icterus
        (declare (salience 100))
        (symptom yellow-eyes TRUE)
        (symptom yellow-skin TRUE)
        =>
        (assert(partial-diagnosis icterus TRUE)))

(defrule scleral-icterus
        (declare (salience 100))
        (symptom yellow-eyes TRUE)
        (symptom yellow-skin FALSE)
        =>
        (assert(partial-diagnosis scleral-icterus TRUE)))

(defrule gilbert-syndrome
        (declare (salience 1000))
        (partial-diagnosis scleral-icterus TRUE)
        (symptom fever FALSE)
        (or
                (symptom stressed TRUE)
                (symptom starving TRUE))
        =>
        (assert(full-diagnosis gilbert-syndrome TRUE)))

(defrule acute-viral-hepatitis
        (declare (salience 1000))
        (partial-diagnosis icterus TRUE)
        (symptom fever TRUE)
        (patient-age young)
        (symptom tired TRUE)
        (symptom enlarged-liver TRUE)
        (partial-diagnosis dyspepsia TRUE)
        =>
        (assert(full-diagnosis acute-viral-hepatitis TRUE)))

(defrule cholecystitis
        (declare (salience 1000))
        (partial-diagnosis icterus TRUE)
        (symptom fever TRUE)
        (not (patient-age young))
        (symptom cholecyst-pains TRUE)
        (symptom recurrent-pains TRUE)
        =>
        (assert(full-diagnosis cholecystitis TRUE)))

(defrule alchoolic-cirrhosis
        (declare (salience 1000))
        (partial-diagnosis icterus TRUE)
        (symptom fever FALSE)
        (not (patient-age young))
        (symptom abuses-alchool TRUE)
        (symptom enlarged-spleen TRUE)
        (symptom enlarged-liver TRUE)
        =>
        (assert(full-diagnosis alchoolic-cirrhosis TRUE)))

(defrule print-diagnosis
        (declare (salience 10000))
        (full-diagnosis ?diagnosis TRUE)
        =>
        (printout t "The patient has got " ?diagnosis crlf)
        (halt))