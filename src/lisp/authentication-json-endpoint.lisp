(in-package :cl-ddd)

;(map-routes
; ("/users" :post users-post ))

;(defun users-post()
;  """Handle post to the /users url"""
;  (let* ((input-string (hunchentoot::raw-post-data :force-text t))
;	 (input-json (rest (first (decode-json-from-string input-string))))
;	 (name (string-trim " " (rest (assoc :username input-json))))
;	 (password (string-trim " " (rest (assoc :password input-json)))))	 
;    (setf (content-type*) "application/json") 
;    (let (add-user-result (add-user name password))
;      (if (typep add-user-result 'user)
;	  (format nil "{\"user\":~a}" (json:encode-json-to-string new-user))
;	  (progn
;	    (setf (return-code*) 422)
;	    (format nil "{\"errors\":~a}" add-user-result))))))
