;;; Nifty visual bell
(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-foreground 'mode-line)))
          (set-face-foreground 'mode-line "#F2804F")
          (run-with-idle-timer 0.1 nil
                               (lambda (fg)
                                 (set-face-foreground 'mode-line fg))
                               orig-fg))))


;;;; Hooks
(defun my/mail-mode-hook ()
  "Quality-of-life stuff for mail"
  (my/text-mode-hook)
  (mail-abbrevs-setup)
  (font-lock-add-keywords
   nil
   '(("^[ \t]*>[ \t]*>[ \t]*>.*$"
      (0 'mail-multiply-quoted-text-face))
     ("^[ \t]*>[ \t]*>.*$"
      (0 'mail-double-quoted-text-face)))))

(defun my/prog-mode-hook ()
  "Hooks for all prog modes in general"
  (rainbow-delimiters-mode)
  (page-break-lines-mode)
  (column-marker-1 80)
  (column-marker-2 100)
  (yas-minor-mode)
  ;; (linum-mode)
  ;; (prettify-symbols-mode)
  (show-paren-mode)
  (setq indent-tabs-mode nil))

(defun my/text-mode-hook ()
  "Hooks for viewing and writing plain text"
  (setq fill-column 80)
  ;; (column-marker-1 80)
  (auto-fill-mode)
  (visual-line-mode)
  (page-break-lines-mode))

(defun my/racer-mode-hook ()
  "Hooks for racer-mode.el of Rust"
  (company-mode)
  (local-set-key [tab] #'company-indent-or-complete-common)
  (ac-racer-setup))



(defun my/clojure-mode-hook ()
  "Cider and stuff"
  (cider-mode)
  (local-set-key (kbd "C-c C-j") #'cider-jack-in))

(defun my/java-mode-hook ()
  "Exceptions for (cc-mode) etc for Java and Java-like languages"
  (setq indent-tabs-mode t
        c-basic-offset 4
        tab-width 4))

(defun my/lisp-mode-hook ( )
  "Collection of Lisp hooks"
  (local-set-key (kbd "{")   #'paredit-open-curly)
  (local-set-key (kbd "}")   #'paredit-close-curly)
  (local-set-key (kbd "M-(") #'paredit-wrap-round)
  (local-set-key (kbd "M-[") #'paredit-wrap-square)
  (local-set-key (kbd "M-{") #'paredit-wrap-curly)
  ;; (slime-mode)
  (paredit-mode))

(defun my/racket-mode-hook ()
  "Racket"
  ;; (setq tab-always-indent 'complete)
  (local-set-key (kbd "C-c r") #'racket-run))

;; (defun my/scheme-mode-hook ()
;;   "chikun"
;;   (require 'chicken-scheme)
;;   (define-key scheme-mode-map (kbd "C-M-?") 'chicken-show-help)
;;   (setup-chicken-scheme))

(defun my/makefile-mode-hook ()
  "fucking tabs"
  (setq indent-tabs-mode t))

(defun my/tuareg-mode-hook ()
  "Stuff for OCaml - doesn't work because tuareg sucks"
  (setq merlin-command 'opam)
  (merlin-mode)
  (merlin-eldoc-setup)
  (utop-minor-mode)
  (electric-indent-mode 0))

(defun my/python-mode-hook ()
  "Cleaning indentation for Python"
  (setq tab-width 4))

(defun my/rust-mode-hook ()
  "Helpful modes for autocomplete, also style stuff"
  (setq tab-width 4)
  (local-set-key (kbd "C-c TAB") #'rust-format-buffer)
  (cargo-minor-mode)
  (racer-mode)) ; see above

(defun my/sgml-mode-hook ()
  "stuff"
  (setq comment-continue " "))

(defun my/latex-mode-hook ()
  "For LaTeX"
  (latex-extra-mode))

(defun my/nxml-mode-hook ()
  "fuck --!"
  (setq comment-continue " "))


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

(defun reading-mode ()
  (interactive)
  (view-mode)
  (let ()
    (if (eq (frame-parameter (selected-frame) 'width) 70)
        (progn
          (set-frame-parameter (selected-frame) 'width 106)
          (variable-pitch-mode 0)
          (setq line-spacing nil)
          (setq word-wrap nil))
      (progn
        (set-frame-parameter (selected-frame) 'width 70)
        (variable-pitch-mode 1)
        (setq line-spacing 0.4)
        (setq word-wrap t)))))

(defun switch-to-minibuffer ()
  "Switch to minibuffer window (if active)"
  (interactive)
  (when (active-minibuffer-window)
    (select-frame-set-input-focus (window-frame (active-minibuffer-window)))
    (select-window (active-minibuffer-window))))
