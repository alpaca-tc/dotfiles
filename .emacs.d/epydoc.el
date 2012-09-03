;;; eypdoc.el -- epydoc-style comments

;; Copyright (c) 2008, Atsushi Suga
;; All rights reserved.
;; 
;; Redistribution and use in source and binary forms,
;; with or without modification,
;; are permitted provided that the following conditions are met:
;; 
;; * Redistributions of source code must retain the above copyright notice,
;;   this list of conditions and the following disclaimer.
;; * Redistributions in binary form must reproduce the above copyright notice,
;;   this list of conditions and the following disclaimer in the documentation and/or
;;   other materials provided with the distribution.
;; * the names of its contributors may be used to endorse or promote products
;;   derived from this software without specific prior written permission.
;; 
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
;; BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
;; FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
;; IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
;; INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
;; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
;; STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

;;; this code is based on doxygen.el written by Tom Emerson.
;;; forrow is doxygen.el Copyright ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; doxygen.el --- doxygen-style comments

;; Copyright (C) 2000-2001 Basis Technology, Corp.

;; Author: Tom Emerson <tree@basistech.com>
;; Keywords: languages comments doxygen
;; Version: 1.1

;;; Commentary:

;; TODO:
;;
;; - better documentation
;; - key bindings, perhaps
;; - allow field insertion, a la BibTeX mode
;; - generalize comment types - right now these reflect my personal
;;   style and the fact that I'm doing all of my work in C++.
;;
;; ACKNOWLEDGEMENTS:
;;
;; - John Sturton <john.sturton@sescoi.fr> for finding bugs in the function
;;   recognizer and sending patches to these.
;;
;; - Marcelo Matus <matus@ece.arizona.edu> for extensions to the function
;;   recognizer and to the comment insertion functions.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; end of doxygen.el Copyright ;;;

;;; totorial ;;;

;; use as
;; write to your .emacs
;; (require 'epydoc)
;; 
;; If you want file comment, type forrow at beginning of your python code
;; M-x epydoc-insert-file-comment
;;
;; And if you want function comment,
;; type forrow at beginning of function definition (e.g def blur(arg):)
;; M-x epydoc-insert-function-comment
;;
;; and you can define your default copyright, project-name and author-name
;; like forrow
;;    (setq epydoc-copyright
;;	       "BSD"))
;;    (setq epydoc-project-name
;;	       "my python project"))
;;    (setq epydoc-author-name
;;	       "Atsushi Suga"))

;; bugs
;; epydoc-insert-function-comment can't indent correctly if there are not any statement
;; after function definition.
;;
;; because epydoc-insert-comment does not fined end of python function define ":"
;; only use 'py-next-statement and insert comments there
;; so cursol must be pointing the line of function definition
;; In other case (pointing prev or next line), insert unexpect indent.
;;

(defvar epydoc-date-format "%Y-%m-%d"
  "The format used to display dates when using the \\date command.")

(if (not (boundp 'epydoc-copyright))
    (setq epydoc-copyright
	       ""))

(if (not (boundp 'epydoc-project-name))
    (setq epydoc-project-name
	       ""))

(if (not (boundp 'epydoc-author-name))
    (setq epydoc-author-name
	       ""))

(defun epydoc-insert-comment()
  "Insert a generic epydoc comment block at point, including brief
and long sections."
  (interactive "*")
  (beginning-of-line)
  (save-excursion 
    (save-restriction
      (widen)
      (let ((start (point)))
        (insert (concat "\"\"\"\n"
			"\n"
                        "\"\"\"\n"))
        (let ((end (point)))
          (indent-region start end nil)))))
  (end-of-line))

(defun epydoc-insert-file-comment ()
  "Insert a epydoc file comment at point."
  (interactive "*")
  (let ((file-name (if (buffer-file-name)
                       (file-name-nondirectory (buffer-file-name))
                     "untitled")))
	(insert (format (concat 
		     "\"\"\" %s\n"
		     "\n"
		     " <description>\n"
		     "\n"  
		     " @file:   %s\n"
		     "\n"
		     " @author: %s\n"
		     "\n"
		     " @copyright:    %s\n"
		     "\n"
		     "\"\"\"\n")
		     epydoc-project-name	
		     file-name
		     epydoc-author-name
		     epydoc-copyright))))


(defun epydoc-insert-function-comment ()
  "Insert a epydoc comment for the function at point."
  (interactive "*")
  (beginning-of-line)
  (save-excursion 
    (save-restriction
      (widen)
      (let ((comment-str ""))
        (let ((args (find-arg-list)))
          (setq comment-str (concat comment-str
				    "\"\"\" <long-description>\n"
				    " \n"))

	  ;; set arguments
          (when (cdr (assoc 'args args))
	    (setq comment-str
		  (concat comment-str
			  (dump-arguments-return (cdr (assoc 'args args))))))
	  (setq comment-str (concat comment-str " @return: <ReturnValue>\n"))
          (setq comment-str (concat comment-str "\"\"\"\n"))
	  )
        (let ((start nil) (end nil) (offs 0))
	  ;; some agry hacks
	  (py-next-statement 1) ;; next position of function define
	  (setq start (point))  ;; save position for insert comment

	  ;; to get beggining of statement offset
	  (forward-word 1)
	  (backward-word 1)
	  (setq offs (current-column))
	  
	  (goto-char start)     ;; back to comment insert position
	  (insert comment-str)
	  (setq end (point))
          (indent-region start end offs) ;; indent
          (untabify start end)))))
    )

(defun dump-arguments-return (arglist)
  "Insert a comment with the epydoc comments for a function and return it."
  (let ((arg-str ""))
    (mapcar (function (lambda (x)
			(setq arg-str (concat arg-str
					      (format " @param %s:\n"
						      (extract-argument-name x))))))
	    arglist)
    arg-str))


;;; internal utility functions

(defun dump-arguments (arglist)
  "Insert a comment with the epydoc comments for a function."
  (mapcar (function (lambda (x)
                      (insert (format " @param %s:\n"
                                      (extract-argument-name x)))))
          arglist))

(defun extract-argument-name (arg)
  "Get the argument name from the argument string 'arg'."
  ; this does *not* work for function pointer arguments
  (if (string-match "\\([a-zA-Z0-9_]+\\)\\s-*\\(=\\s-*.+\\s-*\\)?$" arg)
      (substring arg (match-beginning 1) (match-end 1))
    arg))

(defun find-arg-list ()
  "Extract various bits of information from a C or C++ function declaration"
  (interactive "*")
  (let ((return-type (find-return-type)))
  (save-excursion
    (if (re-search-forward (concat
                              "\\([a-zA-Z0-9_:]+\\)\\s-*("    ; function name
                              "\\([^)]*\\))")                 ; argument list
                           nil t)
          (list (cons 'return   nil)
                (cons 'function (buffer-substring (match-beginning 1)
                                                  (match-end 1)))
                (cons 'args     (split-string
                                 (buffer-substring (match-beginning 2)
                                                   (match-end 2)) ",")))
      nil))))

(provide 'epydoc)

;;; epydoc.el ends here
