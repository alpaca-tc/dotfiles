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

;;; Change Log (most recent first)
;;
;; 2004-01-02  hajo  Changed format to match my non-C++ style comments
;;                   and added my Copyright licence.
;;
;; 2001-04-05  tree  Fixed problem in return value recognizer where it did
;;                   recognize pointer return values (reported by Mark
;;                   Tigges, <mtigges@cpsc.ucalgary.ca>
;; 2000-08-25  tree  Merged fixes/extensions from Marcelo Matus and
;;                   John Sturton. Released version 1.1.
;; 2000-07-24  tree  Initial release (1.0)

;;; Code:

(defvar doxygen-date-format "%Y-%m-%d"
  "The format used to display dates when using the \\date command.")

(defun doxygen-insert-comment()
  "Insert a generic Doxygen comment block at point, including brief
and long sections."
  (interactive "*")
  (beginning-of-line)
  (save-excursion 
    (save-restriction
      (widen)
      (let ((start (point)))
        (insert (concat "/** \n"
			" ** \n"
                        " **/\n"))
        (let ((end (point)))
          (indent-region start end nil)))))
  (end-of-line))

(defun doxygen-insert-file-comment ()
  "Insert a Doxygen file comment at point."
  (interactive "*")
  (let ((file-name (if (buffer-file-name)
                       (file-name-nondirectory (buffer-file-name))
                     "untitled")))
	(insert (format (concat 
		     "/**********************************************************************/\n"
		     "/** <project name> - \n"
		     " ** <description>\n"
		     " **\n"  
		     " **  \\file   %s\n"
		     " **\n"  
		     " **  \\author HaJo Schatz\n"
		     " **\n"  
		     " **  \\version $Id:$\n"
		     " **\n"  
		     " **  \\par Copyight\n"
		     " **  Copyright 2003\n"
		     " **  Permission to use, copy, and distribute this software and its\n"
		     " **  documentation for any purpose with or without fee is hereby granted,\n"
		     " **  provided that the above copyright notice appear in all copies and\n"
		     " **  that both that copyright notice and this permission notice appear\n"
		     " **  in supporting documentation.\n"
		     " **  Permission to modify the software is granted, but not the right to\n"
		     " **  distribute the complete modified source code.  Modifications are to\n"
		     " **  be distributed as patches to the released version.  Permission to\n"
		     " **  distribute binaries produced by compiling modified sources is granted,\n"
		     " **  provided you\n"
		     " **    1. distribute the corresponding source modifications from the\n"
		     " **     released version in the form of a patch file along with the binaries,\n"
		     " **    2. add special version identification to distinguish your version\n"
		     " **     in addition to the base release version number,\n"
		     " **    3. provide your name and address as the primary contact for the\n"
		     " **     support of your modified version, and\n"
		     " **    4. retain our contact information in regard to use of the base\n"
		     " **     software.\n"
		     " **  Permission to distribute the released version of the source code along\n"
		     " **  with corresponding source modifications in the form of a patch file is\n"
		     " **  granted with same provisions 2 through 4 for binary distributions.\n"
		     " **  This software is provided \"as is\" without express or implied warranty\n"
		     " **  to the extent permitted by applicable law.\n"
		     " **\n"
		     "*************************************************************************/\n")
		     file-name))))


(defun doxygen-insert-function-comment ()
  "Insert a Doxygen comment for the function at point."
  (interactive "*")
  (beginning-of-line)
  (save-excursion 
    (save-restriction
      (widen)
      (let ((start (point)))
        (let ((args (find-arg-list)))
          (insert (concat "/** \n"
                          " ** <long-description>\n"
                          " **\n"))
          (when (cdr (assoc 'args args))
            (dump-arguments (cdr (assoc 'args args))))
          (unless (string= "void" (cdr (assoc 'return args)))
            (insert " ** \\return <ReturnValue>\n"))
          (insert " **/\n"))
        (let ((end (point)))
          (indent-region start end nil)
          (untabify start end)))))
  (end-of-line))

(defun doxygen-insert-member-group-region (start end)
  "Make the current region a member group."
  (interactive "*r")
  (save-excursion
    (goto-char start)
    (beginning-of-line)
    ; indent-according-to-mode doesn't work well here...
    (insert "//@{\n")
    (goto-char end)
    (end-of-line)
    (insert "\n//@}\n")))

(defun doxygen-insert-compound-comment ()
  "Insert a compound comment."
  (interactive "*")
  (let ((comment-start "/*!< ")
        (comment-end "*/"))
    (indent-for-comment)))


;;; internal utility functions

(defun dump-arguments (arglist)
  "Insert a comment with the Doxygen comments for a function."
  (mapcar (function (lambda (x)
                      (insert (format " ** \\param %s\t\n"
                                      (extract-argument-name x)))))
          arglist))

(defun extract-argument-name (arg)
  "Get the argument name from the argument string 'arg'."
  ; this does *not* work for function pointer arguments
  (if (string-match "\\([a-zA-Z0-9_]+\\)\\s-*\\(=\\s-*.+\\s-*\\)?$" arg)
      (substring arg (match-beginning 1) (match-end 1))
    arg))

(defun find-return-type ()
  "Extract the return type of a function.
   If the function is a constructor, it returns void."
  (interactive "*")
  (save-excursion
    (let ((start (point)))
      (search-forward "(")
      (let ((bound (point)))
        (goto-char start)
        (if (re-search-forward 
             (concat
              "\\(virtual \|static \|const \\)*" ; opt. modifiers
              "\\([a-zA-Z0-9_:*]+\\)\\s-+[a-zA-Z0-9_:*]+\\s-*(") ; return type
             bound t)
            (buffer-substring (match-beginning 2)(match-end 2))
          "void")
        ))))
        
(defun find-arg-list ()
  "Extract various bits of information from a C or C++ function declaration"
  (interactive "*")
  (let ((return-type (find-return-type)))
  (save-excursion
    (if (re-search-forward (concat
                              "\\([a-zA-Z0-9_:]+\\)\\s-*("    ; function name
                              "\\([^)]*\\))")                 ; argument list
                           nil t)
          (list (cons 'return   return-type)
                (cons 'function (buffer-substring (match-beginning 1)
                                                  (match-end 1)))
                (cons 'args     (split-string
                                 (buffer-substring (match-beginning 2)
                                                   (match-end 2)) ",")))
      nil))))

(provide 'doxygen)

;;; doxygen.el ends here
