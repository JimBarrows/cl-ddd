(asdf:defsystem #:cl-ddd
    :serial t
    :depends-on (#:cl-store
		 #:uuid
		 #:alexandria)
    :components ((:file "package")
		 (:file "types")
		 (:file "entity")
		 (:file "constants")))


