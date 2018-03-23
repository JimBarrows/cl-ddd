(in-package :cl-ddd)

(defmethod encode-json((u uuid::uuid)
                       &optional (stream cl-json:*json-output*))
  "encode a uuid class as a string, so we get the actual number"
  (write-char #\" stream)
  (uuid::print-object u stream)
  (write-char #\" stream))

(defmacro def-get-entities (entity)
  (let* ((repository-var-name (cl-ddd::repository-var entity))
         (repository-find-all (find-all-method entity))
         (base-url (string-downcase (concatenate 'string "/api/" (string entity)))))
    `(setf (ningle:route *app* ,base-url :method :GET)
          (lambda (params)
            (cl-json:encode-json-to-string (,repository-find-all ,repository-var-name))))))

(defmacro def-post-entity (entity)
  (let* ((repository-var-name (cl-ddd::repository-var entity))
         (base-url (string-downcase (concatenate 'string "/api/" (string entity))))
         (progn-statement '(progn)))

    `(setf (ningle:route *app* ,base-url :method :post)
           (lambda (params)
             ,(append `(let ((new-entity (make-instance ',entity))))
                     (loop
                       for slot in (cl-user:class-slots (find-class entity))
                       collect `(setf (,(cl:slot-definition-name slot) new-entity)
                                      (cdr (assoc ,(string (cl:slot-definition-name slot)) params :test #'string=))))
                     `((,(add-entity-method entity) ,repository-var-name new-entity)))))))

(defmacro defentityapi (entity)
  `(def-post-entity  ,entity))
