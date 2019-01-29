;;;; INIT
;;; Packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.milkbox.net/packages/") t)
(package-initialize)

;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line

;;; Import directories
(let ((default-directory "~/.emacs.d/site-lisp/")) ; local
  (normal-top-level-add-to-load-path '("." "themes")))
(let ((default-directory "/usr/share/emacs/site-lisp/")) ; system
  (normal-top-level-add-subdirs-to-load-path))
(let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))))

;;; Reduced clutter
(load "~/.emacs.d/local/keys.elc")
(load "~/.emacs.d/local/variables.elc")
(load "~/.emacs.d/local/functions.elc")
(load "~/.emacs.d/local/private.elc") ; contains mail stuff

;;; Prevent autogenerated clutter
(setq custom-file "~/.emacs.d/local/custom.el")
(load custom-file)

;;; Lazy loading
;; (autoload 'chicken-slime "chicken-slime" "SWANK backend for CHICKEN" t)
(autoload 'mu4e "mu4e" "Mail client" t)
(autoload 'merlin-mode "merlin" "OCaml Merlin" t nil)


;;; Chrome and bells, jingles & gongs and all that jive
;;; Themes
(require 'powerline)
(require 'moe-theme)
(setq moe-theme-highlight-buffer-id t
      powerline-default-separator (quote arrow-fade))
(moe-theme-random-color)
(moe-dark)
(powerline-moe-theme)
(add-hook 'after-make-frame-hook #'powerline-moe-theme)

;;; Font
(add-to-list 'default-frame-alist '(font . "Fira Code Erkin-9"))
(set-fontset-font t 'unicode "Unifont" nil 'prepend)
(set-fontset-font t 'unicode "Symbola" nil 'append)

;;; Transparency
(set-frame-parameter (selected-frame) 'alpha '(95 . 93))
(add-to-list 'default-frame-alist   '(alpha . (95 . 93)))


;;;; MODES
;;; Global major modes
(column-number-mode)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(size-indication-mode)
(which-function-mode)
;;; Custom
(annoying-arrows-mode)
(dired-async-mode)
(display-battery-mode)
(global-anzu-mode)
(global-undo-tree-mode)

;;; Encoding and text
(prefer-coding-system       'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)


;;;; HOOKS
;;; My own hooks (in functions.el)
(add-hook 'mail-mode-hook #'my/mail-mode-hook)
(add-hook 'prog-mode-hook #'my/prog-mode-hook)
(add-hook 'text-mode-hook #'my/text-mode-hook)

(add-hook 'compilation-mode-hook #'page-break-lines-mode)
(add-hook 'racer-mode-hook #'my/racer-mode-hook)

(add-hook 'c-mode-hook #'my/makefile-mode-hook)
(add-hook 'makefile-mode-hook #'my/makefile-mode-hook)
(add-hook 'nxml-mode-hook #'my/nxml-mode-hook)
(add-hook 'python-mode-hook #'my/python-mode-hook)
(add-hook 'rust-mode-hook #'my/rust-mode-hook)
(add-hook 'scheme-mode-hook #'my/scheme-mode-hook)
(add-hook 'sgml-mode-hook #'my/sgml-mode-hook)
(add-hook 'tex-mode-hook #'my/tex-mode-hook)
(add-hook 'tuareg-mode-hook #'my/caml-mode-hook)

;;; I hate Java.
(dolist (hook '(java-mode-hook
                groovy-mode-hook kotlin-mode-hook
                scala-mode-hook))
  (add-hook hook #'my/java-mode-hook)) ; as above

;;; Lisp hooks
(dolist (hook '(lisp-mode-hook
                clojure-mode-hook emacs-lisp-mode-hook
                racket-mode-hook))
  (add-hook hook #'my/lisp-mode-hook)) ; as above

(eldoc-add-command 'paredit-backward-delete 'paredit-close-round)

;;; Major modes for mysterious files
(add-to-list 'auto-mode-alist '("\\.rc$" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.conf$'" . conf-mode))
(add-to-list 'auto-mode-alist '("PKGBUILD" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.install$" . conf-mode))
(add-to-list 'auto-coding-alist '("\\.\\(nfo\\|NFO\\)\\'" . cp437-dos))
(add-to-list 'auto-mode-alist '("\\.system$" . scheme-mode))
