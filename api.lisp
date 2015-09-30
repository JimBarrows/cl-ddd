(in-package :cl-ddd)

(defmacro defentityapi (entity)
  (let* ((dto-name (intern (concatenate 'string (string entity-name) "-DTO")))
	 (repository-name (intern (concatenate 'string (string entity-name) "-REPOSITORY")))
	 (repository-add (intern (concatenate 'string "ADD-" (string entity-name)))))))