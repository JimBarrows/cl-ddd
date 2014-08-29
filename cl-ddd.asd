(asdf:defsystem #:cl-ddd
    :serial t
    :depends-on (#:cl-store
		 #:uuid
		 #:alexandria)
    :components ((:file "package")
		 (:file "types")
		 (:file "entity")
		 (:file "constants")))

(asdf:defsystem #:cl-ddd-test
    :serial t
    :depends-on (:fiveam
		 :cl-store)
    :components ((:file "test/package")
		 (:file "test/entity-test")
		 (:file "test/service-test"))
