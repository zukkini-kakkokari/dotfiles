(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
	 '(modus-themes racket-mode parinfer-rust-mode cider clojure-mode consult corfu marginalia orderless vterm rainbow-mode rainbow-delimiters beacon vertico meow)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Iosevka Nerd Font Mono" :foundry "UKWN" :slant normal :weight regular :height 218 :width normal)))))
;; change default settings
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(setq-default tab-width 2)
(load-theme 'wheatgrass t)
(save-place-mode 1) ; save cursor pos if you close emacs
(global-auto-revert-mode 1) ; auto update file if it changes

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

; term enulator
(use-package vterm
  :config
  (setq shell-file-name "/bin/bash"
	vterm-max-scrollback 5000))



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
  ;(corfu-popupinfo-mode)
  (corfu-history-mode)
  (corfu-echo-mode)
  )
(savehist-mode 1) ; for history mode working
(add-to-list 'savehist-additional-variables 'corfu-history)
(setq corfu-echo-delay 0.0)
;;
;; STOP COMPLETION SNIPPET



; activate commands to allow half-page scroll
(autoload 'View-scroll-half-page-forward "view")
(autoload 'View-scroll-half-page-backward "view")

;; meow keys
(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; Custom SPC commands, but x / h / c / m / g is reserved
   '("j" . consult-buffer) ; find buffer
   '("b" . kill-buffer) ; bakuretsu buffer
   '("s" . save-buffer)
   '("e" . eval-defun)
   '("o" . find-file) ; open local file
	 '("O" . consult-fd) ; open global file
   '("p" . consult-yank-from-kill-ring) ; open kill ring
   '("N" . set-mark-command) ; set mark
   '("n" . consult-mark) ; find marks
   '("a" . consult-imenu) ; all symbols picker
   '("f" . consult-line) ; find inside file
	 '("u" . meow-comment) ; uncomment/comment
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
(add-hook 'racket-mode-hook #'racket-xp-mode) ; locale auto-complete
