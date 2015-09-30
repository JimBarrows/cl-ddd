(in-package :cl-ddd)

(defun entity-ids-equal-? (left right)
  (uuid= (id left) (id right)))

(defun repository-name (entity-name)
  (intern
   (string-upcase
    (concatenate 'string (string entity-name) "-repository"))))

(defun data-file (entity-name)
  (string-downcase
   (concatenate 'string (string entity-name) "-repository.data")))
  
(defmacro defentity (classname superclasses slots &rest options)
  (let* (
	 (repo-name 
	  (repository-name classname))
	 (add-entity-method-name
	  (intern
	   (string-upcase
	    (concatenate 'string "add-" (string classname)))))
	 (remove-entity-method-name
	  (intern
	   (string-upcase
	    (concatenate 'string "remove-" (string classname)))))
	 (entity-exists-method-name
	  (intern
	   (string-upcase
	    (concatenate 'string (string classname) "-exists-?"))))
	 (find-by-id-method-name
	  (intern
	   (string-upcase
	    (concatenate 'string "find-" (string classname) "-by-id"))))
	 (repo-file-name 
	  (data-file classname)))
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
       (defmethod ,entity-exists-method-name ((repo ,repo-name) (entity ,classname))
	 (member entity (data repo) :test #'entity-ids-equal-?))
       (defmethod ,find-by-id-method-name ((repo ,repo-name) (id-to-find uuid))
	 (find-if (lambda (item)
		    (uuid:uuid= id-to-find (id item)))
		  (data repo)))
       (defmethod list-data((repo ,repo-name))
	 (data repo))
       (defmethod load-data ((repo ,repo-name))
	 (when (probe-file ,repo-file-name)
	   (setf (slot-value repo 'data) (restore ,repo-file-name))))
       (defmethod save-data((repo ,repo-name))
	 (store (slot-value repo 'data) ,repo-file-name)))))


