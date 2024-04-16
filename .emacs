(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
	 '("940bf45c7f4b8ee4b4d4928b63fb8e170bf5bb44e524f93899c83d8d60e604ea" "33287893d3bae86fefff0601fd99071d67fc72caa30019986b85b38ec5a95d1b" "3160ce28d442228f9e0a405f34fa94522e6bdaedb58e268e8f957ecd1fe35476" default))
 '(package-selected-packages
	 '(paredit org-modern org modus-themes racket-mode cider clojure-mode consult corfu marginalia orderless vterm rainbow-mode rainbow-delimiters beacon vertico meow)))

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(setq-default tab-width 2)
(setq vc-follow-symlinks t) ; disable symlink warning
(save-place-mode 1) ; save cursor pos if you close emacs
(global-auto-revert-mode 1) ; auto update file if it changes
(set-face-attribute 'default nil :family "Iosevka" :height 218)
(set-face-attribute 'variable-pitch nil :family "Iosevka Aile" :height 218)

;; setup backup folder
(setq auto-save-file-name-transforms `((".*" "~/.local/share/Trash/files/" t)))
(setq backup-directory-alist '((".*" . "~/.local/share/Trash/files/")))

; vim like scrolling
(setq scroll-margin 3) 
(setq scroll-conservatively 101)

(beacon-mode 1) ; never lose your cursor again
(use-package rainbow-mode
  :hook org-mode prog-mode) ; show hex colors
(use-package rainbow-delimiters
  :hook org-mode prog-mode) ; rainbow brackets

;; term enulator
(use-package vterm
  :config
  (setq shell-file-name "/bin/bash"
				vterm-max-scrollback 5000))

;; paredit
(use-package paredit
	:hook org-mode prog-mode)


;; COMPLETION SNIPPET
;;
(use-package vertico ; for minibuffer completion
  :init
  (vertico-mode)
  (setq vertico-cycle t))
(keymap-set vertico-map "TAB" #'vertico-next) ; change default hotkeys
(keymap-set vertico-map "S-<iso-lefttab>" #'vertico-previous)

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Support opening new minibuffers from inside existing minibuffers.
  (setq enable-recursive-minibuffers t)

  ;; Emacs 28 and newer: Hide commands in M-x which do not work in the current
  ;; mode.  Vertico commands are hidden in normal buffers. This setting is
  ;; useful beyond Vertico.
  (setq read-extended-command-predicate #'command-completion-default-include-p))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

; buffer completion
(use-package corfu
  ;; TAB-and-Go customizations
  :custom
  (corfu-auto t)
  (corfu-cycle t)           ;; Enable cycling for `corfu-next/previous'
  (corfu-preselect 'prompt) ;; Always preselect the prompt
  ;; Use TAB for cycling, default is `corfu-complete'.
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)
	("RET" . nil))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-history-mode)
  ;(corfu-echo-mode)
  )
(savehist-mode 1) ; for history mode working
(add-to-list 'savehist-additional-variables 'corfu-history)
(setq corfu-popupinfo-delay 0.3)
;;
;; STOP COMPLETION SNIPPET



; activate commands to allow half-page scroll
(autoload 'View-scroll-half-page-forward "view")
(autoload 'View-scroll-half-page-backward "view")

;; setup default directory
(defun my-fd ()
	(interactive)
	(consult-fd "~"))

;; meow keys
(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; Custom SPC commands, but x / h / c / m / g is reserved
   '("j" . consult-buffer)							; find buffer
   '("b" . kill-buffer)									; bakuretsu buffer
   '("s" . save-buffer)
   '("e" . cider-eval-last-sexp)
	 '("r" . cider-eval-buffer)
	 '("i" . cider-find-dwim-other-window) ; go to implementation
	 '("d" . cider-doc)										 ; show doc
   '("o" . find-file)										 ; open local file
	 '("O" . my-fd)									       ; open global file
   '("p" . consult-yank-from-kill-ring)	 ; open kill ring
   '("N" . set-mark-command)						 ; set mark
   '("n" . consult-mark)								 ; find marks
   '("a" . consult-imenu)								 ; all symbols picker
   '("f" . consult-line)								 ; find inside file
	 '("u" . meow-comment)								 ; uncomment/comment
	 '("w" . paredit-wrap-sexp)
	 '("TAB" . other-window)
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("." . meow-inner-of-thing)
   '("," . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("d" . meow-back-word)
   '("D" . meow-back-symbol)
   '("c" . meow-change)
   '("s" . meow-delete)
   '("S" . meow-backward-delete)
   '("f" . meow-next-word)
   '("F" . meow-next-symbol)
   '("r" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next) 
   '("J" . View-scroll-half-page-forward) ; changed from meow-next-expand
   '("k" . meow-prev)
   '("K" . View-scroll-half-page-backward) ; changed from meow-prev-expand
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . consult-goto-line)
   '("b" . meow-replace)
   '("B" . meow-swap-grab)
   '("w" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("e" . meow-mark-word)
   '("E" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<" . indent-rigidly-left-to-tab-stop)
   '(">" . indent-rigidly-right-to-tab-stop)
	 '("`" . delete-other-windows)
	 '("~" . delete-window)
	 '("W" . paredit-kill)
	 '("C-h" . paredit-forward-slurp-sexp)
	 '("C-l" . paredit-forward-barf-sexp)
	 '("C-k" . paredit-split-sexp)
	 '("C-j" . paredit-join-sexps)
   '("<escape>" . ignore)))
(require 'meow)
(meow-setup)
(meow-global-mode 1)


;; change font size
(setq text-scale-mode-step 1.05)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)


;; racket run
(add-hook 'racket-mode-hook
          (lambda ()
            (define-key racket-mode-map (kbd "<f5>") 'racket-run)))
(add-hook 'racket-mode-hook #'racket-xp-mode) ; locale auto-complete(package-initialize)

;; setup org mode
(require 'org-tempo) ; <s stuff

(setq
 ;; Edit settings
 org-auto-align-tags nil
 org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t

 ;; Org styling, hide markup etc.
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-ellipsis "…"

 ;; Agenda styling
 org-agenda-tags-column 0
 org-agenda-block-separator ?─
 org-agenda-time-grid
 '((daily today require-timed)
   (800 1000 1200 1400 1600 1800 2000)
   " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
 org-agenda-current-time-string
 "◀── now ─────────────────────────────────────────────────"
 org-agenda-start-with-log-mode t
 org-log-done 'time
 org-log-into-drawer t
 org-agenda-files '("~/wakuwaku/projects/notes/tasks.org"))

(global-org-modern-mode)


;; THEME

;; palete overrides
;; f5deb3 => 000f08 => ff3864 => 02a9ea => 809bce
(setq modus-vivendi-palette-overrides
	'(
		(color-wheat "#f5deb3")
		(color-night "#000f08")
		(color-folly "#ff3864")
		(color-picton-blue "#02a9ea")
		(color-vista-blue "#809bce")
		(fg-main "#f5deb3")
		(magenta  color-folly)
		))

;; remove modeline border
(setq modus-themes-common-palette-overrides
      '((border-mode-line-active unspecified)
        (border-mode-line-inactive unspecified) ; remove modeline border
				(bg-mode-line-active color-night)
        (fg-mode-line-active fg-main)
        (border-mode-line-active unspecified)
        (border-mode-line-inactive unspecified)
				(bg-region bg-ochre) 
        (fg-region unspecified)))


(load-theme 'modus-vivendi t)

