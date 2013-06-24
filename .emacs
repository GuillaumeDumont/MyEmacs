; Set some variables of the editor
(custom-set-variables
 '(user-full-name "Guillaume Dumont")
 '(user-mail-address "me@guillaumedumont.com"))

; Load paths
(add-to-list 'load-path "/usr/share/emacs/site-lisp")
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/auto-complete-1.3.1/")


;; on quit, ask for add a new line at the end if absent
(setq require-final-newline 'query)

;; on quit, delete trailing white spaces
(add-hook 'write-file-hooks 'delete-trailing-whitespace)

;; keep accentued letters during a copy/paste from another X program
(setq selection-coding-system 'compound-text-with-extensions)

;; set emacs in text-mode by default
(setq initial-major-mode 'text-mode)
(setq default-major-mode 'text-mode)

;; display current line, column, time and battery
(setq column-number-mode t)
(setq line-number-mode t)
(display-time)
(setq display-time-24hr-format t)
(display-battery-mode t)

;; keep the position of the cursor on the screen during scrolling
(setq scroll-preserve-screen-position 1)
;; when the cursor is at the end of a window, only move the content of 1 line
(setq scroll-step 1)

;; standard indent by 2 space
(setq standard-indent 2)

;; cool gdb windows mode
(setq gdb-many-windows 1)

;; mouse wheel work
(xterm-mouse-mode t)
(mouse-wheel-mode t)
(setq mouse-wheel-follow-mouse t)

;; inhibit home message
(setq inhibit-startup-message t)
;; no more yes or no !
(fset 'yes-or-no-p 'y-or-n-p)
;; no useless menu bar
(menu-bar-mode nil)

;; list of mode-hook
(setq mode-hook-list '(c-mode-common-hook
		       emacs-lisp-mode-hook
		       java-mode-hook
		       perl-mode-hook
		       python-mode-hook))
;; list of mode
(setq mode-list '(c-mode-common
		  emacs-lisp-mode
		  java-mode
		  perl-mode
		  python-mode))


;; Add `mode' to all hook in `hook-list'
(defun add-hook-list (hook-list mode)
  (mapcar (lambda (hook)
	    (add-hook hook mode))
	  hook-list))

;; active `hide-show-mode'
(add-hook-list mode-hook-list 'hs-minor-mode)
;; `hs-hide-all' doesn't hide comments
(setq hs-hide-comments-when-hiding-all nil)


;;------------------------------------------------------------------------------
;; Doxymacs
;;------------------------------------------------------------------------------
(require 'doxymacs)
(add-hook 'c-mode-common-hook'doxymacs-mode)
(defun my-doxymacs-font-lock-hook ()
  (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
      (doxymacs-font-lock)))
(add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)

; Affiche le numero des columns
(setq column-number-mode t)

; La molette affecte le buffer sous la souris
(setq mouse-wheel-follow-mouse t)

; les tab font 2 espaces
(setq tab-width 2)

; indentation par pas de 2 espaces
(setq standard-indent 2)

; Hilight de la region selectionne au clavier
(transient-mark-mode 1)

; Pour etre sur de ne pas beeper
(setq visible-bell t)

; Affiche numero de ligne
(line-number-mode t)

; option pour l'affichage des parentheses
(setq show-paren-face 'modeline)

;;------------------------------------------------------------------------------
;; auto complete
;;------------------------------------------------------------------------------
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete-1.3.1/ac-dict")

;;------------------------------------------------------------------------------
;; yasnippet
;;------------------------------------------------------------------------------
;;(require 'yasnippet)

(require 'color-theme)
;;(require 'color-theme-sunburst.el)
(require 'color-theme-sons-of-obsidian)
(color-theme-sons-of-obsidian)

;;------------------------------------------------------------------------------
;; clang for c++
;;------------------------------------------------------------------------------

; from echo "" | g++ -v -x c++ -E -
(setq ac-clang-flags
      (mapcar (lambda (item)(concat "-I" item))
              (split-string
               "
 /usr/lib/gcc/i686-pc-linux-gnu/4.7.0/../../../../include/c++/4.7.0
 /usr/lib/gcc/i686-pc-linux-gnu/4.7.0/../../../../include/c++/4.7.0/i686-pc-linux-gnu
 /usr/lib/gcc/i686-pc-linux-gnu/4.7.0/../../../../include/c++/4.7.0/backward
 /usr/lib/gcc/i686-pc-linux-gnu/4.7.0/include
 /usr/local/include
 /usr/lib/gcc/i686-pc-linux-gnu/4.7.0/include-fixed
 /usr/include
 /usr/include/boost
"
               )))
(load-file "~/.emacs.d/auto-complete-1.3.1/auto-complete-clang.el")
(require 'auto-complete-clang)
(setq ac-auto-start nil)
(setq ac-quick-help-delay 0.5)
(global-set-key (read-kbd-macro "C-q") 'auto-complete)
(defun my-ac-config ()
  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
  (add-hook 'python-mode-hook 'ac-python-mode-setup)
  (add-hook 'css-mode-hook 'ac-css-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
(my-ac-config)

; GO support
(add-to-list 'load-path "/usr/local/go/misc/emacs")
(require 'go-mode-load)
(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook (lambda ()
                          (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))
(add-hook 'go-mode-hook (lambda ()
                          (local-set-key (kbd "C-c i") 'go-goto-imports)))
(add-hook 'go-mode-hook (lambda ()
                          (local-set-key (kbd "M-.") 'godef-jump)))

;(add-to-list 'load-path "~/.gocode/src/github.com/dougm/goflymake")
;(require 'go-flycheck)


(add-to-list 'load-path "~/.gocode/src/github.com/nsf/gocode/emacs")
(add-to-list 'load-path "~/.gocode/src/github.com/nsf/gocode")
(require 'go-autocomplete)
(require 'auto-complete-config)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

(require 'dirtree)
(autoload 'dirtree "dirtree" "Add directory to tree view" t)
(global-set-key "\C-o" 'dirtree-show)

