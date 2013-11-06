

;;;; startup options
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)


;;;; remove toolbars
(menu-bar-mode -1)


;;;; misc. UI settings
; show the current line and column numbers
(line-number-mode t)
(column-number-mode t)
; highlight matching parens
(show-paren-mode t)


;;;; use versioned backups, don't clobber symlinks, and don't litter fs tree
(setq
 backup-by-copying t
 backup-directory-alist
 '(("." . "~/.emacs.d/saves"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-version 2
 version-control 5)


;;;; allow changing cases of regions
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)