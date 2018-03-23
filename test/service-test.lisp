(in-package :cl-ddd-test)

(def-suite service-test-suite :description "Testing the functionalit of defining a service")

(in-suite service-test-suite)

(defmacro with-service(body)
  `(progn
     (defservice test-service
      :request-fields ((field1)
                       (field2))
      :response-fields ((field3)
                        (field4))
      :body ((setf (field3 cl-ddd::response) (field1 test-service-request))
             (setf (field4 cl-ddd::response) (field2 test-service-request))))
     ,@body))

(test service-macro-creates-request-class
  (with-service
      ((finishes (make-instance 'test-service-request :field1 "hello" :field2 "goodby")))))

(test serivce-macro-creates-response-class
  (with-service
      ((finishes (make-instance 'test-service-response :field3 "hello" :field4 "goodby")))))

(test service-macro-calls-body-code
  (with-service
      ((let ((service-response (test-service (make-instance 'test-service-request :field1 "hello"
                                              :field2 "goodbye"))))
        (is (and (string= (field3 service-response) "hello")
             (string= (field4 service-response) "goodbye")))))))
