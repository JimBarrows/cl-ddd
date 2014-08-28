(asdf:defsystem #:cl-ddd
    :serial t
    :depends-on (#:cl-store
		 #:uuid)
    :components (
		 (:file "package")
		 (:file "types")
		 (:file "entity")
		 (:file "authentication-entities")
		 (:file "authentication-services")
		 (:file "authentication-json-endpoint")))

(asdf:defsystem #:cl-ddd-test
    :serial t
    :depends-on (:fiveam
		 :cl-store)
    :components ((:file "test/package")
		 (:file "test/entity-test")))
