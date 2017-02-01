(in-package :cl-ddd)

(defvar *available-locales* (list
                             (make-instance 'locale
                                :language "English"
                                :language-code "EN"
                                :region-code "us")))
