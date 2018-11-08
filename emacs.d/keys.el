;;;; KEYBINDINGS

;;; Navigation
(windmove-default-keybindings 'meta)
(global-set-key (kbd "<C-M-prior>") 'backward-page)
(global-set-key (kbd "<C-M-next>") 'forward-page)
(global-set-key (kbd "M-p") #'backward-paragraph)
(global-set-key (kbd "M-n") #'forward-paragraph)

;;; C-h → <DEL>
(setq help-char (string-to-char "<f1>"))
(global-set-key (kbd "C-h") #'delete-backward-char)
(global-set-key (kbd "M-h") #'backward-kill-word)
(define-key input-decode-map    (kbd "C-h") (kbd "DEL"))
(define-key input-decode-map    (kbd "M-h") (kbd "M-<DEL>"))
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))
(define-key key-translation-map (kbd "M-h") (kbd "M-<DEL>"))
(global-set-key [delete] #'delete-char)
(global-set-key [M-delete] #'kill-word)

;;; (suspend-emacs)? Nein, danke!
(global-set-key (kbd "C-z") ctl-x-map)

;;; For (org-mode)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c b") #'org-switchb)
(global-set-key (kbd "C-c c") #'org-capture)


;;; String stuff
(global-set-key (kbd "C-c C-r") #'replace-string)
(global-set-key (kbd "C-M-^") #'map-query-replace-regexp)
(global-set-key (kbd "H-1") #'replace-string)
(global-set-key (kbd "H-2") #'replace-regexp)
(global-set-key (kbd "H-3") #'query-replace)
(global-set-key (kbd "H-4") #'query-replace-regexp)
(global-set-key (kbd "H-5") #'map-query-replace-regexp)
(global-set-key (kbd "H-6") #'replace-rectangle)

;;; Multiple cursors
(require 'multiple-cursors)
(define-key mc/keymap (kbd "RET") nil)
(global-set-key (kbd "H-c")  #'mc/edit-lines)
(global-set-key (kbd "H->")  #'mc/mark-next-like-this)
(global-set-key (kbd "H-<")  #'mc/mark-previous-like-this)
(global-set-key (kbd "H-\"") #'mc/mark-all-like-this)
(global-set-key (kbd "C-H-c") #'mc/mark-all-like-this-dwim)
(global-set-key (kbd "M-H-c") #'mc/mark-more-like-this-extended)
(global-set-key (kbd "C-H-s") #'mc/sort-regions)
(global-set-key (kbd "M-H-s") #'mc/reverse-regions)
(global-set-key (kbd "H-SPC") #'set-rectangular-region-anchor)

;;; Avy
(require 'avy)
(global-set-key (kbd "C-,") #'avy-goto-char)
(global-set-key (kbd "C-.") #'avy-goto-char-2)
(global-set-key (kbd "H-l") #'avy-goto-line)

;;; Anzu
(require 'anzu)
(global-set-key              [remap query-replace]                #'anzu-query-replace)
(global-set-key              [remap query-replace-regexp]         #'anzu-query-replace-regexp)
(define-key isearch-mode-map [remap isearch-query-replace]        #'anzu-isearch-query-replace)
(define-key isearch-mode-map [remap isearch-query-replace-regexp] #'anzu-isearch-query-replace-regexp)

;;; Expand region
(require 'expand-region)
(global-set-key (kbd "H-p") #'er/expand-region)


;;; Mouse keys
(global-set-key (kbd "<mouse-8>") #'undo-tree-undo)
(global-set-key (kbd "<mouse-9>") #'undo-tree-redo)
(global-set-key (kbd "C-S-<mouse-1>") #'mc/add-cursor-on-click)

;;; Miscellaneous keys
(global-set-key (kbd "M-j") (lambda () (interactive) (join-line -1)))
(global-set-key (kbd "C-'") #'hippie-expand)
(global-set-key (kbd "M-?") #'mark-paragraph)
(global-set-key (kbd "H-k") #'browse-kill-ring)
(global-set-key (kbd "H-r") #'rectangle-mark-mode)
(global-set-key (kbd "C-c k") #'browse-kill-ring)
(global-set-key (kbd "C-c r") #'rectangle-mark-mode)
(global-set-key (kbd "C-c t") #'toggle-transparency)
(global-set-key (kbd "C-c y") #'clipboard-yank)

;;; Disabled but enabled
(put #'scroll-left 'disabled nil)
(put #'scroll-right 'disabled nil)
(put #'downcase-region 'disabled nil)
(put #'upcase-region 'disabled nil)
