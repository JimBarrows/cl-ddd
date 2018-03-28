(asdf:defsystem #:cl-ddd-test
    :serial t
    :depends-on (:fiveam
		 :cl-store)
    :components ((:file "test/package")
		 (:file "test/entity-test")
		 (:file "test/service-test"))
