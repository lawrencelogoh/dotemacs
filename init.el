;; DO NOT EDIT THIS FILE
;; If you want to make any changes, make it in config.org
;; You will be prompted to tangle the file into init.el after saving
;; To reload the configuration use C-c r

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq straight-vc-git-default-clone-depth 1)
(setq straight-use-package-by-default t)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package magit)
(use-package reformatter)
(use-package markdown-mode)
(use-package corfu)
(use-package olivetti)
(use-package toc-org)
(use-package org-tree-slide) ; for turning org documents into slideshows
(use-package htmlize)
(use-package emmet-mode)
(use-package go-mode)
(use-package ledger-mode) ; for managing finances with ledger
(use-package web-mode)
(use-package rjsx-mode)
(use-package svelte-mode)
(use-package yaml-mode)
(use-package haskell-mode)
(use-package glsl-mode)
(use-package nerd-icons) ;; vanity
(use-package nerd-icons-dired) ;; vanity
(use-package wakatime-mode) ;; vanity
(use-package ob-mermaid) ;; For using mermaid in org
(use-package weblorg)
(use-package tuareg)
(use-package yasnippet)
(use-package treesit-auto)
;; (use-package meow)
(use-package jinja2-mode)
(use-package deadgrep)
(use-package nix-ts-mode)
(use-package flymake-eslint)
(use-package auctex)

;; Speed up startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold 800000
					 gc-cons-percentage 0.1)))

(add-hook 'after-init-hook 'org-agenda-list)

(add-hook 'dired-mode-hook #'nerd-icons-dired-mode) ;; pretty icons for dired


;; set defaults I like
(setq inhibit-startup-message t
      ring-bell-function 'ignore
      initial-scratch-message (message ";; Emacs loaded in %s.\n\n" (emacs-init-time))
      scroll-conservatively most-positive-fixnum
      org-startup-folded t)

(setq warning-minimum-level :error)


(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(pixel-scroll-precision-mode t)
(global-auto-revert-mode 1)
(setq auto-revert-use-notify nil)

;; midnight-mode
(midnight-mode 1) 
;; Change yes or no prompt to y or n
(fset 'yes-or-no-p 'y-or-n-p)

 ;; ido
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

;; Meow config
;; (defun meow-setup ()
;;   (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
;;   (meow-motion-overwrite-define-key
;;    '("j" . meow-next)
;;    '("k" . meow-prev)
;;    '("<escape>" . ignore))
;;   (meow-leader-define-key
;;    ;; SPC j/k will run the original command in MOTION state.
;;    '("j" . "H-j")
;;    '("k" . "H-k")
;;    ;; Use SPC (0-9) for digit arguments.
;;    '("1" . meow-digit-argument)
;;    '("2" . meow-digit-argument)
;;    '("3" . meow-digit-argument)
;;    '("4" . meow-digit-argument)
;;    '("5" . meow-digit-argument)
;;    '("6" . meow-digit-argument)
;;    '("7" . meow-digit-argument)
;;    '("8" . meow-digit-argument)
;;    '("9" . meow-digit-argument)
;;    '("0" . meow-digit-argument)
;;    '("/" . meow-keypad-describe-key)
;;    '("?" . meow-cheatsheet))
;;   (meow-normal-define-key
;;    '("0" . meow-expand-0)
;;    '("9" . meow-expand-9)
;;    '("8" . meow-expand-8)
;;    '("7" . meow-expand-7)
;;    '("6" . meow-expand-6)
;;    '("5" . meow-expand-5)
;;    '("4" . meow-expand-4)
;;    '("3" . meow-expand-3)
;;    '("2" . meow-expand-2)
;;    '("1" . meow-expand-1)
;;    '("-" . negative-argument)
;;    '(";" . meow-reverse)
;;    '("," . meow-inner-of-thing)
;;    '("." . meow-bounds-of-thing)
;;    '("[" . meow-beginning-of-thing)
;;    '("]" . meow-end-of-thing)
;;    '("a" . meow-append)
;;    '("A" . meow-open-below)
;;    '("b" . meow-back-word)
;;    '("B" . meow-back-symbol)
;;    '("c" . meow-change)
;;    '("d" . meow-delete)
;;    '("D" . meow-backward-delete)
;;    '("e" . meow-next-word)
;;    '("E" . meow-next-symbol)
;;    '("f" . meow-find)
;;    '("g" . meow-cancel-selection)
;;    '("G" . meow-grab)
;;    '("h" . meow-left)
;;    '("H" . meow-left-expand)
;;    '("i" . meow-insert)
;;    '("I" . meow-open-above)
;;    '("j" . meow-next)
;;    '("J" . meow-next-expand)
;;    '("k" . meow-prev)
;;    '("K" . meow-prev-expand)
;;    '("l" . meow-right)
;;    '("L" . meow-right-expand)
;;    '("m" . meow-join)
;;    '("n" . meow-search)
;;    '("o" . meow-block)
;;    '("O" . meow-to-block)
;;    '("p" . meow-yank)
;;    '("q" . meow-quit)
;;    '("Q" . meow-goto-line)
;;    '("r" . meow-replace)
;;    '("R" . meow-swap-grab)
;;    '("s" . meow-kill)
;;    '("t" . meow-till)
;;    '("u" . meow-undo)
;;    '("U" . meow-undo-in-selection)
;;    '("v" . meow-visit)
;;    '("w" . meow-mark-word)
;;    '("W" . meow-mark-symbol)
;;    '("x" . meow-line)
;;    '("X" . meow-goto-line)
;;    '("y" . meow-save)
;;    '("Y" . meow-sync-grab)
;;    '("z" . meow-pop-selection)
;;    '("'" . repeat)
;;    '("<escape>" . ignore)))

;; (require 'meow)
;; (meow-setup)
;; (meow-global-mode 1)

(setq org-lowest-priority ?E)
(setq org-default-priority ?E)

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
	 "\n* %(shell-command-to-string \"date '+%d-%m-%Y'\")%i%?")	
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
(setq org-habit-graph-column 45)
(setq org-habit-show-habits-only-for-today nil)

(setq org-startup-indented t)
(setq org-indent-mode-turns-on-hiding-stars nil)
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


(setq org-latex-compiler "xelatex")
(setq org-export-allow-bind-keywords t)
(setq org-latex-pdf-process
      (list (concat "latexmk -"
                    org-latex-compiler 
                    " -shell-escape  -recorder -synctex=1 -bibtex-cond %b")))

(setq org-latex-listings t)

(setq org-latex-default-packages-alist
      '(("" "graphicx" t)
        ("" "grffile" t)
        ("" "longtable" nil)
        ("" "wrapfig" nil)
        ("" "rotating" nil)
        ("normalem" "ulem" t)
        ("" "amsmath" t)
        ("" "textcomp" t)
        ("" "amssymb" t)
        ("" "capt-of" nil)
        ("" "hyperref" nil)))

(setq org-latex-classes
'(("article"
"\\RequirePackage{fix-cm}
\\PassOptionsToPackage{svgnames}{xcolor}
\\documentclass[11pt]{article}
\\usepackage{fontspec}
\\setmainfont{Inter}
\\setsansfont[Scale=MatchLowercase]{Fira Sans}
\\setmonofont[Scale=MatchLowercase]{Fira Mono}
\\usepackage{sectsty}
\\allsectionsfont{\\sffamily}
\\usepackage{enumitem}
\\setlist[description]{style=unboxed,font=\\sffamily\\bfseries}
\\usepackage{listings}
\\lstset{frame=single,aboveskip=1em,
	framesep=.5em,backgroundcolor=\\color{AliceBlue},
	rulecolor=\\color{LightSteelBlue},framerule=1pt}
\\usepackage{xcolor}
\\newcommand\\basicdefault[1]{\\scriptsize\\color{Black}\\ttfamily#1}
\\lstset{basicstyle=\\basicdefault{\\spaceskip1em}}
\\lstset{literate=
	    {§}{{\\S}}1
	    {©}{{\\raisebox{.125ex}{\\copyright}\\enspace}}1
	    {«}{{\\guillemotleft}}1
	    {»}{{\\guillemotright}}1
	    {Á}{{\\'A}}1
	    {Ä}{{\\\"A}}1
	    {É}{{\\'E}}1
	    {Í}{{\\'I}}1
	    {Ó}{{\\'O}}1
	    {Ö}{{\\\"O}}1
	    {Ú}{{\\'U}}1
	    {Ü}{{\\\"U}}1
	    {ß}{{\\ss}}2
	    {à}{{\\`a}}1
	    {á}{{\\'a}}1
	    {ä}{{\\\"a}}1
	    {é}{{\\'e}}1
	    {í}{{\\'i}}1
	    {ó}{{\\'o}}1
	    {ö}{{\\\"o}}1
	    {ú}{{\\'u}}1
	    {ü}{{\\\"u}}1
	    {¹}{{\\textsuperscript1}}1
            {²}{{\\textsuperscript2}}1
            {³}{{\\textsuperscript3}}1
	    {ı}{{\\i}}1
	    {—}{{---}}1
	    {’}{{'}}1
	    {…}{{\\dots}}1
            {⮠}{{$\\hookleftarrow$}}1
	    {␣}{{\\textvisiblespace}}1,
	    keywordstyle=\\color{DarkGreen}\\bfseries,
	    identifierstyle=\\color{DarkRed},
	    commentstyle=\\color{Gray}\\upshape,
	    stringstyle=\\color{DarkBlue}\\upshape,
	    emphstyle=\\color{Chocolate}\\upshape,
	    showstringspaces=false,
	    columns=fullflexible,
	    keepspaces=true}
\\usepackage[a4paper,margin=1in,left=1.5in,right=1.5in]{geometry}
\\usepackage{parskip}
\\makeatletter
\\renewcommand{\\maketitle}{%
  \\begingroup\\parindent0pt
  \\sffamily
  \\Huge{\\bfseries\\@title}\\par\\bigskip
  \\LARGE{\\bfseries\\@author}\\par\\medskip
  \\normalsize\\@date\\par\\bigskip
  \\endgroup\\@afterindentfalse\\@afterheading}
\\makeatother
[DEFAULT-PACKAGES]
\\hypersetup{linkcolor=Blue,urlcolor=DarkBlue,
  citecolor=DarkRed,colorlinks=true}
\\AtBeginDocument{\\renewcommand{\\UrlFont}{\\ttfamily}}
[PACKAGES]
[EXTRA]"
("\\section{%s}" . "\\section*{%s}")
("\\subsection{%s}" . "\\subsection*{%s}")
("\\subsubsection{%s}" . "\\subsubsection*{%s}")
("\\paragraph{%s}" . "\\paragraph*{%s}")
("\\subparagraph{%s}" . "\\subparagraph*{%s}"))

("report" "\\documentclass[11pt]{report}"
("\\part{%s}" . "\\part*{%s}")
("\\chapter{%s}" . "\\chapter*{%s}")
("\\section{%s}" . "\\section*{%s}")
("\\subsection{%s}" . "\\subsection*{%s}")
("\\subsubsection{%s}" . "\\subsubsection*{%s}"))

("book" "\\documentclass[11pt]{book}"
("\\part{%s}" . "\\part*{%s}")
("\\chapter{%s}" . "\\chapter*{%s}")
("\\section{%s}" . "\\section*{%s}")
("\\subsection{%s}" . "\\subsection*{%s}")
("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

(setq org-src-fontify-natively t)


    

;; Wrap text at 72 columns
(add-hook 'text-mode-hook #'auto-fill-mode)
(setq-default fill-column 72)

;; Treesitter
(global-treesit-auto-mode)
(setq treesit-auto-install 'prompt)
(setq treesit-font-lock-level 4)

(setq treesit-language-source-alist
      '((typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
        (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
        (python . ("https://github.com/tree-sitter/tree-sitter-python"))
	  (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
	  (haskell . ("https://github.com/tree-sitter/tree-sitter-haskell"))
	  ))

(dolist (source treesit-language-source-alist)
  (unless (treesit-ready-p (car source))
    (treesit-install-language-grammar (car source))))

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\.hs\\'" . haskell-ts-mode))
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-ts-mode))



;; Wakatime
(global-wakatime-mode)
;; Make eglot faster with tsserver
(fset #'jsonrpc--log-event #'ignore)
;; corfu
(setq corfu-auto t)
(setq corfu-auto-delay 0)
(setq tcorfu-auto-prefix 1)

;; code blocks
(setq org-confirm-babel-evaluate nil)
(setq org-edit-src-content-indentation 0)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((mermaid . t) (python . t) (shell . t) (C . t) (js . t)))

;; projects
;; Replace shell with ansi-term
(defun project-ansi-term ()
  "Start an ansi-term in the current project's root directory."
  (interactive)
  (let* ((default-directory (project-root (project-current t)))
         (buffer-name (format "%s-term" (project-name (project-current t))))
         (existing-buffer (get-buffer buffer-name)))
    (if existing-buffer
        (switch-to-buffer existing-buffer)
      (ansi-term (getenv "SHELL") buffer-name))))

;; Advice to override project-shell with ansi-term
(defun project-shell-override (orig-fun &rest args)
  "Advice to replace project-shell with ansi-term."
  (project-ansi-term))

;; Apply the advice to project-shell
(advice-add 'project-shell :around #'project-shell-override)

;; Formatting modes
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

(reformatter-define tsx-ts-format
  :program "prettier"
  :args '("--write" "--parser" "babel-flow")
  :lighter " TSF")

(defvar my-format-modes '("go" "python" "js" "tsx-ts"))

(dolist (mode my-format-modes)
  (add-hook (intern (concat mode "-mode-hook"))
            (intern (concat mode "-format-on-save-mode"))))


;; general hooks
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(add-hook 'prog-mode-hook 'eglot-ensure)
(add-hook 'prog-mode-hook 'corfu-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(add-hook 'web-mode-hook  'emmet-mode)
(add-hook 'rjsx-mode-hook  'emmet-mode)

(setq ledger-reconcile-default-commodity "GHS")

(defun config-reload ()
  (interactive)
  (load-file user-init-file)) 

(defun zet-search ()
  "Search through Zettelkasten notes in ~/zet using deadgrep"
  (interactive)
  (let ((zet-dir (expand-file-name "~/zet")))

    ;; Check if directory exists
    (unless (file-directory-p zet-dir)
      (error "Zettelkasten directory ~/zet does not exist"))
    
    ;; Check if ripgrep is installed
    (unless (executable-find "rg")
      (error "ripgrep (rg) is not installed. Please install it first"))
    
    ;; Set the extra arguments before creating the search buffer
    (setq-local deadgrep-extra-arguments 
                '("--glob" "!LICENSE" 
                  "--glob" "!README.md"))
    
    (let* ((default-directory zet-dir)
           (search-term (read-string "Search zettelkasten: ")))
      ;; Ensure deadgrep-project-root is set
      (setq-local deadgrep-project-root default-directory)
      (deadgrep search-term))))

(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c t") 'ansi-term)
(global-set-key (kbd "C-c r") 'config-reload)
(global-set-key (kbd "C-c z") 'zet-search)
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
