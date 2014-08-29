(in-package :cl-ddd-test)

(def-suite service-test-suite :description "Testing the functionalit of defining a service")

(in-suite service-test-suite)

(defmacro with-service(body)
  `(let((service (defservice( test-service 
			      :request-fields ((field1)
					       (field2))
			      :response-fields ((field3)
					       (field4))
			      :validations ((:field1 '(lambda( field1) (not nil-p field1)))
					    (:field2 '(lambda( field2) (not nil-p field2)))
					    (:request '(lambda( request) ( not nil-p request))))
			      :body (lambda (field1 field2 response) ((setf (field3 response) field1)
								      (setf (field4 response) field2)
								      response))))))
    ,@body))

(test service-macro-creates-request-class
  (skip "Not create yet"))

(test serivce-macro-creates-response-class
  (skip "Not created yet"))

(test service-macro-validates-request-object
  (skip "not created yet"))

(test service-macro-calls-body-code
  (skip "not create yet"))
