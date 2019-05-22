;;; Init.el --- init file created from multiple sources
;;; Commentary:
;;; Init file created by David Ochoa combining other multiple files
;;; Code:

(require 'package)
(setq package-archives
      '(("melpa-stable" . "http://stable.melpa.org/packages/")
	("melpa" . "http://melpa.org/packages/"))
      package-archive-priorities
      '(("melpa-stable" . 10)
	("melpa"        . 0)))

;; pin packages
(setq package-pinned-packages
      '((ess              . "melpa")
	(monokai          . "melpa")))

(package-initialize)

;; (setq load-path
;;       (append '("~/.emacs.d/polymode/"  "~/.emacs.d/poly-markdown/"  "~/.emacs.d/poly-R/"  "~/.emacs.d/poly-noweb/")
;;               load-path))

(defvar my-packages '(
		      ;;auto-complete
		      company
                      idle-highlight-mode
                      ido-completing-read+
                      flx-ido
                      markdown-mode
		      ess
                      ;; flycheck
                      ;; flycheck-pos-tip
		      polymode
		      poly-markdown
		      poly-R
		      poly-noweb
                      magit
                      smex
                      scpaste
                      ;; textmate
		      elpy
		      ;; adaptive-wrap
                      volatile-highlights
                      yaml-mode
                      ;; rainbow-mode
                      fill-column-indicator
                      monokai-theme
		      ;; noctilux-theme
		      multi-line
		      smooth-scrolling
                      yasnippet
                      r-autoyas
                      expand-region
                      coffee-mode
                      web-mode
		      smart-mode-line
                      ))

(when (not package-archive-contents)
  (package-refresh-contents))

(let ((default-directory "~/.emacs.d/elpa/"))
    (normal-top-level-add-to-load-path '("."))
    (normal-top-level-add-subdirs-to-load-path))

;; install the missing packages
(dolist (package my-packages)
  (unless (package-installed-p package)
    (package-install package)))

;; (require 'ess-site)
;; (require 'ess-r-mode)

;; (setq redisplay-dont-pause t)
;; (setq scroll-margin 1
;;       scroll-conservatively 0
;;       scroll-up-aggressively 0.01
;;       scroll-down-aggressively 0.01)
;; (setq-default scroll-up-aggressively 0.01
;; 	      scroll-down-aggressively 0.01)

(load-theme 'monokai t)

;;mode line
;;(setq sml/no-confirm-theme t)
;;(sml/setup)
;;(setq sml/theme 'dark)

;; ; Font
;; set all windows (emacs's "frame") to use font DejaVu Sans Mono
(set-frame-font "SF Mono-12" t t)
(when (member "Symbola" (font-family-list))
  (set-fontset-font t 'unicode "Symbola" nil 'prepend))

;; no toolbar
(tool-bar-mode -1)

;; mark fill column
;; (require 'fill-column-indicator)

;; Better looking terminal windows
;; Space after line numbers
(when (not(display-graphic-p))
  (add-hook 'window-configuration-change-hook
	    (lambda () (setq linum-format " %d "))))

;; Vertical line
(when (not(display-graphic-p))
  (set-display-table-slot standard-display-table 'vertical-border ?│))

;; Turn off menu bar
(when (not(display-graphic-p)) (menu-bar-mode -1))

; Desactivate alarm
(setq ring-bell-function 'ignore)

;; Emacs will not automatically add new lines (stop scrolling at end of file)
(setq next-line-add-newlines nil)

;; Enable mouse support
(xterm-mouse-mode)
(unless window-system
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

; Prevent functions to access the clipboard
;; (setq x-select-enable-clipboard nil)

; Yes or No in one character
(defalias 'yes-or-no-p 'y-or-n-p)

; Get rid of temporary files
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;smex provides the history on top of M-x
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
					; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


;; (require 'exec-path-from-shell)
;; (when (memq window-system '(mac ns))
;;       (exec-path-from-shell-initialize))

;; (textmate-mode)

;; Highlights volatile actitions such as paste
(require 'volatile-highlights)
(volatile-highlights-mode t)

; magit
(require 'magit)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; yaml mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; ido mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(defun my-common-hook ()
  ;; my customizations for all of c-mode and related modes
  (when (display-graphic-p) (fci-mode nil))
  (linum-mode 1)
  ;; (rainbow-mode 1) ;; Rainbow colors
 )

; Load hook
(add-hook 'prog-mode-hook 'my-common-hook)

;; Anything that writes to the buffer while the region is active will overwrite
;; it, including paste, but also simply typing something or hitting backspace
(delete-selection-mode 1)

; Autocomplete
;; (require 'auto-complete-config)
;; (ac-config-default)
;; (ac-linum-workaround)
;; (setq ess-tab-complete-in-script t)

;; Company mode
(add-hook 'after-init-hook 'global-company-mode)

;; Electric pair, indentation, layout
(electric-indent-mode 1)
(electric-pair-mode 1)
(electric-layout-mode 1)

;; Indent code when pasting
(dolist (command '(yank yank-pop))
   (eval `(defadvice ,command (after indent-region activate)
            (and (not current-prefix-arg)
                 (member major-mode '(emacs-lisp-mode lisp-mode
                                                      clojure-mode    scheme-mode
                                                      haskell-mode    ruby-mode
                                                      rspec-mode      python-mode
                                                      c-mode          c++-mode
                                                      objc-mode       latex-mode
                                                      plain-tex-mode))
                 (let ((mark-even-if-inactive transient-mark-mode))
                   (indent-region (region-beginning) (region-end) nil))))))


; spell checker
(setq flyspell-issue-welcome-flag nil)
(if (eq system-type 'darwin)
    (setq-default ispell-program-name "/usr/local/bin/aspell")
  (setq-default ispell-program-name "/usr/bin/aspell"))
(setq-default ispell-list-command "list")


;; Allows the right alt key to work as alt
(setq ns-right-alternate-modifier nil)

; Some keybindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key [C-tab] 'other-window) ;Change windows

;; copy and paste from emacs to osx
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

; Markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Python
;; (setq python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "--simple-prompt -i")
(elpy-enable)
;; (elpy-use-ipython)
(setq elpy-rpc-python-command "python3")
(setq python-shell-interpreter "python3")

; Ruby
(add-hook 'ruby-mode-hook
          (lambda ()
            (autopair-mode)))

(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile" . ruby-mode))

; YAML mode
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; Load speedbar in the same frame, do not refresh it
;; automatically
;; (require 'sr-speedbar)
;; (add-hook 'speedbar-mode-hook (lambda () (linum-mode -1)))
;; ;; (sr-speedbar-open)
;; (sr-speedbar-refresh-turn-off)

;; Polymode
;;; R modes
(require 'polymode)
(require 'poly-R)
(require 'poly-markdown)
(require 'poly-noweb)

;; (autoload 'poly-markdown-mode "poly-markdown-mode"
;;   "Major mode for editing R-Markdown files" t)
;; (add-to-list 'auto-mode-alist '("\\.[Rr]md" . poly-markdown+r-mode))
;; (add-to-list 'auto-mode-alist '("\\.[Rr]md" . poly-markdown-mode))
;; (add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))

;; Let you use markdown buffer easily
;; (setq ess-nuke-trailing-whitespace-p nil) 

;; Lintrs
;; (setq flycheck-lintr-linters "with_defaults(camel_case_linter=NULL, infix_spaces_linter=NULL, line_length_linter=lintr::line_length_linter(120))")


;; for ESS scrolling etc.
(setq comint-prompt-read-only t)
;; (setq comint-scroll-to-bottom-on-input t)
;; (setq comint-scroll-to-bottom-on-output t)
;; (setq comint-move-point-for-output t)

;; keybinding for magrittr pipe
;; (global-set-key (kbd "C-S-m") (lambda () (interactive) (insert "%>%")))

;; Activate flycheck
;; (add-hook 'after-init-hook #'global-flycheck-mode)
;; '(flycheck-lintr-caching nil)

;; (when (require 'flycheck nil t)
;;   (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;   (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Activate pos-tip
;; (with-eval-after-load 'flycheck
;;   (flycheck-pos-tip-mode))

; Variables I set up from within emacs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compilation-message-face (quote default))
 '(custom-safe-themes
   (quote
    ("a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" "6de7c03d614033c0403657409313d5f01202361e35490a3404e33e46663c2596" "ed317c0a3387be628a48c4bbdb316b4fa645a414838149069210b66dd521733f" "938d8c186c4cb9ec4a8d8bc159285e0d0f07bad46edf20aa469a89d0d2a586ea" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "f78de13274781fbb6b01afd43327a4535438ebaeec91d93ebdbba1e3fba34d3c" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(ess-R-font-lock-keywords
   (quote
    ((ess-R-fl-keyword:modifiers . t)
     (ess-R-fl-keyword:fun-defs . t)
     (ess-R-fl-keyword:keywords . t)
     (ess-R-fl-keyword:assign-ops . t)
     (ess-R-fl-keyword:constants . t)
     (ess-fl-keyword:fun-calls . t)
     (ess-fl-keyword:numbers . t)
     (ess-R-fl-keyword:F&T . t))))
 '(fci-rule-column 120)
 '(global-linum-mode nil)
 '(inferior-ess-r-font-lock-keywords
   (quote
    ((ess-S-fl-keyword:prompt n\. t)
     (ess-R-fl-keyword:modifiers . t)
     (ess-R-fl-keyword:fun-defs . t)
     (ess-R-fl-keyword:keywords . t)
     (ess-R-fl-keyword:assign-ops . t)
     (ess-R-fl-keyword:constants . t)
     (ess-R-fl-keyword:messages . t)
     (ess-fl-keyword:matrix-labels . t)
     (ess-fl-keyword:fun-calls . t)
     (ess-fl-keyword:numbers . t)
     (ess-R-fl-keyword:F&T))))
 '(inhibit-startup-screen t)
 '(initial-scratch-message "")
 '(linum-delay t)
 '(linum-eager t)
 '(linum-format " %4d")
 '(magit-diff-use-overlays nil)
 '(package-selected-packages
   (quote
    (powerline smart-mode-line web-mode coffee-mode expand-region r-autoyas smooth-scrolling multi-line monokai-theme fill-column-indicator yaml-mode volatile-highlights elpy scpaste smex magit poly-R poly-markdown polymode ess markdown-mode flx-ido ido-completing-read+ idle-highlight-mode company)))
 '(show-paren-mode t))

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))


;; Start R in the working directory by default
(setq ess-ask-for-ess-directory nil)

(setq exec-path (cons "/usr/local/bin" exec-path))

;; (with-eval-after-load "ess-r-mode"
;; (setq ess-indent-level 4)
;; (setq ess-history-directory "~/.R/")
;; ;; (setq ess-local-process-name "R")
;; ;; see https://github.com/emacs-ess/ESS/pull/390 for ideas on how to integrate tab completion
;; ;; disable echoing input
;; (setq ess-eval-visibly 'nowait)
;; ;; Start R in the working directory by default
;; (setq ess-ask-for-ess-directory nil)
;; ;; Use tab completion
;; ;; (setq ess-tab-complete-in-script t)
;; ;; (setq ansi-color-for-comint-mode 'filter)
;; ;;(setq inferior-R-program-name "/usr/local/bin/R")
;; (setq comint-scroll-to-bottom-on-input t)
;; ;; extra ESS stuff inspired by https://github.com/gaborcsardi/dot-emacs/blob/master/.emacs
;; (ess-toggle-underscore nil)
;; (defun my-ess-execute-screen-options (foo)
;;   "cycle through windows whose major mode is inferior-ess-mode and fix width"
;;   (interactive)
;;   (setq my-windows-list (window-list))
;;   (while my-windows-list
;;     (when (with-selected-window (car my-windows-list) (string= "inferior-ess-mode" major-mode))
;;       (with-selected-window (car my-windows-list) (ess-execute-screen-options t)))
;;     (setq my-windows-list (cdr my-windows-list))))
;; (add-to-list 'window-size-change-functions 'my-ess-execute-screen-options)
;; (define-key ess-mode-map (kbd "<C-return>") 'ess-eval-region-or-function-or-paragraph-and-step)
;; ;; truncate long lines in R source files
;; (add-hook 'ess-mode-hook
;;           (lambda()
;;             ;; don't wrap long lines
;;             (toggle-truncate-lines t)
;;             (outline-minor-mode t)))

;; ; For R. The first two lines are needed *before* loading 
;; ; ess, to set indentation to two spaces
;; (setq ess-default-style 'DEFAULT)
;; (setq ess-indent-level 2)
;; (setq ess-history-directory "~/.R/")

;; ;; Adapted with one minor change from Felipe Salazar at
;; ;; http://www.emacswiki.org/emacs/EmacsSpeaksStatistics
;; (setq ess-ask-for-ess-directory nil)
;; (setq ess-local-process-name "R")
;; (setq ansi-color-for-comint-mode 'filter)
;; ;;(setq inferior-R-program-name "/usr/local/bin/R")
;; (setq comint-scroll-to-bottom-on-input t)
;; (setq comint-scroll-to-bottom-on-output t)

;; 
;; Line wrapping and position
;; From https://github.com/kjhealy/emacs-starter-kit/blob/master/starter-kit-text.org

;; (when (fboundp 'adaptive-wrap-prefix-mode)
;;   (defun my-activate-adaptive-wrap-prefix-mode ()
;;     "Toggle `visual-line-mode' and `adaptive-wrap-prefix-mode' simultaneously."
;;     (adaptive-wrap-prefix-mode (if visual-line-mode 1 -1)))
;;   (add-hook 'visual-line-mode-hook 'my-activate-adaptive-wrap-prefix-mode))
;; (global-visual-line-mode t)

;;; prefer auto-fill to visual line wrap in ESS mode
;; (add-hook 'ess-mode-hook 'turn-on-auto-fill)
;; (add-hook 'inferior-ess-mode-hook 'turn-on-auto-fill) 

;; ;;; but turn off auto-fill in tex and markdown
;; (add-hook 'markdown-mode-hook 'turn-off-auto-fill)
;; (add-hook 'latex-mode-hook 'turn-off-auto-fill)

;;; unfill paragraph
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))
(global-set-key (kbd "<f6>") 'unfill-paragraph)

(require 'multi-line)
(global-set-key (kbd "C-c d") 'multi-line)

;; smooth-scrolling 
(require 'smooth-scrolling)

;; more smooth efforts.
(setq-default 
 scroll-conservatively 0
 scroll-up-aggressively 0.01
 scroll-down-aggressively 0.01)



;; To compile closest Makefile
(require 'cl) ; If you don't have it already
(defun* get-closest-pathname (&optional (file "Makefile"))
  (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
    (expand-file-name file
		      (loop 
		       for d = default-directory then (expand-file-name ".." d)
		       if (file-exists-p (expand-file-name file d))
		       return d
		       if (equal d root)
		       return nil))))

(require 'compile)
;; (add-hook 'markdown-mode-hook (lambda () (set (make-local-variable 'compile-command) (format "make -f %s" (get-closest-pathname)))))
;; (add-hook 'ess-mode-hook (lambda () (set (make-local-variable 'compile-command) (format "make -f %s" (get-closest-pathname)))))


;; Limit buffer size
(add-to-list 'comint-output-filter-functions 'comint-truncate-buffer)

(defun my-ess-start-R ()
  (interactive)
  (or (assq 'inferior-ess-mode
            (mapcar 
              (lambda (buff) (list (buffer-local-value 'major-mode buff)))
              (buffer-list)))
   (progn
     (delete-other-windows)
     (setq w1 (selected-window))
     (setq w1name (buffer-name))
     (setq w2 (split-window w1 nil t))
     (R)
     (set-window-buffer w2 "*R*")
     (set-window-buffer w1 w1name))))

(defun my-ess-eval ()
  (interactive)
  (my-ess-start-R)
  (if (and transient-mark-mode mark-active)
      (call-interactively 'ess-eval-region)
    (call-interactively 'ess-eval-line-and-step)))

(defun my-common-hook ()
  ;; my customizations for all of c-mode and related modes
  (when (display-graphic-p) (fci-mode nil))
  (linum-mode 1)
  ;; (rainbow-mode 1) ;; Rainbow colors
  )

(add-hook 'ess-mode-hook
          '(lambda()
             ;; (local-set-key [(shift return)] 'my-ess-eval)
	     (linum-mode t) ;show line numbers
	     (when (display-graphic-p) (fci-mode nil))
	     (set (make-local-variable 'compile-command) (format "make -f %s " (get-closest-pathname)))
	     ))

(add-hook 'inferior-ess-mode-hook
          '(lambda()
             (local-set-key [up] 'comint-previous-input)
             (local-set-key [down] 'comint-next-input)))

(add-hook 'Rnw-mode-hook
          '(lambda()
             ;; (local-set-key [(shift return)] 'my-ess-eval)
	     (linum-mode t) ;show line numbers
	     (when (display-graphic-p) (fci-mode nil))
	     ))

(setq-default fill-column 120)

(add-hook 'markdown-mode-hook
	  (lambda ()
	    (linum-mode t)
	    (when (display-graphic-p) (fci-mode nil))
	    (set (make-local-variable 'compile-command) (format "make -f %s " (get-closest-pathname)))
	    ))

;; (require 'ess-site)

; does not work for if you press `M-;`, but does work for <TAB>
;; (setq ess-fancy-comments nil)
;; (setq ess-indent-level 2)
; from http://stackoverflow.com/a/25219054/2723794 thank god, ESS apparently considers function bodies to be "continued statements", which are apparently independent of indent level! sheesh
;; (setq ess-first-continued-statement-offset 2
;;       ess-continued-statement-offset 0)

;; Some keys for ESS
;; (define-key input-decode-map "\e\eOA" [(meta up)])
;; (define-key input-decode-map "\e\eOB" [(meta down)])

;; (defun my-ess-post-run-hook ()
;;   (local-set-key "\C-cw" 'ess-execute-screen-options))
;; (add-hook 'ess-post-run-hook 'my-ess-post-run-hook)

;; ???
(setq url-http-attempt-keepalives nil)

(eval-after-load "comint"
  '(progn
     (define-key comint-mode-map [up]
       'comint-previous-matching-input-from-input)
     (define-key comint-mode-map [down]
       'comint-next-matching-input-from-input)
     ;; also recommended for ESS use --
     (setq comint-scroll-to-bottom-on-output nil)
     (setq comint-scroll-show-maximum-output nil)
     ;; somewhat extreme, almost disabling writing in *R*,
     ;; *shell* buffers above prompt:
     (setq comint-scroll-to-bottom-on-input 'this)
     ))

(require 'r-autoyas)
(add-hook 'ess-mode-hook 'r-autoyas-ess-activate)

;; (defun my-ess-mode-hook ()
;;   (ess-toggle-underscore nil) ;; Do not replace _ with <-
;;   (r-autoyas-ess-activate)   ;; r-autoyas
;;   (rainbow-mode 1) ;; Rainbow colors
;; )

;; (add-hook 'ess-mode-hook 'my-ess-mode-hook)

; Save/load history of minibuffer
(savehist-mode 1)


;; ;;coffee-script
(require 'coffee-mode)

(defun coffee-custom ()
  "coffee-mode-hook"
 (set (make-local-variable 'tab-width) 2))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

(define-key coffee-mode-map [(meta r)] 'coffee-compile-buffer)
(define-key coffee-mode-map [(meta R)] 'coffee-compile-region)

(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))



;; (add-hook 'ess-mode (lambda () (add-to-list 'ac-sources 'ac-source-R)))


;; Play with window sizes
(global-set-key (kbd "s-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "s-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-C-<down>") 'shrink-window)
(global-set-key (kbd "s-C-<up>") 'enlarge-window)

;; Tramp connecting to zsh
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))

;; (defvar sanityinc/fci-mode-suppressed nil)
;; (defadvice popup-create (before suppress-fci-mode activate)
;;   "Suspend fci-mode while popups are visible"
;;   (set (make-local-variable 'sanityinc/fci-mode-suppressed) fci-mode)
;;   (when fci-mode
;;     (turn-off-fci-mode)))
;; (defadvice popup-delete (after restore-fci-mode activate)
;;   "Restore fci-mode when all popups have closed"
;;   (when (and (not popup-instances) sanityinc/fci-mode-suppressed)
;;     (setq sanityinc/fci-mode-suppressed nil)
;;     (turn-on-fci-mode)))

;;; Transparency (in standalone X11) ;;;
; from http://www.emacswiki.org/emacs/TransparentEmacs#toc1
;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
;; (set-frame-parameter (selected-frame) 'alpha '(100 85))
;; (add-to-list 'default-frame-alist '(alpha 100 85))
;; ; use C-c t to turn on/off transparency?
;; (eval-when-compile (require 'cl))
;; (defun toggle-transparency ()
;;   (interactive)
;;   (if (/=
;;        (cadr (frame-parameter nil 'alpha))
;;        100)
;;       (set-frame-parameter nil 'alpha '(100 100))
;;     (set-frame-parameter nil 'alpha '(100 85))))
;; (global-set-key (kbd "C-c t") 'toggle-transparency)

;;; Whitespace. ;;;
; Show tabs
;; (setq white-space-style '(tabs tab-mark))
; Show trailing whitespace

;;; Windowing. ;;;
; Winner mode, which makes it easy to go back/forward in window changes
; This uses "C-c left/right" to remember window stuff
;; (when (fboundp 'winner-mode)
;;      (winner-mode 1))

(require 'expand-region)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
