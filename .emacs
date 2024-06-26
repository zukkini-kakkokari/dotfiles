(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)


;; *elpa mirrors
;; (setq package-archives
;;       '(("melpa" . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/melpa/")
;;         ("org"   . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/org/")
;;         ("gnu"   . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/gnu/")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(electric-pair-pairs '((34 . 34) (8216 . 8217) (8220 . 8221) (123 . 125)))
 '(package-selected-packages
	 '(puni lsp-mode company-quickhelp company web-mode emmet-mode org-modern org modus-themes racket-mode cider clojure-mode consult corfu marginalia orderless rainbow-mode rainbow-delimiters beacon vertico meow))
 '(safe-local-variable-values
	 '((cider-clojure-cli-parameters . "-A:fig")
		 (cider-clojure-cli-global-options . "-A:fig")
		 (cider-clojure-cli-global-options . "-A:dev"))))

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(setq-default tab-width 2)
(setq vc-follow-symlinks t) ; disable symlink warning
(save-place-mode 1) ; save cursor pos if you close emacs
(global-auto-revert-mode 1) ; auto update file if it changes
(setq shell-file-name "/bin/bash")
;; (toggle-frame-fullscreen)
;; (set-face-attribute 'default nil :family "Iosevka Nerd Font Mono" :height 218)
;; (set-face-attribute 'variable-pitch nil :family "Iosevka Aile" :height 218)
(set-face-attribute 'default nil :family "Iosevka" :height 218)
(set-face-attribute 'variable-pitch nil :family "Iosevka Aile" :height 218)

;; Disable autosave
(setq make-backup-files nil)
(setq auto-save-default nil)
;; (setq auto-save-file-name-transforms `((".*" "~/.local/share/Trash/files/" t)))
;; (setq backup-directory-alist '((".*" . "~/.local/share/Trash/files/")))

;; vim like scrolling
(setq scroll-margin 3) 
(setq scroll-conservatively 101)

;; Garbage collection
;; (setq garbage-collection-messages t)

(beacon-mode 1) ; never lose your cursor again
(setq beacon-blink-when-window-scrolls nil)
(setq beacon-blink-when-point-moves-vertically 2)

(use-package rainbow-mode
  :hook org-mode prog-mode) ; show hex colors
(use-package rainbow-delimiters
  :hook org-mode prog-mode) ; rainbow brackets

;; Puni - Parentheses Universalistic
(use-package puni
  :defer t
  :hook ((prog-mode emacs-lisp-mode clojure-mode) . puni-mode))
(setq puni-confirm-when-delete-unbalanced-active-region nil)

;; remap 0 and 9 to ( and )
(defun insert-paren-if-not-next ()
  "Insert ) only if the next character is not the same."
  (interactive)
	(if (char-equal (char-after) ?\))
			(forward-char 1)
      (insert ")")))

(global-set-key (kbd "(") (lambda () (interactive) (insert "9")))
(global-set-key (kbd ")") (lambda () (interactive) (insert "0")))
(global-set-key (kbd "9") (lambda () (interactive) (insert "()") (backward-char)))
(global-set-key (kbd "0") 'insert-paren-if-not-next)
;; force delete character (even if unbalanced)
(global-set-key (kbd "S-<backspace>") (lambda () (interactive) (backward-delete-char 1)))
;; autopair [ and }
(electric-pair-mode 1)

;; emmet mode
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(global-set-key (kbd "M-j") 'emmet-expand-line)
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indent-after-insert nil)))
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent 2 spaces.
(setq-default css-indent-offset 2)


;; web mode
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
	(setq web-mode-css-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; COMPLETION SNIPPET
;;
(use-package vertico										; for minibuffer completion
  :init
  (vertico-mode)
  (setq vertico-cycle t))
(keymap-set vertico-map "TAB" #'vertico-next) ; change default hotkeys
(keymap-set vertico-map "M-TAB" #'vertico-insert)
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

;; company completion
(use-package company
	:config
	(global-company-mode)
	(setq company-idle-delay 0)
	(setq company-quickhelp-delay 0.1)
	(setq company-selection-wrap-around t)
	(setq company-insertion-on-trigger t)
	(setq company-quickhelp-color-background "#303030")
	(setq company-quickhelp-color-foreground "#ffa07a")
	(company-tng-mode)
	(company-quickhelp-mode))


;;
;; STOP COMPLETION SNIPPET


;; activate commands to allow half-page scroll
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
   '("w" . save-buffer)
   '("e" . cider-eval-last-sexp)
	 '("r" . cider-eval-buffer)
	 '("i" . cider-find-dwim-other-window) ; go to implementation
	 '("d" . cider-doc)										 ; show doc
   '("o" . find-file)										 ; open local file
	 '("O" . my-fd)									       ; open global file
   '("p" . consult-yank-from-kill-ring)	 ; open kill ring
	 '("P" . clipboard-yank)
	 '("Y" . clipboard-kill-ring-save)     ; paste into OS clipboard
   '("N" . set-mark-command)						 ; set mark
   '("n" . consult-mark)								 ; find marks
   '("a" . consult-imenu)								 ; all symbols picker
   '("f" . consult-line)								 ; find inside file
	 '("u" . meow-comment)								 ; uncomment/comment
	 '("s" . puni-wrap-round)
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
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("o" . meow-open-below)
   '("w" . meow-back-word)
   '("D" . meow-back-symbol)
   '("c" . meow-change)
   '("s" . meow-delete)
	 '("S" . (lambda () (interactive) (delete-char 1)))
   ;;'("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("F" . meow-next-symbol)
   ;;'("r" . meow-find)
   '("r" . meow-change-char)
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
   '("A" . meow-block)
   '("O" . meow-to-block)
   '("P" . meow-yank) ; yank from kill ring
   '("q" . meow-quit)
   '("Q" . consult-goto-line)
   '("R" . meow-replace)
   '("B" . meow-swap-grab)
   '("d" . meow-kill)
   '("t" . meow-till)
   '("U" . meow-undo)
   ;'("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("f" . meow-mark-word)
   '("E" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save) ; paste into kill ring
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<" . indent-rigidly-left-to-tab-stop)
   '(">" . indent-rigidly-right-to-tab-stop)
	 '("`" . delete-other-windows)
	 '("~" . delete-window)
	 '("D" . puni-kill-line)
	 '("C-h" . puni-slurp-forward)
	 '("C-l" . puni-barf-forward)
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
				(bg-mode-line-active "#111")
        (fg-mode-line-active fg-main)
        (border-mode-line-active unspecified)
        (border-mode-line-inactive unspecified)
				(bg-region bg-ochre) 
        (fg-region unspecified)))


(load-theme 'modus-vivendi t)

;; dired settings
(use-package dired
	:ensure nil
	:config
		(define-key dired-mode-map (kbd "h") #'dired-up-directory)
		(define-key dired-mode-map (kbd "l") #'dired-find-file)
		(define-key dired-mode-map (kbd "`") #'delete-other-windows)
		(define-key dired-mode-map (kbd "a") #'dired-create-empty-file)
		(define-key dired-mode-map (kbd "A") #'dired-create-directory)
		(define-key dired-mode-map (kbd "d") #'dired-do-delete)
		(define-key dired-mode-map (kbd "c") #'dired-do-copy)
		(define-key dired-mode-map (kbd "r") #'dired-do-rename))
(setf dired-kill-when-opening-new-dired-buffer t)

;; lsp settings, if autocomplete will lag
;; (fset #'jsonrpc--log-event #'ignore)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


