; (in-package :cl-user)

(defpackage cl-ddd
	(:use :cl :cl-store :uuid :cl-json)
	(:export defentity id))
