(in-package :cl-ddd-test)
(def-suite entity-test-suite :description "Entity tests")

(in-suite entity-test-suite)

(cl-ddd:defentity test-entity ()
       ((slot1 )
        (slot2 )))

(defmacro with-repository (body)
  `(let ((test-entity-1 (make-instance 'test-entity))
         (*test-entity-repository* (make-instance 'test-entity-repository)))
     ,@body))

(test create-method-is-add-test-entity
  (is-true (find-method #'add-test-entity
			'()
			(mapcar #'find-class '(test-entity-repository test-entity))
			nil)))

(test read-for-existence-method-is-test-entity-exists-?
  (is-true (find-method #'test-entity-exists-?
			'()
			(mapcar #'find-class '(test-entity-repository test-entity))
			nil)))

(test read-by-id-method-is-find-test-entity-by-id
  (is-true (find-method #'find-test-entity-by-id
			'()
			(mapcar #'find-class '(test-entity-repository uuid:uuid))
			nil)))

(test read-all-method-is-find-all-test-entity
  (is-true ( find-method #'find-all-test-entity
			 '()
			 (mapcar #'find-class '(test-entity-repository))
			 nil)))

(test update-entity-method-is-update-test-entity
  (is-true (find-method #'update-test-entity
                        '()
                        (mapcar #'find-class '(test-entity-repository test-entity))
                        nil)))

(test delete-method-is-remove-test-entity
  (is-true (find-method #'remove-test-entity
			'()
			(mapcar #'find-class '(test-entity-repository test-entity))
			nil)))

(test initialize-repository-method-is-initialize-test-entity-repository
  (is-true (find-method #'initialize-test-entity-repository
			'()
			(mapcar #'find-class '(test-entity-repository))
			nil)))

(test can-add-entity-to-repository
      (with-repository
	  ((add-test-entity *test-entity-repository* test-entity-1)
	   (is (= 1 (list-length (find-all-test-entity *test-entity-repository*)))))))


(test can-update-entity-in-repository
      (with-repository ((setf (slot1 test-entity-1) "some value")
                        (update-test-entity *test-entity-repository* test-entity-1)
			(is (string= "some value"
                                     (slot1
                                      (find-test-entity-by-id *test-entity-repository* (cl-ddd::id test-entity-1))))))))

(test can-find-entity-by-id
      (with-repository (
			(add-test-entity *test-entity-repository* test-entity-1)
			(is (uuid= (id test-entity-1)
				   (id (find-test-entity-by-id *test-entity-repository* (id test-entity-1))))))))

(test can-delete-entity-from-repository
      (with-repository ((add-test-entity *test-entity-repository* test-entity-1)
			(add-test-entity *test-entity-repository* (make-instance 'test-entity))
			(remove-test-entity *test-entity-repository* test-entity-1)
			(is (= 1 (list-length (find-all-test-entity *test-entity-repository*)))))))

(test can-return-a-list-of-all-entities
      (with-repository ((add-test-entity *test-entity-repository* test-entity-1)
			(add-test-entity *test-entity-repository* (make-instance 'test-entity))
			(is (= 2 (list-length (find-all-test-entity *test-entity-repository*)))))))

(test can-load-entities-into-repository
      (with-repository ((add-test-entity *test-entity-repository* test-entity-1)
			(add-test-entity *test-entity-repository* (make-instance 'test-entity))
			(shutdown-test-entity-repository *test-entity-repository*)
			(setf (slot-value *test-entity-repository* 'cl-ddd::data) ())
			(initialize-test-entity-repository *test-entity-repository*)
			(is (= 2 (list-length (find-all-test-entity *test-entity-repository*)))))))

(test can-save-entities-from-repository
      (with-repository ((add-test-entity *test-entity-repository* test-entity-1)
			(add-test-entity *test-entity-repository* (make-instance 'test-entity))
			(shutdown-test-entity-repository *test-entity-repository*)
			(is-true (probe-file "test-entity-repository.data"))
			(delete-file (probe-file "test-entity-repository.data")))))

(test can-determine-if-entity-is-in-repo
      (with-repository ((add-test-entity *test-entity-repository* test-entity-1)
			(is-true (test-entity-exists-? *test-entity-repository* test-entity-1 )))))
=======
>>>>>>> entity tests work, except for some file permissions issues writing files to the disk.

(test can-determine-if-entity-is-in-repo
      (with-repository ((add-test-entity repo test-entity-1)
			(is-true (test-entity-exists-? repo test-entity-1 )))))
