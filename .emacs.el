
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
(global-font-lock-mode t)

(global-set-key "\C-cd" 'comment-dwim)    ; C-c d を範囲指定コメントに
(global-set-key "\C-cb" 'comment-box)   ; C-c b をコメントボックスに
(global-set-key "\C-c\C-r" 'comment-region) ; C-c r をコメント範囲に
(global-set-key "\C-ci" 'comment-indent) ; C-c i をコメントインデントに
(global-set-key "\C-c\C-u" 'uncomment-region)  ; C-c u を範囲指定コメント解除に
(global-set-key "\C-ck" 'wb-line-number-toggle) ; C-c k で行数を表示
(global-set-key "\C-h" 'hexl-mode)
(global-set-key "\C-ct" 'text-mode)
(global-set-key "\C-ca" 'asm-mode)
(global-set-key "\C-xi" 'indent-region)  ; インデントの設定
(global-set-key "\C-m" 'newline-and-indent) ; リターンで改行とインデント
(global-set-key "\C-j" 'newline)  ; 改行
(global-set-key "\C-u" 'undo) ; undo

;; 画面分割のキーバインド設定
(setq windmove-wrap-around t)
(define-key global-map "\C-o" 'other-window)

(unless (eq window-system 'mac)
  (setq default-input-method "japanese-anthy"))

(setq load-path (cons (expand-file-name "~/.emacs.d") load-path))
(server-start)

;;タブ幅を 4 に設定
(setq-default tab-width 4)
(setq default-tab-width 4)
;;タブ幅の倍数を設定
(setq tab-stop-list
  '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
;;タブではなくスペースを使う
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe) ; 前と同じ行の幅にインデント

;; モードの設定
(push '("\\.txt$" . paragraph-indent-text-mode) auto-mode-alist)

(setq mac-allow-anti-aliasing nil)  ; mac 固有の設定
(setq mac-option-modifier 'meta) ; mac 用の command キーバインド

(show-paren-mode t) ; 対応する括弧を光らせる。
(transient-mark-mode t) ; 選択部分のハイライト

(setq require-final-newline t)          ; always terminate last line in file
(setq default-major-mode 'text-mode)    ; default mode is text mode

;; スタートアップメッセージを非表示
(setq inhibit-startup-message t)
(if window-system (progn
; ツールバーの非表示
(tool-bar-mode nil)))

;;~を作らない↑#を作らない↓
(setq backup-inhibited t)
(setq make-backup-files nil)
(setq auto-save-default nil)

;; 行番号を表示
(require 'wb-line-number)
(setq truncate-partial-width-windows nil)
;(set-scroll-bar-mode nil)
(setq wb-line-number-scroll-bar t)
(wb-line-number-toggle)

;; ;;; js2-mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


;;;; File-Info - ファイル情報
;;;;;; 2007年12月29日(土曜日) 21:07:43 JST
;;; カレントバッファのファイル情報を表示する。
(defun file-info () "
カレントバッファのファイル情報を表示する。"
  (interactive)
  (if (buffer-file-name (current-buffer))
      (progn
        (let* ((file-name (buffer-file-name (current-buffer)))
               (f-attr (file-attributes file-name))
               (a-time (nth 4 f-attr))  ; 最終アクセス時刻
               (m-time (nth 5 f-attr))  ; 最終修正時刻
               (f-size (nth 7 f-attr))  ; ファイルサイズ
               (f-mode (nth 8 f-attr))  ; ファイル属性
               (mes1 (format "ファイルパス:   %s\n" file-name))
               (mes2 (format "最終参照時刻:   %s\n"
                              (format-time-string
                               "%Y-%m-%d %H:%M:%S" a-time)))
               (mes5 (format "ファイル属性:   %s" f-mode))
               (mess (concat mes1 mes2 mes5)))
          (message "%s" mess)))
    nil))

;; commentの設定
(setq comment-style 'extra-line)
(global-set-key "\C-c\C-i" 'file-info)

;; ;; cssの設定
(autoload 'css-mode "css-mode")
(setq auto-mode-alist
     (cons '("\\.css\\'" . css-mode) auto-mode-alist))
(setq cssm-indent-function #'cssm-c-style-indenter)

; リージョンに色を付ける
(setq transient-mark-mode t)

;; php mode
(require 'php-mode)

;; ruby mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
             (inf-ruby-keys)))

;; apacheのconfファイルの設定
(autoload 'apache-mode "apache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))
