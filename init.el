;; DO NOT EDIT THIS FILE
;; If you want to make any changes, make it in config.org
;; You will be prompted to tangle the file into init.el after saving
;; To reload the configuration use C-c r

;; Speed up startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold 800000
					 gc-cons-percentage 0.1)))

(add-hook 'after-init-hook 'org-agenda-list)

;; set defaults I like
(setq inhibit-startup-message t
      ring-bell-function 'ignore
      initial-scratch-message (message ";; Emacs loaded in %s.\n\n" (emacs-init-time))
      scroll-conservatively most-positive-fixnum
      org-startup-folded t)

(tool-bar-mode -1)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(pixel-scroll-precision-mode t)
(global-auto-revert-mode 1)

;; midnight-mode
(midnight-mode 1) 
;; Change yes or no prompt to y or n
(fset 'yes-or-no-p 'y-or-n-p)

;; ;; ido
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (ido-mode 1)

;; dired
(put 'dired-find-alternate-file 'disabled nil)
(add-hook 'dired-mode-hook 'dired-hide-details-mode)

;; font
(add-to-list 'default-frame-alist
	       '(font . "Hack-14"))
;; theme
(custom-set-faces
 `(fringe ((t (:background unspecified)))))

(load-theme 'modus-vivendi)

;; create backups and autosaves dirs if they don't exist
(setq backups (concat (getenv "XDG_DATA_HOME") "/emacs/backups/"))
(setq autosaves (concat (getenv "XDG_DATA_HOME") "/emacs/autosaves/"))

(unless (and (file-exists-p backups)
	     (file-exists-p autosaves))
  (make-directory backups t)
  (make-directory autosaves t))


;; Move backups and autosaves to XDG_DATA_HOME
(setq backup-directory-alist `(("." . ,backups))
      backup-by-copying t    
      version-control t      
      delete-old-versions t  
      kept-new-versions 5   
      kept-old-versions 2    
      )

(setq auto-save-file-name-transforms
  `((".*" ,autosaves t)))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package magit)
(use-package reformatter)
(use-package markdown-mode)
(use-package olivetti)
(use-package toc-org)
(use-package org-tree-slide) ; for turning org documents into slideshows
(use-package htmlize)
(use-package emmet-mode)
(use-package go-mode)
(use-package ledger-mode) ; for managing finances with ledger

(setq org-todo-keywords
	'((sequence "TODO(t)" "DOING(x)" "WAITING(w)" "|" "DONE(d)" )))

  (setq org-todo-keyword-faces
	'(("TODO" . "#a4202a")
	  ("DOING" . org-warning)
	  ("WAITING" . "#dbbe5f")
	  ))
;; Colors are from https://protesilaos.com/emacs/modus-themes-colors
(setq org-log-into-drawer t)

;; Capture
(setq org-capture-bookmark nil)
(setq org-directory "~/lms/")
(setq org-default-notes-file (concat org-directory "in.org"))

(setq org-capture-templates
      '(("n" "next action" entry (file+headline "~/lms/actions.org" "Tasks")
	 "** TODO %?\n  %i\n")
	("i" "In box" entry (file+headline org-default-notes-file "In basket")
	 "** %?\n  %i\n")
	("a" "agenda" entry (file+headline "~/lms/cal.org" "Calendar")
	 "** TODO %?\n  %i\n")
	("j" "journal entry" entry (file "~/lms/journal.org")
	 "\n* %(shell-command-to-string \"date '+%d-%m-%Y'\") %i %?")	
	("z" "zettel" entry
	 (file (lambda ()
		 (concat "~/zet/" (format-time-string "%Y") "/" (format-time-string "%s") ".org" )))
	 "\n* %i %?")
	))

;; Agenda
(setq org-agenda-files '("~/lms/cal.org" "~/lms/work.org"))
(setq org-agenda-span 1)

;; Habits
(add-to-list 'org-modules 'org-habit t)
(setq org-habit-graph-column 40)
(setq org-habit-show-habits-only-for-today nil)

;; spellcheck
(add-hook 'text-mode-hook 'flyspell-mode)

;; toc-org
(if (require 'toc-org nil t)
    (progn
      (add-hook 'org-mode-hook 'toc-org-mode)))

(with-eval-after-load "org-tree-slide"
  (define-key org-tree-slide-mode-map (kbd "<f9>") 'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "<f10>") 'org-tree-slide-move-next-tree)
  )

(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-src-fontify-natively t)

;; Wrap text at 72 columns
(add-hook 'text-mode-hook #'auto-fill-mode)
(setq-default fill-column 72)

;; formatting

;; code blocks
(setq org-confirm-babel-evaluate nil)
(setq org-edit-src-content-indentation 0)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t) (shell . t) (C . t) (js . t)))

;; general hooks
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)


;; formatting
(reformatter-define go-format
  :program "gofmt"
  :lighter " GF")


(reformatter-define python-format
  :program "black"
  :args '("-")
  :lighter " PYF")

(reformatter-define js-format
  :program "prettier"
  :args '("--write" "--parser" "babel-flow")
  :lighter " JSF")

;; format hooks
(defvar my-format-modes '("go" "python" "js"))

(dolist (mode my-format-modes)
  (add-hook (intern (concat mode "-mode-hook"))
            (intern (concat mode "-format-on-save-mode"))))

(setq ledger-reconcile-default-commodity "GHS")

(defun config-reload ()
      (interactive)
      (load-file user-init-file)
      )

(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c t") 'ansi-term)
(global-set-key (kbd "C-c r") 'config-reload)
(global-set-key (kbd "M-<f2>") 'modus-themes-toggle) ; toggle light and dark modus themes
(global-set-key (kbd "C-z") 'replace-string)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "<f8>") 'org-tree-slide-mode)

(add-to-list 'safe-local-variable-values '(eval add-hook 'after-save-hook
	   (lambda nil
	     (if
		 (y-or-n-p "Tangle?")
		 (org-babel-tangle)))
	   nil t))
