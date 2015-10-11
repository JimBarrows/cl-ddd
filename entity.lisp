(in-package :cl-ddd)

(defun entity-ids-equal-? (left right)
  (uuid= (id left) (id right)))

(defun repository-name (entity-name)
  (intern
   (string-upcase
    (concatenate 'string (string entity-name) "-repository"))))

(defun repository-var (entity-name)
  (intern
   (string-upcase
    (concatenate 'string "*" (string (repository-name entity-name)) "*"))))

(defun data-file (entity-name)
  (string-downcase
   (concatenate 'string (string entity-name) "-repository.data")))

(defun add-entity-method (entity-name)
  (intern
   (string-upcase
    (concatenate 'string "add-" (string entity-name)))))

(defun update-entity-method (entity-name)
  (intern
   (string-upcase
    (concatenate 'string "update-" (string entity-name)))))

(defun remove-entity-method( entity-name)
  (intern
   (string-upcase
    (concatenate 'string "remove-" (string entity-name)))))

(defun entity-exists-method( entity-name)
  (intern
   (string-upcase
    (concatenate 'string (string entity-name) "-exists-?"))))

(defun find-by-id-method( entity-name)
  (intern
   (string-upcase
    (concatenate 'string "find-" (string entity-name) "-by-id"))))

(defun find-all-method( entity-name)
  (intern
   (string-upcase
    (concatenate 'string "find-all-" (string entity-name)))))

(defun initialize-repository-method( entity-name)
  (intern
   (string-upcase
    (concatenate 'string "initialize-" (string entity-name) "-repository"))))

(defun shutdown-repository-method( entity-name)
  (intern
   (string-upcase
    (concatenate 'string "shutdown-" (string entity-name) "-repository"))))

(defmacro defentity (classname superclasses slots &rest options)
  (let* ((repo-name (repository-name classname))
	 (add-entity-method-name (add-entity-method classname))
         (update-entity-method-name (update-entity-method classname))
	 (remove-entity-method-name (remove-entity-method classname))
	 (entity-exists-method-name (entity-exists-method classname))
	 (find-by-id-method-name (find-by-id-method classname))
	 (repo-file-name (data-file classname))
         (find-all-method-name (find-all-method classname))
         (initialize-repository-method-name (initialize-repository-method classname))
         (shutdown-repository-method-name (shutdown-repository-method classname))
         (repository-var-name (repository-var classname)))
    (push '(id :initform (uuid::make-v4-uuid) :initarg :id :accessor id) slots)
    `(progn 
       (defclass ,classname ,superclasses
	 ,(mapcar (lambda (slot)
		    (if (atom slot)
			(list slot
			      :accessor slot)
			(if (find :accessor slot)
			    slot
			    (append slot (list :accessor (car slot))))))
		  slots)
	 ,@options)
       (defclass ,repo-name ,() ,(list
				  '( data :initform '() :reader data)
				  `( storage-name :initform ,repo-file-name)))
       (defmethod ,add-entity-method-name ((repo ,repo-name) (entity ,classname))
	 (push entity (slot-value repo 'data)))
       (defmethod ,remove-entity-method-name ((repo ,repo-name) (entity ,classname))
	 (delete entity (data repo) 
		 :test #'entity-ids-equal-?))
       (defmethod ,update-entity-method-name ((repo ,repo-name) (entity ,classname))
	 (,remove-entity-method-name repo (,find-by-id-method-name repo (id entity)))
         (,add-entity-method-name repo entity))
       (defmethod ,entity-exists-method-name ((repo ,repo-name) (entity ,classname))
	 (member entity (data repo) :test #'entity-ids-equal-?))
       (defmethod ,find-by-id-method-name ((repo ,repo-name) (id-to-find uuid))
	 (find-if (lambda (item)
		    (uuid:uuid= id-to-find (id item)))
		  (data repo)))
       (defmethod ,find-all-method-name ((repo ,repo-name))
	 (data repo))
       (defmethod ,initialize-repository-method-name ((repo ,repo-name))
	 (when (probe-file ,repo-file-name)
	   (setf (slot-value repo 'data) (restore ,repo-file-name))))
       (defmethod ,shutdown-repository-method-name ((repo ,repo-name))
	 (store (slot-value repo 'data) ,repo-file-name))
       (defparameter ,repository-var-name (make-instance ',repo-name))
       (export ',classname)
       (export ',repo-name)
       (export ',add-entity-method-name)
       (export ',update-entity-method-name
       (export ',remove-entity-method-name)
       (export ',entity-exists-method-name)
       (export ',find-by-id-method-name )
       (export ',find-all-method-name)
       (export ',initialize-repository-method-name)
       (export ',shutdown-repository-method-name )
       (export ',repository-var-name)))))


