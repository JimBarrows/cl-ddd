(in-package :cl)

(defpackage :cl-ddd-asdf
  (:use :cl :asdf))

(in-package :cl-ddd-asdf)

(defsystem "cl-ddd"
           :serial t
  :depends-on ("cl-store"
               "uuid"
               "alexandria")
  :components ((:file "package")
               (:file "types")
               (:file "entity")
               (:file "api")
               (:file "constants")))

(defsystem "cl-ddd-test"
           :serial t
  :depends-on ("fiveam"
               "cl-store")
  :components ((:module "test"
                        :serial t
			:components (
                        (:file "package")
                        (:file "entity-test")
                        (:file "service-test")))))
