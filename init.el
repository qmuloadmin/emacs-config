;; General setup of high level deps, paths, tabs, etc
(setq default-directory "/home/zach/Projects/src/github.com/OrderMyGear/")
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq x-select-enable-clipboard t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq-default truncate-lines t)
(setq auto-save-file-name-transforms
  `((".*" "~/.emacs-saves/" t)))
(load "~/.emacs.d/sql-config.el")
(setq make-backup-files nil) ;; Disable obnoxious backup files. 
(setq-default tab-width 4)
(desktop-save-mode 1)
(electric-pair-mode)
(global-tab-line-mode) ;; Enable buffer tabs in each window
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Better startup screen, org mode todo integration
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

;; Projectile for project aware searching (helm-projectile)
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1))

;; Helm search

(use-package helm
  :ensure t
  )

(use-package helm-projectile
  :ensure t
  )

(global-set-key (kbd "C-c r") 'helm-projectile-rg)
(global-set-key (kbd "C-c f") 'helm-projectile-find-file)

;; hs-mode (for code hiding/showing blocks)
(global-set-key (kbd "<M-up>") 'hs-hide-block)
(global-set-key (kbd "<M-down>") 'hs-show-block)

;; Goto line (based on evil :)
(global-set-key (kbd "C-:") 'goto-line)
(global-set-key (kbd "C-c l") 'helm-locate)

;; SQL Mode

(eval-after-load 'sql
  '(define-key sql-mode-map (kbd "<C-return>") 'sql-send-paragraph))
(eval-after-load 'sql
  '(define-key sql-mode-map (kbd "<M-return>") 'sql-send-region))

(defun buffer-to-sql-and-sqli ()
  (interactive)
  (sql-mode)
  (sql-set-sqli-buffer-generally)
)

(define-key global-map (kbd "C-c S") 'buffer-to-sql-and-sqli)

;; Magit
(unless (package-installed-p 'magit)
  (package-refresh-contents)
  (package-install 'magit))

(define-key global-map (kbd "C-c g") 'magit-status)

;; Org Mode
(use-package org
  :ensure t
  :hook
  ((org-mode . company))
  )
(require 'org)

;; Add go support for Org Babel
(use-package ob-go
  :ensure t)
(require 'ob-go)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((go . t)))

;; Add rust support for Org Babel
(use-package ob-rust
  :ensure t)
(require 'ob-rust)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((rust . t)))

;; HTTP Client For Org Mode
(use-package restclient
  :ensure t
  )

;; Sidebar Configuration

(use-package all-the-icons
  :ensure t
  )

(use-package all-the-icons-dired
  :ensure t
  )
(use-package dired-sidebar
  :bind (("C-x C-f" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-use-term-integration t)
)

;; Quick yaml config
(use-package yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  )

;; LSP-Mode optional deps
(unless (package-installed-p 'flycheck)
  (package-install 'flycheck))

;; Rust DE Configuration
;; Also, PHP, Go, Bash is buried in here, a hook about php-mode

(use-package rustic
  :ensure t
  :mode ("\\.rs\\'" . rustic-mode)
  :config
  (setq rustic-lsp-client 'lsp-mode
        rustic-lsp-server 'rust-analyzer
        rustic-analyzer-command '("~/.cargo/bin/rust-analyzer"))
  (define-key rustic-mode-map (kbd "C-c R") 'rustic-cargo-run)
  (define-key rustic-mode-map (kbd "C-c T") 'rustic-cargo-test)
  (define-key rustic-mode-map (kbd "C-c F") 'rustic-cargo-fmt)
  (add-hook 'rustic-mode-hook #'company-mode)
)

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm
  (setq-local buffer-save-without-query t))

;; PHP mode
(use-package php-mode
  :ensure t
)

(use-package lsp-mode
  :ensure t
  :hook
  ((go-mode . lsp))
  ((php-mode . lsp))
  ((sh-mode . lsp))
  ((python-mode . lsp))
  ((web-mode . lsp))
  :commands lsp
  :custom
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (add-hook 'lsp-mode-hook 'hs-minor-mode)
)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show nil)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable t)
  )

;; Random Custom stuff

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-matching-paren t)
 '(custom-safe-themes
   '("c2e1201bb538b68c0c1fdcf31771de3360263bd0e497d9ca8b7a32d5019f2fae" "33ea268218b70aa106ba51a85fe976bfae9cf6931b18ceaf57159c558bbcd1e6" "3b8284e207ff93dfc5e5ada8b7b00a3305351a3fb222782d8033a400a48eca48" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(dashboard-items '((projects . 5) (bookmarks . 5) (agenda . 5)))
 '(dashboard-projects-backend 'projectile)
 '(dired-sidebar-width 28)
 '(helm-locate-command "plocate %s -e --regex %s")
 '(horizontal-scroll-bar-mode nil)
 '(lsp-disabled-clients '(\"jsts-ls\"))
 '(lsp-file-watch-threshold 4000)
 '(lsp-intelephense-licence-key "004XGB7ZTX9SUL5")
 '(lsp-ui-doc-position 'at-point)
 '(lsp-ui-flycheck-list-position 'right)
 '(mouse-wheel-flip-direction t)
 '(mouse-wheel-tilt-scroll t)
 '(org-babel-load-languages
   '((emacs-lisp . t)
	 (python . t)
	 (shell . t)
	 (js . t)
	 (sql . t)))
 '(org-src-window-setup 'current-window)
 '(package-selected-packages
   '(ob-rust helm-rg dashboard doneburn-theme dired-sidebar all-the-icons anti-zenburn-theme php-mode spacemacs-theme zenburn-theme web-mode magit ob-restclient restclient helm yaml-mode yaml prettier-js clojure-mode flycheck company company-mode go-autocomplete go-complete go-mode auto-complete auth-complete lsp-ui lsp-mode rustic use-package s quelpa projectile ov frame-local dash-functional)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#292b2e" :foreground "#b2b2b2" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 98 :width normal :foundry "UKWN" :family "Iosevka Fixed Medium"))))
 '(tab-line-tab ((t (:inherit tab-line :background "gray" :foreground "black" :box (:line-width 2 :color "gray") :weight semi-bold :height 80 :width ultra-condensed))))
 '(tab-line-tab-inactive ((t (:inherit tab-line-tab :background "gray17" :foreground "white smoke" :box (:line-width 2 :color "gray17") :weight semi-bold)))))

;; Window resizing configuration
;; Set to C-c combined with WASD (capital) controls
;; Makes sense only in the case of the left-upper-most window (push border to right to enlarge, thus D)
;; Can be repeated easily with C-x z z z z z z

(global-set-key (kbd "C-c W") 'enlarge-window-vertically)
(global-set-key (kbd "C-c S") 'shrink-window-vertically)
(global-set-key (kbd "C-c A") 'shrink-window-horizontally)
(global-set-key (kbd "C-c D") 'enlarge-window-horizontally)

;; Window movement configuration
;; Set to C-c (user-space modifier) combined with WASD controls
;; For me, this is both intuitive and can be done single handed

(global-set-key (kbd "C-c a") 'windmove-left)
(global-set-key (kbd "C-c d") 'windmove-right)
(global-set-key (kbd "C-c w") 'windmove-up)
(global-set-key (kbd "C-c s") 'windmove-down)

;; More consistent Copy/Cut/Paste with "non emacs" bindings and mouse region selection

(global-set-key (kbd "C-S-c") 'kill-ring-save)
(global-set-key (kbd "C-S-x") 'kill-region)
(global-set-key (kbd "C-S-v") 'yank)

;; LSP Keybinds

(global-set-key (kbd "S-M-r") 'lsp-rename)

;; Update this path to match whatever path intelephense was installed in
(add-to-list 'exec-path "~/.nvm/versions/node/v10.20.1/bin/")
(add-to-list 'exec-path "~/bin/")
(add-to-list 'exec-path "~/.local/bin/")

;; Go DE Configuration

(unless (package-installed-p 'company)
  (package-refresh-contents)
  (package-install 'company))

;; Just to make sure go tools are enabled
(add-to-list 'exec-path "~/go/bin")

;; Go - lsp-mode

(defun go-before-save ()
  (interactive)
  (when go-mode
    (lsp-organize-imports)
    (lsp-format-buffer)))

(use-package go-mode
  :defer t
  :ensure t
  :config
  (add-hook 'go-mode-hook 'lsp-deferred)
  (add-hook 'go-mode-hook
            (lambda ()
              (add-hook 'before-save-hook 'go-before-save))))

;; DAP (standard protocol for remote debugging servers) Configuration

;;(use-package dap-mode
;;  :ensure t
;; )

;;(dap-register-debug-provider
;; "go"
;; (lambda (conf)
;;   (plist-put conf :debugPort 3334)
;;   (plist-put conf :host "localhost")
;;   conf))

;; Markdown support

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "markdown-it")
  :config (add-hook 'markdown-mode
				  (lambda ()
					   (make-local-variable 'truncate-lines)
					   (setq truncate-lines nil))))

;; JS Stuff

;; Prettier
(defun prettier-before-save ()
  (interactive)
  (when web-mode
	(prettier-js)
	))

(use-package prettier-js
  :ensure t
  :config (add-hook 'prettier-js-mode-hook
					(lambda()
					  (add-hook 'before-save-hook 'prettier-before-save)))
  )

;; Webmode for TSX highlighting (works with LSP)
(use-package web-mode  :ensure t
  :mode (("\\.js\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.ts\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.html\\'" . web-mode)
         ("\\.vue\\'" . web-mode)
		 ("\\.json\\'" . web-mode))
  :hook
  ((web-mode . prettier-js-mode))
  :commands web-mode
  :config
  (setq web-mode-content-types-alist
	'(("jsx" . "\\.js[x]?\\'")))
  )

;; Custom Window Layout at start
;; layout definition
(defun startup-layout ()
 (interactive)
 (delete-other-windows)
 (split-window-vertically) ;; -> --
 (split-window-horizontally) ;;  -> |
 (next-multiframe-window) ;; Move to Right Window
 (next-multiframe-window) ;; Move to Bottom Window
 (shrink-window 25) ;; Shrink to a couple lines of text
 (tab-line-mode) ;; disable tab line for this window
 (term "/bin/bash") ;; Start shell
 (set-window-dedicated-p (get-buffer-window) t) ;; Make the terminal invalid for other buffers
 (previous-multiframe-window) ;; Go back to Right Window
 (shrink-window-horizontally 20)
 (split-window-vertically) ;; -> --  so we have 1 left and 2 right, and a terminal below
 (previous-multiframe-window) ;; back to Left Window
)

;; execute the layout
;;(startup-layout)

;; Themes
(unless (package-installed-p 'zenburn-theme)
  (package-install 'zenburn-theme))
(unless (package-installed-p 'doneburn-theme)
  (package-install 'doneburn-theme))
(load-theme 'doneburn)
(load-file "/home/zach/.emacs.d/themes/uwu.el/uwu-theme.el")
(enable-theme 'uwu)

(defun toggle-theme ()
  (interactive)
  (if (eq (car custom-enabled-themes) 'uwu)
      (progn 
       (disable-theme 'uwu)
       (enable-theme 'doneburn)
      )
    (progn
     (disable-theme 'doneburn)
     (enable-theme 'uwu)
    ))
)

(global-set-key (kbd "C-S-t") 'toggle-theme)
(toggle-theme)
(toggle-theme)

;; Advice modifiers go here

(defun my-message-with-timestamp (old-func fmt-string &rest args)
   "Prepend current timestamp (with microsecond precision) to a message"
   (apply old-func
          (concat (format-time-string "[%F %T.%3N %Z] ")
                   fmt-string)
          args))

 (advice-add 'message :around #'my-message-with-timestamp)
 
