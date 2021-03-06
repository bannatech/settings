; Young .emacs for the powerful

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(make-backup-files nil)
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))

(add-to-list 'load-path "~/.emacs.d/")

;; Multiple Cursor
(add-to-list 'load-path "~/.emacs.d/multiple-cursors")
(require 'multiple-cursors)
(global-set-key (kbd "C-c d") 'mc/edit-lines)
(global-set-key (kbd "C-c x") 'mc/mark-all-like-this)
(global-set-key (kbd "M-n") 'mc/mark-next-like-this)
(global-set-key (kbd "M-p") 'mc/mark-previous-like-this)

(add-to-list 'load-path "go-mode-load.el" t)
(require 'go-mode-load)

(require 'autopair)
(autopair-global-mode)

;; keybind yo
(global-unset-key "\C-@")
(global-unset-key "\M-@")
(global-set-key (kbd "M-]") 'shrink-window-horizontally)
(global-set-key (kbd "M-[") 'enlarge-window-horizontally)
(global-set-key (kbd "C-SPC") 'forward-word)
(global-set-key (kbd "M-SPC") 'backward-word)
(global-set-key (kbd "C-q") 'set-mark-command)

;; make whitespace-mode use just basic coloring

(setq whitespace-style (quote (spaces tabs space-mark tab-mark)))
(global-set-key (kbd "C-c w") 'whitespace-mode)

(setq-default c-basic-offset 8
	      tab-width 8
	      indent-tabs-mode t)

