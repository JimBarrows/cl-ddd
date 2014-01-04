(defvar *available-locales* (list
														 (make-instance 'locale 
																						:language "English" 
																						:language-code "EN" 
																						:region-code "us" )))

(defclass numeric () 
	((value
(defclass locale ()
	((language :initarg language)
	 (language-code :initarg language-code)
	 (region-code :initarg region-code)
	 (script-code)
	 (variant-code)
	 (extension)
	 (time-zone-names)
	 (currency-symbols)
	 (date-formats)
	 (date-format-symbols)
	 (number-format)
	 (decimal-format)))

(defclass money()
	((locale :type 'locale :initarg locale)
	 (value :type floating-point-number :initarg value)))

(defclass government-id())

(defclass social-security-number ()
	((first-three)
	 (second-two)
	 (last-four)))
