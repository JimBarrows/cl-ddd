(in-package :cl-ddd-test)

(in-suite api-test-suite)

(defvar common-lisp::*app* () )
(defvar *handler* ())

(defmacro with-harness (body)
  `(progn
     (setf common-lisp::*app* (make-instance 'ningle:<app>))
     (setf *test-entity-repository* (make-instance 'test-entity-repository))
     (setf *handler* (clack:clackup common-lisp::*app*))
     (cl-ddd:defentityapi test-entity)
     ,@body
     (clack:stop *handler*)))
     
(test get-request-to-the-base-url-returns-a-list-of-entities
  (with-harness
     ((let* ((test-entity-1 (make-instance 'test-entity)))
        (setf (slot1 test-entity-1) "test-1-slot1")
        (setf (slot2 test-entity-1) "test-1-slot2")
        (cl-ddd-test::add-test-entity *test-entity-repository* test-entity-1)
        (is-true (uuid= (id test-entity-1) 
                   (make-uuid-from-string 
                    (cdr 
                     (assoc :id 
                            (car 
                             (cl-json:decode-json-from-string 
                              (drakma:http-request "http://localhost:5000/api/test-entity"))))))))))))
     