(set-language-environment 'Japanese)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(unless (eq window-system 'mac)
  (setq default-input-method "japanese-anthy"))

(setq load-path (cons (expand-file-name "~/.emacs.d") load-path))
(server-start)

(setq c-tab-always-indent t)
(setq default-tab-width 4)
(setq indent-line-function 'indent-relative-maybe) ; 前と同じ行の幅にインデント

(setq mac-allow-anti-aliasing nil)  ; mac 固有の設定
(setq mac-option-modifier 'meta) ; mac 用の command キーバインド
;; (mac-key-mode 1) ; MacKeyModeを使う

(global-set-key "\C-x\C-i" 'indent-region) ; 選択範囲をインデント
(global-set-key "\C-m" 'newline-and-indent) ; リターンで改行とインデント
(global-set-key "\C-j" 'newline)  ; 改行

(global-set-key "\C-cc" 'comment-region)    ; C-c c を範囲指定コメントに
(global-set-key "\C-cu" 'uncomment-region)  ; C-c u を範囲指定コメント解除に

(show-paren-mode t) ; 対応する括弧を光らせる。
(transient-mark-mode t) ; 選択部分のハイライト

(setq require-final-newline t)          ; always terminate last line in file
(setq default-major-mode 'text-mode)    ; default mode is text mode

(setq completion-ignore-case t) ; file名の補完で大文字小文字を区別しない
(setq partial-completion-mode 1) ; 補完機能を使う

(set-frame-parameter nil 'alpha 85)
;;(set-frame-parameter nil 'fullscreen 'fullboth) ;;フルスクリーン


;; スタートアップメッセージを非表示
(setq inhibit-startup-message t)
(if window-system (progn
; ツールバーの非表示
(tool-bar-mode nil)))

;;(if (eq window-system 'mac) (require 'carbon-font))
;;(fixed-width-set-fontset "osaka" 10)

(if window-system (progn
(setq initial-frame-alist '((width . 190) (height . 55)
(top . 0) (left . 30)))
(set-cursor-color "Gray")
))

(setq backup-inhibited t)

(setq make-backup-files nil)
;;~を作らない↑#を作らない↓
(setq auto-save-default nil)

;; C++ style
(add-hook 'c++-mode-hook
          '(lambda()
             (c-set-style "stroustrup")
             (setq indent-tabs-mode nil)     ; インデントは空白文字で行う（TABコードを空白に変換）
             (c-set-offset 'innamespace 0)   ; namespace {}の中はインデントしない
             (c-set-offset 'arglist-close 0) ; 関数の引数リストの閉じ括弧はインデントしない
             ))

;; tex の設定
;;(require 'tex-site)
;;(setq TeX-default-mode 'japanese-latex-mode)
;;(setq japanese-TeX-command-default "pTeX")
;;(setq japanese-LaTeX-command-default "pLaTeX")
;;(setq japanese-LaTeX-default-style "jsarticle")
;;(setq-default TeX-master nil)
;;(setq TeX-parse-self t)
;;(add-to-list 'TeX-output-view-style
;;'("^dvi$" "." "dvipdfmx %dS %d && open %s.pdf"))

;; erlangの設定
(setq load-path (cons  "/opt/local/lib/erlang/lib/tools-2.6.6.2/emacs"
      load-path))
      (setq erlang-root-dir "/opt/local")
      (setq exec-path (cons "/opt/local/bin" exec-path))
      (require 'erlang-start)

;;face-listの設定
(require 'face-list)

