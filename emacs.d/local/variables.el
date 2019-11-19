;;;; Variables

;; First of all;
(setq indent-tabs-mode nil)

;;; Disable init nuisance
(setq inhibit-startup-message t
      inhibit-startup-screen t
      inhibit-splash-screen t)

;;; clipboard
(setq select-enable-clipboard t
      select-enable-primary t
      save-interprogram-paste-before-kill t)

;;; mouse
(setq mouse-yank-at-point t
      mouse-autoselect-window t
      focus-follows-mouse t)

;;; Smooth scrolling
(setq redisplay-dont-pause t
      scroll-step 3
      scroll-margin 5
      scroll-conservatively 100
      scroll-preserve-screen-position 1
      mouse-wheel-scroll-amount '(3 ((shift) . 1))
      mouse-wheel-progressive-speed t
      fast-but-imprecise-scrolling nil
      jit-lock-defer-time 0)

;;; Backup
(setq backup-by-copying-when-linked t
      kept-new-versions 2
      kept-old-versions 1
      version-control t
      delete-old-versions t
      vc-make-backup-files t
      backup-directory-alist `(("." . "~/.emacs.d/backup/")))

;;; w3m
(setq w3m-coding-system 'utf-8
      w3m-file-coding-system 'utf-8
      w3m-home-page "https://start.duckduckgo.com/lite"
      w3m-terminal-coding-system 'utf-8
      w3m-use-favicon t)

;;; Tramp
(setq tramp-default-method "ssh"
      tramp-terminal-type "tramp"
      tramp-auto-save-directory "~/.emacs.d/backup/tramp/")

;;; mozc
;; (setq default-input-method "japanese-mozc"
;;       mozc-candidate-style 'overlay
;;       fcitx-use-dbus t)


;;;; Calendar
;;; Istanbul
(setq calendar-latitude +41
      calendar-longitude +29
      calendar-mark-holidays-flag t)

(load "~/.emacs.d/local/holidays.elc")
(setq holiday-hebrew-holidays nil
      holiday-bahai-holidays nil        ; sry but idc
      holiday-other-holidays (append holiday-discordian-holydays
                                     holiday-nerd-holidays
                                     holiday-turkish-holidays
                                     holiday-comestible-holidays
                                     holiday-misc-holidays))

;;; Initial mode
(setq initial-scratch-message ";; scratchpad ;;\n"
      initial-major-mode 'text-mode)

;;; show-paren-mode
(setq show-paren-style 'expression
      show-paren-delay 0)

;;; ediff mode
(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally
      ediff-diff-options "-w")

;;; Mosaic mode
(setq mosaic-project-directory "~/dev/repos/mosaic-el/"
      mosaic-use-jack-p nil)

;;;; General catch-all config stuff
(setq ag-highlight-search t
      inhibit-compacting-font-caches t
      use-dialog-box nil
      apropos-do-all t
      load-prefer-newer t)

;; (setq debug-on-error t)


;;;; Language specific config
;;; See also: functions.el

;;; ASM
(setq asm-comment-char 35) ;; '#'

;;; C
(setq-default c-default-style "bsd"
              tab-width 8
              c-basic-offset 8
              comment-style 'multi-line
              cperl-indent-level 4)
(c-set-offset 'comment-intro 0)

;;; dot
(setq graphviz-dot-auto-indent-on-newline nil
      graphviz-dot-auto-indent-on-semi nil
      graphviz-dot-auto-indent-on-braces t)

(setq TeX-view-program-selection
      '(((output-dvi has-no-display-manager) "dvi2tty")
	((output-dvi style-pstricks) "xdvi")
	(output-dvi "xdvi")
	(output-pdf "Zathura")
	(output-ps "Zathura")
	(output-html "firefox")))

;;; Scheme
;; (setq scheme-program-name "csi -wq /home/erkin/etc/chicken/csirc -:c")

;;; Rust
(setq rust-format-on-save t
      racer-cmd "~/usr/share/cargo/bin/racer"
      racer-rust-src-path "~/dev/repos/rust/src"
      company-tooltip-align-annotations t)

;;; org-mode
(setq org-log-done t
      org-list-allow-alphabetical t
      org-export-default-language "en-GB"
      org-export-with-author nil
      org-export-with-broken-links 'mark
      org-export-with-creator nil
      org-export-with-date nil
      org-export-with-email nil
      org-export-with-toc nil
      org-export-with-todo-keywords nil
      org-html-checkbox-type 'unicode
      org-html-doctype "html5"
      org-html-html5-fancy t
      org-html-htmlize-output-type 'css
      org-html-indent t
      org-html-use-infojs nil
      org-html-validation-link nil
      org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")))
