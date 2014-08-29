(in-package :cl-user)

(defpackage cl-ddd
	(:use :cl :cl-store :uuid )
	(:export defentity add-entity remove-entity entity-exists-? find-by-id 
		 list-data load-data save-data id defservice))

