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

(test add-method-is-add-test-entity
  (is-true (find-method #'add-test-entity
			'()
			(mapcar #'find-class '(test-entity-repository test-entity))
			nil)))

(test remove-method-is-remove-test-entity
  (is-true (find-method #'remove-test-entity
			'()
			(mapcar #'find-class '(test-entity-repository test-entity))
			nil)))

(test entity-exists-method-is-test-entity-exists-?
  (is-true (find-method #'test-entity-exists-?
			'()
			(mapcar #'find-class '(test-entity-repository test-entity))
			nil)))

(test find-by-id-method-is-find-test-entity-by-id
  (is-true (find-method #'find-test-entity-by-id
			'()
			(mapcar #'find-class '(test-entity-repository uuid))
			nil)))

(test list-data-method-is-list-test-entity
  (is-true ( find-method #'list-test-entity
			 '()
			 (mapcar #'find-class '(test-entity-repository test-entity))
			 nil)))

(test load-data-method-is-load-test-entity-data
  (is-true (find-method #'load-test-entity-data
			'()
			(mapcar #'find-class '(test-entity-repository test-entity))
			nil)))

(test save-data-method-is-save-test-entity-data
  (is-true (find-emthod #'save-test-entity-data
			'()
			(mapcar #'find-class '(test-entity-repository test-entity))
			nil)))

(test can-add-entity-to-repository
      (with-repository
	  ((add-test-entity repo test-entity-1)
	   (is (= 1 (list-length (list-test-entity-data repo)))))))


(test can-update-entity-in-repository
      (with-repository ((add-entity repo test-entity-1)
			(setf (slot1 test-entity-1) "some value")
			(is (string= "some value" (slot1 (first (list-test-entity-data repo))))))))

(test can-find-entity-by-id
      (with-repository (
			(add-test-entity repo test-entity-1)
			(is (uuid= (id test-entity-1) 
				   (id (find-test-entity-by-id repo (id test-entity-1))))))))

(test can-delete-entity-from-repository
      (with-repository ((add-test-entity repo test-entity-1)
			(add-test-entity repo (make-instance 'test-entity))
			(remove-test-entity repo test-entity-1)
			(is (= 1 (list-length (list-test-entity-data repo)))))))

(test can-return-a-list-of-all-entities
      (with-repository ((add-test-entity repo test-entity-1)
			(add-test-entity repo (make-instance 'test-entity))
			(is (= 2 (list-length (list-test-entity-data repo)))))))

(test can-load-entities-into-repository
      (with-repository ((add-test-entity repo test-entity-1)
			(add-test-entity repo (make-instance 'test-entity))
			(save-data repo)
			(setf (slot-value repo 'cl-ddd::data) ())
			(load-data repo)
			(is (= 2 (list-length (list-test-entity-data repo)))))))

(test can-save-entities-from-repository
      (with-repository ((add-test-entity repo test-entity-1)
			(add-test-entity repo (make-instance 'test-entity))
			(save-data repo)
			(is-true (probe-file "TEST-ENTITY-REPOSITORY.data"))
			(delete-file (probe-file "TEST-ENTITY-REPOSITORY.data")))))
		    
(test can-determine-if-entity-is-in-repo
      (with-repository ((add-test-entity repo test-entity-1)
			(is-true (test-entity-exists-? repo test-entity-1 )))))

