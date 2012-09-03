
;;;;;;;;;;;;;;;;;;;;;;;;;
;; emacsの設定ファイル ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(set-language-environment 'Japanese)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

; (global-set-key "\C-cd" 'comment-dwim)    ; C-c d を範囲指定コメントに
; (global-set-key "\C-cb" 'comment-box)   ; C-c b をコメントボックスに
; (global-set-key "\C-c\C-r" 'comment-region) ; C-c r をコメント範囲に
; (global-set-key "\C-ci" 'comment-indent) ; C-c i をコメントインデントに
; (global-set-key "\C-c\C-u" 'uncomment-region)  ; C-c u を範囲指定コメント解除に
; (global-set-key "\C-ck" 'wb-line-number-toggle) ; C-c k で行数を表示
; (global-set-key "\C-h" 'hexl-mode)
; (global-set-key "\C-ct" 'text-mode)
; (global-set-key "\C-ca" 'asm-mode)
; (global-set-key "\C-xi" 'indent-region)  ; インデントの設定
(global-set-key "\C-m" 'newline-and-indent) ; リターンで改行とインデント
; (global-set-key "\C-j" 'newline)  ; 改行
(global-set-key "\C-u" 'undo) ; undo

;; GNU GLOBAL(gtags)
; (autoload 'gtags "gtags" nil t)
; (autoload 'gtags-mode "gtags" "" t)
; (global-set-key "\M-t" 'gtags-find-tag)
; (global-set-key "\M-r" 'gtags-find-rtag)
; (global-set-key "\M-s" 'gtags-find-symbol)
; (global-set-key "\C-p" 'gtags-pop-stack)

(if window-system
    (progn
      (setq initial-frame-alist
            '((width . 190) (height . 55)
              (top . 0) (left . 30)))
      (set-cursor-color "Gray")))

;; 色の設定
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(gud-gdb-command-name "gdb --annotate=1")
 '(large-file-warning-threshold nil)
 '(safe-local-variable-values (quote ((encoding . UTF-8)))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(comint-highlight-prompt ((t (:foreground "green"))))
 '(font-lock-builtin-face ((((class color) (min-colors 8)) (:foreground "red" :weight bold))))
 '(font-lock-function-name-face ((((class color) (min-colors 8)) (:foreground "green" :weight bold))))
 '(font-lock-preprocessor-face ((t (:foreground "cyan")))))

; mac 固有の設定
(setq mac-allow-anti-aliasing nil)

; mac 用の command キーバインド
(setq mac-option-modifier 'meta)

; 対応する括弧を光らせる。
(show-paren-mode t)

; 選択部分のハイライト
(transient-mark-mode t)

;; always terminate last line in file
(setq require-final-newline t)

; default mode is text mode
(setq default-major-mode 'text-mode)

; file名の補完で大文字小文字を区別しない
(setq completion-ignore-case t)

; 補完機能を使う
(setq partial-completion-mode 1)

(set-frame-parameter nil 'alpha 85)
;;(set-frame-parameter nil 'fullscreen 'fullboth) ;;フルスクリーン

;; スタートアップメッセージを非表示
(setq inhibit-startup-message t)
(if window-system (progn
; ツールバーの非表示
(tool-bar-mode nil)))

;; ロードパスの設定
(setq load-path
      (append
       (list
        (expand-file-name "~/.emacs.d/site-lisp/")
        (expand-file-name "~/.emacs.d/elisp/"))
       load-path))

;; 画面分割のキーバインド設定
; (setq windmove-wrap-around t)
; (define-key global-map "\C-o" 'other-window)

(unless (eq window-system 'mac)
  (setq default-input-method "japanese-anthy"))

; (setq load-path (cons (expand-file-name "~/.emacs.d") load-path))
; (setq load-path (cons (expand-file-name "~/.emacs.d/malabar/lisp") load-path))
;
;;タブ幅を 4 に設定
(setq-default tab-width 4)
(setq default-tab-width 4)
;;タブ幅の倍数を設定
(setq tab-stop-list
  '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
;;タブではなくスペースを使う
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe) ; 前と同じ行の幅にインデント

;;~を作らない↑#を作らない↓
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq backup-inhibited t)

;; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda () (inf-ruby-keys)))

;; Fortranモードの設定(固定形式)
(setq fortran-mode-hook
      '(lambda ()
         (setq
          fortran-do-indent 2
          fortran-if-indent 2
          fortran-program-indent 2
          fortran-continuation-indent 2
          )))

;; Fortranモードの設定(自由形式)
(setq f90-mode-hook
      '(lambda ()
         (setq
          f90-do-indent 2
          f90-if-indent 2
          f90-program-indent 2
          f90-continuation-indent 2
          )))

(add-hook 'f90-mode-hook
          '(lambda ()
             (define-key f90-mode-map "\C-m" 'newline-and-indent)))

;; C++ style
(add-hook 'c++-mode-hook
          '(lambda()
             (c-set-style "stroustrup")
             ; インデントは空白文字で行う（TABコードを空白に変換）
             (setq indent-tabs-mode nil)
             ; namespace {}の中はインデントしない
             (c-set-offset 'innamespace 0)
             ; 関数の引数リストの閉じ括弧はインデントしない
             (c-set-offset 'arglist-close 0)))

;; coffee script
(autoload 'coffee-mode "coffee-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

;; markdown mode
(autoload 'markdown-mode "markdown-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.text" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.txt" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md" . markdown-mode))

;; lua mode
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;; Smarty mode
(add-to-list 'auto-mode-alist (cons "\\.tpl\\'" 'smarty-mode))
(autoload 'smarty-mode "smarty-mode" "Smarty Mode" t)

;; erlang
(autoload 'erlang-start "erlang-start" nil t)

;; C-c c で compile コマンドを呼び出す
(define-key mode-specific-map "c" 'compile)

;;; js2-mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.pac$" . js2-mode))

; fixing indentation
; refer to http://mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode
(autoload 'espresso-mode "espresso")
(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (espresso--proper-indentation parse-status))
           node)

      (save-excursion

        ;; I like to indent case and labels to half of the tab width
        (back-to-indentation)
        (if (looking-at "case\\s-")
            (setq indentation (+ indentation (/ espresso-indent-level 2))))

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-indent-sexp ()
  (interactive)
  (save-restriction
    (save-excursion
      (widen)
      (let* ((inhibit-point-motion-hooks t)
             (parse-status (syntax-ppss (point)))
             (beg (nth 1 parse-status))
             (end-marker (make-marker))
             (end (progn (goto-char beg) (forward-list) (point)))
             (ovl (make-overlay beg end)))
        (set-marker end-marker end)
        (overlay-put ovl 'face 'highlight)
        (goto-char beg)
        (while (< (point) (marker-position end-marker))
          ;; don't reindent blank lines so we don't set the "buffer
          ;; modified" property for nothing
          (beginning-of-line)
          (unless (looking-at "\\s-*$")
            (indent-according-to-mode))
          (forward-line))
        (run-with-timer 0.5 nil '(lambda(ovl)
                                   (delete-overlay ovl)) ovl)))))

(defun my-js2-mode-hook ()
  (require 'espresso)
  (setq espresso-indent-level 4
        indent-tabs-mode nil
        c-basic-offset 4)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  ; (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map "\C-\M-\\"
    '(lambda()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion
         (insert " ]----- */"))
       ))
  (define-key js2-mode-map "\C-m" 'newline-and-indent)
  ; (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  ; (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (define-key js2-mode-map "\C-\M-q" 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
      (js2-highlight-vars-mode))
  (message "My JS2 hook"))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;; css の設定
(autoload 'css-mode "css-mode")
(setq auto-mode-alist
      (cons '("\\.css\\'" . css-mode) auto-mode-alist))
(setq cssm-indent-function #'cssm-c-style-indenter)

;; php の設定
(autoload 'php-mode "php-mode" nil t)
(setq auto-mode-alist
      (cons '("\\.php\\'" . php-mode) auto-mode-alist))

;; scheme の設定
(setq scheme-program-name "gosh -I. -i")
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme" t)
(autoload 'run-sheme "cmuscheme" "Run an inferior Scheme process" t)
(defun scheme-other-window ()
  "Run scheme on Other Window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

(define-key global-map
  "\C-cs" 'scheme-other-window)

; PEAR規約のインデント設定にする
;; (setq php-mode-force-pear t)

;; apache 用の設定ファイル
(autoload 'apache-mode "apache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))

;; Common Lispの設定
;; (setq load-path (cons (expand-file-name "~/.emacs.d/slime") load-path)) 
(setq inferior-lisp-program "/usr/local/bin/clisp")    ; clisp用
;; (setq inferior-lisp-program "/opt/local/bin/sbcl")     ; sbcl用
(require 'slime)
(slime-setup)

;; ライン行数を表示する
(require 'wb-line-number)
(setq truncate-partial-width-windows nil)
(setq wb-line-number-scroll-bar t)
(wb-line-number-toggle)

;; yasnippetを実行する
(require 'yasnippet)
(yas/initialize)
(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)

;; ;; yasnippet で k が挿入できないバグがある
;; (local-set-key (kbd "k") 'self-insert-command)

(define-key emacs-lisp-mode-map (kbd "k")
  '(lambda ()
     (interactive)
     (insert "k")))

;; 色設定
(require 'color-theme)
(color-theme-initialize)
(color-theme-arjen)

;; カーソルがある行を強調表示させる
(defface hlline-face
    '((((class color)
              (background dark))
            (:background "gray18" :weight bold))
          (((class color)
                  (background light))
                (:background "#ffffaf"))
              (t
                    ()))
      "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode)

;; haskell mode
(setq auto-mode-alist
      (append auto-mode-alist
              '(("\\.[hg]s$"  . haskell-mode)
                ("\\.hic?$"     . haskell-mode)
                ("\\.hsc$"     . haskell-mode)
                ("\\.chs$"    . haskell-mode))))
(load "~/.emacs.d/haskell-site-file")
(autoload 'haskell-mode "haskell-mode"
  "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
  "Major mode for editing literate Haskell scripts." t)
(setq haskell-program-name "/usr/bin/ghci")
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)
(add-hook 'haskell-mode-hook (lambda () (local-set-key "\C-i" 'ghc-complete)))
(add-hook 'haskell-mode-hook (lambda () (local-set-key [backtab] 'haskell-indent-cycle)))
(add-hook 'haskell-mode-hook 'haskell-hook)
(defun haskell-hook ()
    ;; Use simple indentation.
  (turn-on-haskell-simple-indent)
  (define-key haskell-mode-map (kbd "<return>") 'haskell-simple-indent-newline-same-col)
  (define-key haskell-mode-map (kbd "C-<return>") 'haskell-simple-indent-newline-indent))

