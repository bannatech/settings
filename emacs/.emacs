; Young .emacs for the powerful

(custom-set-variables
 '(make-backup-files nil)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(menu-bar-mode nil)
 '(tooltip-mode nil))

(add-to-list 'load-path "~/.emacs.d/")

;; Multiple Cursor
(add-to-list 'load-path "~/.emacs.d/multiple-cursors")
(require 'multiple-cursors)
(global-set-key (kbd "C-c d") 'mc/edit-lines)
(global-set-key (kbd "C-c x") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c n") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c p") 'mc/mark-previous-like-this)

(require 'autopair)
(autopair-global-mode)

;; keybind yo

(global-set-key (kbd "C-c {") 'enlarge-window-horizontally)
(global-set-key (kbd "C-c }") 'shrink-window-horizontally)

;; make whitespace-mode use just basic coloring

(setq whitespace-style (quote (spaces tabs space-mark tab-mark)))

(global-whitespace-mode 1)
