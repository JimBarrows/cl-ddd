(in-package :cl-ddd)

(defmacro defservice (service-name &key request-fields response-fields body)
  "Defines a service in terms of the request/response fields, a list of validations the request object goes through and finally the guts of the service, which will return a response object"
  (let* ((request-class-name (intern (concatenate 'string (string service-name) "-REQUEST")))
         (response-class-name (intern (concatenate 'string (string service-name) "-RESPONSE"))))
    `(progn (defclass ,request-class-name ()
             ,(mapcar (lambda (slot)
                       (if (atom slot)
                           (list slot
                            :accessor slot
                            :initform :slot)
                           (if (find :accessor slot)
                            slot
                            (append slot (list :accessor (car slot)
                                          :initarg (alexandria:make-keyword (string (car slot))))))))
                request-fields))
      (defclass ,response-class-name ()
        ,(mapcar (lambda (slot)
                  (if (atom slot)
                      (list slot
                       :accessor slot)
                      (if (find :accessor slot)
                       slot
                       (append slot (list :accessor (car slot)
                                     :initarg (alexandria:make-keyword (string (car slot))))))))
           response-fields))
      (defun ,service-name ( ,request-class-name)
        (let ((response (make-instance ',response-class-name)))
         ,@body
         response)))))
