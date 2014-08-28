(in-package :cl-ddd-test)

(def-suite entity-test-suite :description "Entity tests")

(in-suite entity-test-suite)

(cl-ddd::defentity test-entity()
  ((slot1 )
   (slot2 )))

(defmacro with-repository (body)
  `(let ((repo (make-instance 'test-entity-repository))
	 (test-entity-1 (make-instance 'test-entity)))
      ,@body))

(test can-add-entity-to-repository
  (with-repository
      ((add-entity repo test-entity-1)
    (is (= 1 (list-length (list-data repo)))))))

(test can-update-entity-in-repository
  (with-repository ((add-entity repo test-entity-1)
    (setf (slot1 test-entity-1) "some value")
    (is (string= "some value" (slot1 (first (list-data repo))))))))

(test can-find-entity-by-id
 (with-repository (
		   (add-entity repo test-entity-1)
		   (is (uuid= (id test-entity-1) 
			      (id (find-by-id repo (id test-entity-1))))))))

(test can-delete-entity-from-repository
  (with-repository ((add-entity repo test-entity-1)
		    (add-entity repo (make-instance 'test-entity))
		    (remove-entity repo test-entity-1)
		    (is (= 1 (list-length (list-data repo)))))))

(test can-return-a-list-of-all-entities
  (with-repository ((add-entity repo test-entity-1)
		    (add-entity repo (make-instance 'test-entity))
		    (is (= 2 (list-length (list-data repo)))))))

(test can-load-entities-into-repository
  (with-repository ((add-entity repo test-entity-1)
		    (add-entity repo (make-instance 'test-entity))
		    (save-data repo)
		    (setf (slot-value repo 'cl-ddd::data) ())
		    (load-data repo)
		    (is (= 2 (list-length (list-data repo)))))))

(test can-save-entities-from-repository
  (with-repository ((add-entity repo test-entity-1)
		    (add-entity repo (make-instance 'test-entity))
		    (save-data repo)
		    (is-true (probe-file "TEST-ENTITY-REPOSITORY.data"))
		    (delete-file (probe-file "TEST-ENTITY-REPOSITORY.data")))))
		    
(test can-determine-if-entity-is-in-repo
  (with-repository ((add-entity repo test-entity-1)
		    (is-true (entity-exists-? repo test-entity-1 )))))
