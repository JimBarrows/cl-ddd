(in-package :cl-ddd)

(defentity user()
  ((username :initarg :username
	     :initform (error "username must be provided")
	     :reader username
	     :documentation "username is an email address")
   (password :initarg :password
	     :initform (error "password must be provided")
	     :reader password
	     :documentation "password")))

(defmethod username-exists-p ((user-repo user-repository) username)
  (find-if (lambda (user)
	     (string= username (username user)))
	   (data user-repo)))
