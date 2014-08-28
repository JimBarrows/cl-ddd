(asdf:defsystem #:cl-ddd
    :serial t
    :depends-on (#:hunchentoot
		 #:restas
		 #:parenscript
		 #:cl-json
		 #:cl-store
		 #:uuid)
    :components (
		 (:file "package")
		 (:file "configuration")
		 (:file "types")
		 (:file "entity")
		 (:file "authentication-entities")
		 (:file "authentication-services")
		 (:file "authentication-json-endpoint")
		 (:file "bootstrap")))
