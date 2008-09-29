(provide 'editor_options)

;;; visual themes:
(require 'zenburn)
;;(zenburn)

(setq x-select-enable-clipboard t)		; use clipboard to killing and yanking
(setq default-tab-width 4)				; tab width
(fset 'yes-or-no-p 'y-or-n-p)			; let me use `y/n` instead of `yes/no`
(mouse-wheel-mode t)					; let me use the mouse to scroll
(global-hl-line-mode 1)					; highlight the current line
(line-number-mode t)					; show current line-number in status bar
(delete-selection-mode t)				; allow selected lines to be deleted
;;(require 'jde)							; java devel environment for emacs

;;;; /********************************************************************\ ;;;;
;;;; Bind the `M-/` (`dabbrev-expand`) key to `TAB` for code completion
(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding
point."
  (interactive "*P")
  (if (and
       (or (bobp) (= ?w (char-syntax (char-before))))
       (or (eobp) (not (= ?w (char-syntax (char-after))))))
      (dabbrev-expand arg)
    (indent-according-to-mode)))
;;; If we’re at the end of a word boundary, invoke dabrev-expand.
;;; Otherwise,indent-according-to-mode. To avoid errors, the bobp and eobp calls
;;;  are there to make sure we’re not looking for characters before or after the
;;;  buffer’s boundary. An interactive prefix argument is optional and is passed
;;;  directly to dabbrev (C-h f dabbrev-expand for more info).


; Now we can bind it to the TAB key:
(defun my-tab-fix ()
  (local-set-key [tab] 'indent-or-expand))

; ok, now enable it for the different programming language modes
(add-hook 'c-mode-hook 'my-tab-fix)
(add-hook 'sh-mode-hook 'my-tab-fix)
(add-hook 'c++-mode-hook 'my-tab-fix)
(add-hook 'perl-mode-hook 'my-tab-fix)
(add-hook 'latex-mode-hook 'my-tab-fix)
(add-hook 'haskell-mode-hook 'my-tab-fix)
(add-hook 'emacs-lisp-mode-hook 'my-tab-fix)


;;;; /**********************************************************************\
;;;; |                    Set my own keybindings                            |

(global-set-key "\C-x/" 'comment-region)
(global-set-key "\C-x?" 'uncomment-region)
(global-set-key "\C-c=" 'align-regexp)




;;;; \_____________________________________________________________________/ ;;;



;;;; Change backup behavior t save in a directory, not in a bunch
;;;; of files all over the place.
;;; (setq
;;;   backup-by-copying t	;dont clobber symlinks
;;;   backup-directory-alist
;;;   '(("." . "~/.saves"))	;don't litter the fs tree
;;;   delete-old-versions t
;;;   kept-new-versions 6
;;;   kept-old-versions 2
;;;   version-control t)	;use versioned backups


;;;; \_____________________________________________________________________/ ;;;

;;; Allow flymake error messages to be displayed in the minibuffer
(when (fboundp 'resize-minibuffer-mode) ; for old emacs
  (resize-minibuffer-mode)
  (setq resize-minibuffer-window-exactly nil))

(defun credmp/flymake-display-err-minibuf () 
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no             (flymake-current-line-no))
		 (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
		 (count               (length line-err-info-list))
		 )
	(while (> count 0)
	  (when line-err-info-list
		(let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
			   (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
			   (text (flymake-ler-text (nth (1- count) line-err-info-list)))
			   (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
		  (message "[%s] %s" line text)
		  )
		)
	  (setq count (1- count)))))

;; bind the above function to the key '\C-c d'
(add-hook
 'haskell-mode-hook
 '(lambda ()
	(define-key haskell-mode-map "\C-cd"
	  'credmp/flymake-display-err-minibuf)))



;; use the Multi Major Mode support for literate haskell
(add-hook 'haskell-mode-hook 'my-mmm-mode)

(mmm-add-classes
 '((literate-haskell-bird
	:submode text-mode
	:front "^[^>]"
	:include-front true
	:back "^>\\|$"
	)
   (literate-haskell-latex
	:submode literate-haskell-mode
	:front "^\\\\begin{code}"
	:front-offset (end-of-line 1)
	:back "^\\\\end{code}"
	:include-back nil
	:back-offset (beginning-of-line -1)
	)))

(defun my-mmm-mode ()
  ;; go into mmm minor mode when class is given
  (make-local-variable 'mmm-global-mode)
  (setq mmm-global-mode 'true))

(setq mmm-sumode-decoration-level 0)


;;;; include GIT interfacing capabilities
(setq load-path (cons (expand-file-name "/usr/share/doc/git-core/contrib/emacs")
					  load-path))

;; vc-git is the VersionControl backend
(require 'vc-git)
(when (featurep 'vc-git) (add-to-list 'vc-handled-backends 'git))
(require 'git)
(autoload 'git-blame-mode "git-blame"
  "Minor mode for incremental blame for Git." t)
