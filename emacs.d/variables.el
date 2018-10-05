;;;; Variables

;;; Disable init nuisance
(setq inhibit-startup-message t
      inhibit-startup-screen t
      inhibit-splash-screen t)

;;; clipboard
(setq select-enable-clipboard t
      select-enable-primary t
      save-interprogram-paste-before-kill t)

;;; Backup
(setq backup-by-copying-when-linked t
      kept-new-versions 6
      kept-old-versions 2
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
      tramp-terminal-type "tramp")

;;; Calendar
(setq calendar-latitude +41
      calendar-longitude +29
      calendar-mark-holidays-flag t)

(load "~/.emacs.d/holidays.elc")

(setq holiday-hebrew-holidays nil
      holiday-bahai-holidays nil ; sry but idc
      holiday-other-holidays (append holiday-discordian-holydays
                                     holiday-nerd-holidays
                                     holiday-turkish-holidays
                                     holiday-comestible-holidays
                                     holiday-misc-holidays))

;;;; General catch-all config stuff
(setq initial-scratch-message ";; scratchpad ;;\n"
      initial-major-mode 'text-mode
      show-paren-style 'expression
      show-paren-delay 0
      ;; debug-on-error t
      ag-highlight-search t
      inhibit-compacting-font-caches t)


;;;; Language specific config
;;; See also: functions.el

;;; C
(setq-default c-default-style "bsd"
              indent-tabs-mode t
              tab-width 8
              c-basic-offset 8
              comment-style 'multi-line
              cperl-indent-level 4)
(c-set-offset 'comment-intro 0)

;;; Scheme
(setq scheme-program-name "csi -wq /home/erkin/etc/chicken/csirc -:c")

;;; Rust
(setq rust-format-on-save t
      racer-cmd "~/usr/share/cargo/bin/racer"
      racer-rust-src-path "~/dev/repos/rust/src"
      company-tooltip-align-annotations t)

;;; org-mode
(setq org-log-done t
      org-html-validation-link nil
      org-todo-keywords '((sequence "TODO(t)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))
