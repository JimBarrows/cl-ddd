(in-package :cl)

(defpackage :cl-ddd-asdf
  (:use :cl :asdf))

(in-package :cl-ddd-asdf)

(defsystem "cl-ddd"
           :serial t
  :depends-on ("cl-store"
               "uuid"
               "alexandria"
               "ningle"
               "cl-json"
               "clack")
  :components ((:file "package")
               (:file "types")
               (:file "entity")
               (:file "api")
               (:file "constants")))

(defsystem "cl-ddd-test"
           :serial t
  :depends-on ("fiveam"
               "cl-store"
               "drakma")
  :components ((:module "test"
                        :serial t
			:components (
                                     (:file "package")
                                     (:file "test-suites")
                                     (:file "fixtures")
                                     (:file "entity-test")
                                     ;;(:file "service-test")
                                     (:file "api-test")))))
