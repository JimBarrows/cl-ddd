(in-package :cl-ddd)

(defmethod encode-json((u uuid::uuid) 
                       &optional (stream cl-json:*json-output*)) 
  "encode a uuid class as a string, so we get the actual number"
  (write-char #\" stream)
  (uuid::print-object u stream)
  (write-char #\" stream))

(defmacro defentityapi (entity)
  (let* ((repository-var-name (cl-ddd::repository-var entity))
         (repository-find-all (find-all-method entity))
         (base-url (string-downcase (concatenate 'string "/api/" (string entity)))))
    `(progn
       (setf (ningle:route cl::*app* ,base-url :method :GET) 
             (lambda (params) 
               (cl-json:encode-json-to-string (,repository-find-all ,repository-var-name)))))))