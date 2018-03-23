(in-package :cl-ddd-test)

(in-suite api-test-suite)

(defvar *app* ())
(defvar *handler* ())

(defmacro with-harness (body)
  `(progn
     (setf *app* (make-instance 'ningle:<app>))
     (setf *test-entity-repository* (make-instance 'test-entity-repository))
     (setf *handler* (clack:clackup *app*))
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

(test post-request-to-the-base-url-add-an-entity-to-the-repository
  (with-harness
      ((let* ((response (drakma:http-request "http://localhost:5000/api/test-entity"
                                             :method :post
                                             :parameters '(("slot1" . "test-2-slot1")
                                                           ("slot2" . "test-2-slot2"))))
              (json (cl-json:decode-json-from-string response))
              (saved-entity (car (find-all-test-entity *test-entity-repository*))))
         (format t "###########response: ~A" response)
         (is-false (null saved-entity))
         (is-true (uuid= (id saved-entity) (make-uuid-from-string (cdr (assoc :id json)))))
         (is (string= (slot1 saved-entity) "test-2-slot1"))
         (is (string= (slot2 saved-entity) "test-2-slot1"))))))
