;;; Nifty visual bell
(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-foreground 'mode-line)))
          (set-face-foreground 'mode-line "#F2804F")
          (run-with-idle-timer 0.1 nil
                               (lambda (fg)
                                 (set-face-foreground 'mode-line fg))
                               orig-fg))))

;;; pretty prompt
(setq eshell-prompt-regexp "^[^#$\n]*[#$] "
      eshell-prompt-function
      (lambda nil
        (concat
	 (if (string= (eshell/pwd) (getenv "HOME"))
	     "~" (eshell/basename (eshell/pwd))) " "
             (if (= (user-uid) 0) "# " "% "))))


;;;; Hooks
(defun my/mail-mode-hook ()
  "Quality-of-life stuff for mail"
  (auto-fill-mode)
  (mail-abbrevs-setup)
  (font-lock-add-keywords
   nil
   '(("^[ \t]*>[ \t]*>[ \t]*>.*$"
      (0 'mail-multiply-quoted-text-face))
     ("^[ \t]*>[ \t]*>.*$"
      (0 'mail-double-quoted-text-face)))))

(defun my/prog-mode-hook ()
  "Hooks for all prog modes in general"
  (require 'auto-complete)
  (rainbow-delimiters-mode)
  ;; (column-marker-1 80)
  ;; (column-marker-2 100)
  ;; (linum-mode)
  (show-paren-mode)
  (prettify-symbols-mode))

(defun my/text-mode-hook ()
  "Hooks for viewing and writing plain text"
  ;; (column-marker-1 80)
  (auto-fill-mode)
  (visual-line-mode))

(defun my/racer-mode-hook ()
  "Hooks for racer-mode.el of Rust"
  (eldoc-mode)
  (company-mode)
  (local-set-key [tab] #'company-indent-or-complete-common)
  (ac-racer-setup))


(defun my/c-mode-hook ()
  "C stuff"
  ;; Most stuff you'd see here is already defined in variables.el
  (page-break-lines-mode))

(defun my/java-mode-hook ()
  "Exceptions for (cc-mode) etc for Java and Java-like languages"
  (setq indent-tabs-mode t
        c-basic-offset 4
        tab-width 4)
  (page-break-lines-mode))

(defun my/lisp-mode-hook ( )
  "Collection of Lisp hooks, including Scheme ones"
  (setq indent-tabs-mode nil)
  ;; (eldoc-mode)
  ;; (slime-mode)
  (page-break-lines-mode)
  (paredit-mode))

(defun my/scheme-mode-hook ()
  "chikun"
  (my/lisp-mode-hook)
  (require 'chicken-scheme)
  (define-key scheme-mode-map (kbd "C-M-?") 'chicken-show-help)
  (setup-chicken-scheme))

(defun my/makefile-mode-hook ()
  "fucking tabs"
  (setq indent-tabs-mode t))

(defun my/caml-mode-hook ()
  "Stuff for OCaml - doesn't work because tuareg sucks"
  (setq merlin-command 'opam)
  (merlin-mode)
  (merlin-eldoc-setup)
  (utop-minor-mode)
  (electric-indent-mode 0))

(defun my/python-mode-hook ()
  "Cleaning indentation for Python"
  (setq indent-tabs-mode nil
        tab-width 4))

(defun my/tex-mode-hook ()
  "Bits and bobs for LaTeX"
  (setq indent-tabs-mode nil))

(defun my/haskell-mode-hook ()
  "Nothing much here yet"
  (setq indent-tabs-mode nil))

(defun my/rust-mode-hook ()
  "Helpful modes for autocomplete, also style stuff"
  (setq indent-tabs-mode nil
        tab-width 4)
  (local-set-key (kbd "C-c TAB") #'rust-format-buffer)
  (cargo-minor-mode)
  (racer-mode)) ; see above

(defun my/sh-mode-hook ()
  "heck"
  (setq indent-tabs-mode nil))

(defun my/sgml-mode-hook ()
  "HTML stuff"
  (setq comment-continue " ")
  (setq indent-tabs-mode nil)
  (page-break-lines-mode))

(defun my/nxml-mode-hook ()
  "fuck --!"
  (setq comment-continue " ")
  (setq indent-tabs-mode nil))


;;;; Functions
(defun toggle-transparency ()
  "True transparency"
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(91 . 90) '(100 . 100)))))

(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

(defun sort-words (reverse beg end)
  "Sort words in region alphabetically, in REVERSE if negative.
    Prefixed with negative \\[universal-argument], sorts in reverse.
  
    The variable `sort-fold-case' determines whether alphabetic case
    affects the sort order.
  
    See `sort-regexp-fields'."
  (interactive "*P\nr")
  (sort-regexp-fields reverse "\\w+" "\\&" beg end))
