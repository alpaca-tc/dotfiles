;;; c-doc.el --- provides simple way to generate comment-style documentation

;; Author: mooz <stillpedant@gmail.com>
;; Version: (see `c-doc-version' below)
;; Keywords: document, comment
;; X-URL: http://d.hatena.ne.jp/mooz/

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

(defconst c-doc-version "0.0.1"
  "Current version of package c-doc.")

;;; Custom:
(defgroup c-doc nil
  "provides simple way to generate comment-style documentation."
  :group 'comment
  :prefix "c-doc")

;; Variables
(defcustom c-doc-mail-address ""
  "Author's E-mail address."
  :group 'c-doc)

(defcustom c-doc-author ""
  "Author of the source code."
  :group 'c-doc)

(defcustom c-doc-url ""
  "Author's Home page address."
  :group 'c-doc)

;;; Lines
(defcustom c-doc-file-line " * @file %s\n"
  "%s be to replace with the filename."
  :group 'c-doc)

(defcustom c-doc-author-line " * @author %s\n"
  "%s be to replace with the author name."
  :group 'c-doc)

(defcustom c-doc-date-line " * @date %s\n"
  "%s be to replace with the current time."
  :group 'c-doc)

(defcustom c-doc-brief-line " * @brief\n"
  "Author of the source code."
  :group 'c-doc)

(defcustom c-doc-top-line "/**\n"
  "Format for top line."
  :group 'c-doc)

(defcustom c-doc-description-line" * %s - \n"
  "Format for description line.
 %s be to replace with function name."
  :group 'c-doc)

(defcustom c-doc-parameter-line " * @param %s\n"
  "Format for parameter line.
 %s be to replace with parameter name."
  :group 'c-doc)

(defcustom c-doc-return-line " * @return\n"
  "Format for return line."
  :group 'c-doc)

(defcustom c-doc-bottom-line " */\n"
  "Format for top line."
  :group 'c-doc)

;;; Main codes:
(defun c-doc-tail (list)
  (if (cdr list)
      (c-doc-tail (cdr list))
    (car list))
  )

(defun c-doc-pick-symbol-name (str)
  "Pick up symbol's name
e.g. '   float array[]' => 'array'"
  (c-doc-tail (delete "" (split-string str "[^a-zA-Z_]")))
  )

(defun c-doc-insert-file-doc ()
  "Insert specified-style comment top of the file"
  (interactive)
  (goto-char 1)
  (insert c-doc-top-line)
  ;; Insert file line
  (insert (format c-doc-file-line
		  (buffer-name)))
  ;; Insert brief line
  (insert c-doc-brief-line)
  ;; Insert author line
  (insert (format c-doc-author-line
		  c-doc-author))
  ;; Insert date line
  (insert (format c-doc-date-line
		  (current-time-string)))
  (insert c-doc-bottom-line)
  (insert "\n")
  )

(defun c-doc-insert-function-doc ()
  "Insert specified-style comment top of the function"
  (interactive)
  (beginning-of-defun)
  ;; Parse function info
  (let ((func-name "")
	(params '())
	(head-of-func (point))
	(from nil)
	(to nil))
    (save-excursion
      ;; Trail backward and add arguments to the list
      (search-forward "{" nil t)
      ;; Prevent S-exp parser from permanent work
      (backward-char 1)
      (setq from (backward-list))
      (setq to (forward-list))
      (setq func-name (c-doc-pick-symbol-name
		       (buffer-substring-no-properties head-of-func from)))
      ;; Now we got string between () e.g. 'int a, char *b[], ... '
      (dolist (param-block
	       (split-string (buffer-substring-no-properties (+ from 1) (- to 1)) ","))
	(setq params (cons (c-doc-pick-symbol-name param-block) params))
	)
      ;; How awful ...
      (setq params (reverse params))
      )
    (insert c-doc-top-line)
    ;; Insert description line
    (insert (format c-doc-description-line
		    (c-doc-pick-symbol-name func-name)))
    ;; Insert parameter lines
    (while params
      (insert (format c-doc-parameter-line
		      (car params)))
      (setq params (cdr params)))
    ;; Insert return value line
    (insert c-doc-return-line)
    (insert c-doc-bottom-line)
    )
  )

(defun c-doc-insert ()
  "Check if the current point is in the function block;
if in the function block, call insert-function-doc;
otherwise, call insert-file-doc."
  (interactive)
  (let ((old-point (point))
	(new-point nil))
    (beginning-of-defun)
    (setq new-point (point))
    (end-of-defun)
    (if (or (< (point) old-point)
	    (= 1 new-point))
	(c-doc-insert-file-doc)
      (c-doc-insert-function-doc)))
  )

(provide 'c-doc)
